use jni::objects::JClass;
use jni::JNIEnv;

pub fn rust_inc_if_true(n: i32, condition: bool) -> i32 {
    if condition {
        return n + 1;
    } else {
        return n;
    }
}

pub fn rust_dec_if_true(n: i32, condition: bool) -> i32 {
    if condition {
        return n - 1;
    } else {
        return n;
    }
}

#[no_mangle]
pub extern "system" fn Java_org_example_Library_nativeIncIfTrue(
    _env: JNIEnv,
    _class: JClass,
    n: i32,
    condition: bool,
) -> i32 {
    if condition {
        return n + 1;
    } else {
        return n;
    }
}

#[cfg(test)]
mod tests;
