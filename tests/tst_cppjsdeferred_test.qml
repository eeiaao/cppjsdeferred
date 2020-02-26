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
    name: "cppjsdeferred_test"

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

    function test_deferred_chaining() {
        let promise = test.tst_resolve_single_value();
        let ok = false;
        promise
        .then((value) => {
                  compare(value, 144, "deferred chaining (1)");
                  return test.tst_resolve_nothing();
              })
        .then((value) => {
                  compare(value, undefined, "deferred chaining (2)");
                  return test.tst_resolve_values_list();
              })
        .then((values) => {
                  compare(values, [1,2,3], "deferred chaining (3)");
                  ok = true;
              });
        wait(1);
        compare(ok, true, "deferred chaining");
    }

    function test_mixed_deferred_promise_chaining() {
        let promise = test.tst_resolve_single_value();
        let ok = false;
        promise
        .then((value) => {
                  compare(value, 144, "mixed deferred promise chaining (1)");
                  return test.tst_resolve_nothing();
              })
        .then((value) => {
                  compare(value, undefined, "mixed deferred promise chaining (2)");
                  return new Promise((resolve, reject) => {
                                        Qt.callLater(resolve.bind(this, 46));
                                     });
              })
        .then((value) => {
                  compare(value, 46, "mixed deferred promise chaining (3)");
                  return test.tst_resolve_values_list();
              })
        .then((values) => {
                  compare(values, [1,2,3], "mixed deferred promise chaining (4)");
                  ok = true;
              });
        wait(1);
        compare(ok, true, "mixed deferred promise chaining");
    }

    function test_exception() {
        let promise = test.tst_resolve_single_value();
        let ok = false;
        promise
        .then((value) => {
                  compare(value, 144, "exception test (1)");
                  throw new Error("error");
              })
        .catch((exc) => {
                   compare(exc, "Error: error", "exception test (2)");
                   ok = true;
               });
        wait(1);
        compare(ok, true, "exception test (3)");
    }

    function test_rejection() {
        let promise = test.tst_resolve_single_value();
        let ok = false;
        promise
        .then((value) => {
                  compare(value, 144, "rejection test (1)");
                  return Promise.reject(new Error("error"));
              })
        .catch((exc) => {
                   compare(exc, "Error: error", "rejection test (2)");
                   ok = true;
               });
        wait(1);
        compare(ok, true, "rejection test (3)");
    }

    function test_exception_chain_continuation() {
        let promise = test.tst_resolve_single_value();
        let ok = false;
        promise
        .then((value) => {
                  compare(value, 144, "exception test (1)");
                  throw new Error("error");
              })
        .catch((exc) => {
                   compare(exc, "Error: error", "exception test (2)");
               })
        .then(() => {
                  return new Promise((resolve, reject) => {
                                        Qt.callLater(resolve.bind(this, 46));
                                     });
              })
        .then((value) => {
                  compare(value, 46, "exception test (3)");
                  ok = true;
              })
        wait(1);
        compare(ok, true, "exception test (4)");
    }

    function test_rejection_chain_continuation() {
        let promise = test.tst_resolve_single_value();
        let ok = false;
        promise
        .then((value) => {
                  compare(value, 144, "rejection test (1)");
                  return Promise.reject(new Error("error"));
              })
        .catch((exc) => {
                   compare(exc, "Error: error", "rejection test (2)");
               })
        .then(() => {
                  return new Promise((resolve, reject) => {
                                        Qt.callLater(resolve.bind(this, 46));
                                     });
              })
        .then((value) => {
                  compare(value, 46, "rejection test (3)");
                  ok = true;
              })
        wait(1);
        compare(ok, true, "rejection test (4)");
    }

    function test_exception_chain_break() {
        let promise = test.tst_resolve_single_value();
        let ok = false;
        promise
        .then((value) => {
                  compare(value, 144, "exception test (1)");
                  throw new Error("error");
              })
        .catch((exc) => {
                   compare(exc, "Error: error", "exception test (2)");
                   throw exc;
               })
        .then(() => {
                  compare(true, false, "exception test: unreachable")
              })
        .catch(() => {
                   ok = true;
               });

        wait(1);
        compare(ok, true, "exception test (4)");
    }

    function test_rejection_chain_break() {
        let promise = test.tst_resolve_single_value();
        let ok = false;
        promise
        .then((value) => {
                  compare(value, 144, "rejection test (1)");
                  return Promise.reject(new Error("error"));
              })
        .catch((exc) => {
                   compare(exc, "Error: error", "rejection test (2)");
                   return Promise.reject(exc);
               })
        .then(() => {
                  compare(true, false, "rejection test: unreachable")
              })
        .catch(() => {
                   ok = true;
               });

        wait(1);
        compare(ok, true, "rejection test (4)");
    }
}

