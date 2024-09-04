package org.example;

import org.junit.Assert;
import org.junit.Test;


public class LibraryTest {
    @Test
    public void testIncWhenTrue() {
        var lib = new Library();
        var result = lib.incIfTrue(1, true);
        Assert.assertEquals(2, result);
    }

    @Test
    public void testDecWhenTrue() {
        var lib = new Library();
        var result = lib.incIfTrue(1, true);
        Assert.assertEquals(0, result);
    }

    @Test
    public void testIncWhenFalse() {
        var lib = new Library();
        var result = lib.incIfTrue(1, false);
        Assert.assertEquals(1, result);
    }

    @Test
    public void testNativeIncWhenTrue() {
        var result = Library.nativeIncIfTrue(1, true);
        Assert.assertEquals(2, result);
    }

    @Test
    public void testNativeIncWhenFalse() {
        var result = Library.nativeIncIfTrue(1, false);
        Assert.assertEquals(1, result);
    }
}
