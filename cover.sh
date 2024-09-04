#!/bin/bash
set -eux

if [ "$(uname)" == "Linux" ]; then
  executable_filter="-executable"
  dylib_ext="so"
else
  # Assume MacOS
  executable_filter="-perm +111"
  dylib_ext="dylib"
fi

cd $(dirname $0)

# Install LLVM coverage tools
rustup component add llvm-tools-preview
LLVM_TOOLS_PATH=$(dirname $(find $HOME/.rustup -name llvm-profdata))
PATH=$LLVM_TOOLS_PATH:$PATH

# Clean all build artifacts
./clean.sh

# Maven test with coverage reporting
LLVM_PROFILE_FILE=maven-test.profraw mvn clean test

# Process raw coverage data
llvm-profdata merge -sparse -o rust-coverage.profdata maven-test.profraw rust/coverage-demo/cargo-test.profraw
test_bin=$(find target/rust-maven-plugin/coverage-demo/debug/deps -type f $executable_filter | grep demo-)
llvm-cov show --format=html --ignore-filename-regex='(.cargo/registry|rustc/.*\.rs)' \
  --instr-profile rust-coverage.profdata \
  --object $test_bin \
  --object target/classes/org/example/libcoverage_demo.$dylib_ext \
  --output-dir=rust-coverage
llvm-cov export --format=lcov --ignore-filename-regex='(.cargo/registry|rustc/.*\.rs)' \
  --instr-profile rust-coverage.profdata \
  --object $test_bin \
  --object target/classes/org/example/libcoverage_demo.$dylib_ext \
  > rust-coverage.lcov
[ ! -f lcov_cobertura.py ] && wget \
  https://raw.githubusercontent.com/eriwen/lcov-to-cobertura-xml/master/lcov_cobertura/lcov_cobertura.py
python3 lcov_cobertura.py rust-coverage.lcov --output rust-coverage.xml --base-dir rust/coverage-demo/src

java -jar lib/cover-checker-1.5.0-all.jar \
  -type jacoco --cover target/site/jacoco/jacoco.xml \
  -type cobertura --cover rust-coverage.xml \
  --repo "mtopolnik/coverage-demo" --pr $2 --github-token $1 \
  --threshold 50
