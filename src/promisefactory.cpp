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

#include "promisefactory.h"

#include <QtQml/qqmlcomponent.h>
#include <QtQml/qqmlengine.h>

PromiseFactory::PromiseFactory(QQmlEngine *engine)
{
    m_engine = engine;
}

PromiseFactory::~PromiseFactory()
{
}

void PromiseFactory::setQQmlEngine(QQmlEngine *engine)
{
    m_engine = engine;
}

QJSValue PromiseFactory::create(QQmlEngine *engine)
{
    const char *promise_qml {
        "import QtQuick 2.12\n"
        "QtObject {\n"
        "   function create() {\n"
        "       class Deferred {\n"
        "           constructor() {\n"
        "               this.promise = new Promise((resolve, reject) => {\n"
        "                   this.resolve_ = resolve;\n"
        "                   this.reject_  = reject;\n"
        "               });\n"
        "           }\n"
        "           then(success_cb, failure_cb) {\n"
        "               return this.promise.then(success_cb, failure_cb);\n"
        "           }\n"
        "           catch(func) {\n"
        "               return this.promise.catch(func)\n"
        "           }\n"
        "           resolve(v) {\n"
        "               this.resolve_(v);\n"
        "           }\n"
        "           reject(v) {\n"
        "               this.reject_(v);\n"
        "           }\n"
        "       }\n"
        "       let deferred = new Deferred();\n"
        "       return deferred;\n"
        "   }\n"
        "}\n"
    };

    auto qmlEngine = engine ? engine : m_engine;
    Q_ASSERT(qmlEngine);
    QQmlEngine::setObjectOwnership(qmlEngine, QQmlEngine::CppOwnership);
    auto qmlEngineObject = qmlEngine->newQObject(qmlEngine);

    QQmlComponent promiseComponent(qmlEngine);
    promiseComponent.setData(promise_qml, QUrl());

    auto container = promiseComponent.create();
    auto containerObject = qmlEngine->newQObject(container);

    QJSValue promise = containerObject.property("create").call();
    promise.setProperty("engine", qmlEngineObject);

    return promise;
}

void PromiseFactory::resolve(const QJSValue &promise, const QVariantList &args)
{
    auto resolve = promise.property("resolve");
    resolveArgumentsCountAndCall(resolve, promise, args);
}

void PromiseFactory::reject(const QJSValue &promise, const QVariantList &args)
{
    auto reject = promise.property("reject");
    resolveArgumentsCountAndCall(reject, promise, args);
}

void PromiseFactory::resolveArgumentsCountAndCall(QJSValue &callable, const QJSValue &instance, const QVariantList &args)
{
    Q_ASSERT(callable.isCallable());
    Q_ASSERT(instance.isObject());

    auto engine = instance.property("engine");
    auto engineObject = engine.toQObject();
    Q_ASSERT(engineObject);
    auto qmlEngine = static_cast<QQmlEngine*>(engineObject);
    Q_ASSERT(qmlEngine);

    QJSValueList arguments;
    if (args.size() > 1)
    {
        QJSValue argsArray = qmlEngine->newArray(static_cast<uint>(args.size()));
        for (int i = 0; i < args.size(); ++i)
        {
            argsArray.setProperty(static_cast<quint32>(i), qmlEngine->toScriptValue(args.at(i)));
        }
        arguments << argsArray;
    }
    else if (args.size() == 1)
    {
        arguments << qmlEngine->toScriptValue(args.at(0));
    }

    callable.callWithInstance(instance, arguments);
}
