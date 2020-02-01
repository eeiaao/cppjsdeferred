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

#include <QtCore/qtimer.h>
#include <QtQml/qqmlengine.h>
#include <QtQml/qqmlparserstatus.h>
#include <QtQuickTest/quicktest.h>

#include "promisefactory.h"

class DummyTest : public QObject, public QQmlParserStatus
{
    Q_OBJECT

public:
    explicit DummyTest(QObject* parent = nullptr)
        : QObject(parent)
        , QQmlParserStatus()
    {}


    void classBegin() override
    {
    }

    void componentComplete() override
    {
        auto engine = qmlEngine(this);
        Q_ASSERT(engine);
        m_promiseFactory.setQQmlEngine(engine);
    }

private:
    template<typename F>
    QJSValue withPromise(F&& fn)
    {
        auto promise = m_promiseFactory.create();
        QTimer::singleShot(0, this, [fn, promise]() mutable {
            fn(promise);
        });
        return promise;
    }

public Q_SLOTS:
    QJSValue tst_resolve_single_value()
    {
        return withPromise([this](QJSValue &promise) { m_promiseFactory.resolve(promise, {144}); });
    }

    QJSValue tst_reject_single_value()
    {
        return withPromise([this](QJSValue &promise) { m_promiseFactory.reject(promise, {"rejected"}); });
    }

    QJSValue tst_resolve_values_list()
    {
        return withPromise([this](QJSValue &promise) { m_promiseFactory.resolve(promise, {1, 2, 3}); });
    }

    QJSValue tst_reject_values_list()
    {
        return withPromise([this](QJSValue &promise) { m_promiseFactory.reject(promise, {"rejected", 17}); });
    }

    QJSValue tst_resolve_nothing()
    {
        return withPromise([this](QJSValue &promise) { m_promiseFactory.resolve(promise); });
    }

    QJSValue tst_reject_nothing()
    {
        return withPromise([this](QJSValue &promise) { m_promiseFactory.reject(promise); });
    }

private:
    PromiseFactory m_promiseFactory;
};

class Setup : public QObject
{
    Q_OBJECT

public Q_SLOTS:
    void qmlEngineAvailable(QQmlEngine *)
    {
        qmlRegisterType<DummyTest>("DummyTest", 1, 0, "Test");
    }
};

QUICK_TEST_MAIN_WITH_SETUP(test, Setup)

#include "main.moc"
