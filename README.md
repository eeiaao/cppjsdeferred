# cppjsdeferred 
![C/C++ CI](https://github.com/eeiaao/jspromisefactory/workflows/C/C++%20CI/badge.svg?branch=master)

Helper for an asynchronous interactions between Qt and QML.
Provides a bridge between asynchronous operations in C++ backend and user interface written in QML.  
Create a Promise on C++ side, return it to QML, tune on a reaction, then resolve or reject the Promise with necessary arguments in future. That's it.

[See tests for futher details](tests)

Known issues:
  * Returning rejected Promise and exceptions throwing from then/catch handlers was broken until Qt 5.13.2 due to https://bugreports.qt.io/browse/QTBUG-78554
