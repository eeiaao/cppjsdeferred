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

#pragma once

#include <QtQml/qjsvalue.h>
#include <QtQml/qqmlengine.h>

#include <QtCore/qmutex.h>

class PromiseFactory
{
public:
    ~PromiseFactory();

    QJSValue create(QQmlEngine *engine);

    void resolve(const QJSValue &promise, const QVariantList &args = {});
    void reject(const QJSValue &promise, const QVariantList &args = {});

private:
    void resolveArgumentsCountAndCall(QJSValue &callable, const QJSValue &instance,
                                      const QVariantList &args);

    QMutex m_mutex;
    QHash<QObject *, QQmlEngine *> m_hash;
};
