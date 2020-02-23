/*
 * MIT License
 *
 * Copyright (c) 2020 Evgenii Makarov
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import QtQuick 2.0
import QtTest 1.0

import DummyTest 1.0

TestCase {
    name: "jspromisefactory_test"

    Test {
        id: test
    }

    function test_resolve_single_value() {
        let promise = test.tst_resolve_single_value();
        let ok = false;
        promise.then((value) => {
            compare(value, 144, "resolve single value");
            ok = true;
        });
        wait(1);
        compare(ok, true, "resolve single value");
    }

    function test_reject_single_value() {
        let promise = test.tst_reject_single_value();
        let ok = false;
        promise.catch((value) => {
            compare(value, "rejected", "reject single value");
            ok = true;
        });
        wait(1);
        compare(ok, true, "reject single value");
    }

    function test_resolve_values_list() {
        let promise = test.tst_resolve_values_list();
        let ok = false;
        promise.then((values) => {
            compare(values, [1,2,3], "resolve values list");
            ok = true;
        });
        wait(1);
        compare(ok, true, "resolve values list");
    }

    function test_reject_values_list() {
        let promise = test.tst_reject_values_list();
        let ok = false;
        promise.catch((values) => {
            compare(values, ["rejected", 17], "reject values list");
            ok = true;
        });
        wait(1);
        compare(ok, true, "reject values list");
    }

    function test_resolve_nothing() {
        let promise = test.tst_resolve_nothing();
        let ok = false;
        promise.then((value) => {
            compare(value, undefined, "resolve nothing");
            ok = true;
        });
        wait(1);
        compare(ok, true, "resolve nothing");
    }

    function test_reject_nothing() {
        let promise = test.tst_reject_nothing();
        let ok = false;
        promise.catch((value) => {
            compare(value, undefined, "reject nothing");
            ok = true;
        });
        wait(1);
        compare(ok, true, "reject nothing");
    }
}

