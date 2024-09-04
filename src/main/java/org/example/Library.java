package org.example;

import java.io.File;
import java.net.URL;

public class Library {
    public int incIfTrue(int n, boolean condition) {
        if (condition) {
            return n + 1;
        } else {
            return n;
        }
    }

    public int decIfTrue(int n, boolean condition) {
        if (condition) {
            return n - 1;
        } else {
            return n;
        }
    }

    public static native int nativeIncIfTrue(int n, boolean condition);

    static {
        try {
            URL dylibUrl = Library.class.getResource("libcoverage_demo.dylib");
            if (dylibUrl == null) {
                dylibUrl = Library.class.getResource("libcoverage_demo.so");
            }
            System.load(new File(dylibUrl.toURI()).getPath());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
