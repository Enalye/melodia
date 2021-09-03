/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.handler;

import std.stdio, core.thread;
import minuit, grimoire, atelier;
import melodia.script, melodia.gui;

private final class ScriptHandler {
    private final class TimeoutThread : Thread {
        private {
            __gshared ScriptHandler _script;
        }
        shared bool isRunning = true;

        this(ScriptHandler script) {
            _script = script;
            super(&run);
        }

        void run() {
            try {
                while (isRunning) {
                    auto currentCycle = _script._cycle;
                    sleep(dur!("msecs")(1000));
                    if (currentCycle == _script._cycle && _script._isLoaded) {
                        if (_script._isProcessing) {
                            _script._engine.isRunning = false;
                            //writeln("Plugin script timeout: ", currentCycle, ", ", _script._isLoaded);
                            isRunning = false;
                        }
                    }
                    //writeln("Thread: ", isRunning, ", prev cycle: ", currentCycle,
                    //", next cycle: ", _script._cycle, ", loaded ? ", _script._isLoaded);
                }
            }
            catch (Exception e) {
                logMessage("Script timeout error: " ~ e.msg);
            }
        }
    }

    private {
        GrEngine _engine;
        shared int _cycle;
        shared bool _isLoaded = false;
        shared bool _isProcessing = false;
        TimeoutThread _timeout;
        GrData _data;
        GrBytecode _bytecode;
        string _filePath;
        GrError _error;
        GrLibrary _stdLib, _melodiaLib;
    }

    this() {
        _stdLib = grLoadStdLibrary();
        _melodiaLib = loadMelodiaLibrary();
    }

    void cleanup() {
        _isProcessing = false;
        if (_engine)
            _engine.isRunning = false;
        _isLoaded = false;
        if (_timeout)
            _timeout.isRunning = false;
        _timeout = null;
    }

    void load(string filePath) {
        try {
            _filePath = filePath;

            GrCompiler compiler = new GrCompiler;
            compiler.addLibrary(_stdLib);
            compiler.addLibrary(_melodiaLib);
            _bytecode = compiler.compileFile(_filePath, GrOption.symbols);
            if (!_bytecode) {
                _isLoaded = false;
                _error = compiler.getError();
                cleanup();
                return;
            }

            _engine = new GrEngine;
            _engine.addLibrary(_stdLib);
            _engine.addLibrary(_melodiaLib);
            _engine.load(_bytecode);
            _engine.spawn();

            _timeout = new TimeoutThread(this);
            _timeout.start();
            _isLoaded = true;
        }
        catch (Exception e) {
            logMessage(e.msg);
            cleanup();
        }
        catch (Error e) {
            logMessage(e.msg);
            //We need to atleast kill the hanging thread.
            cleanup();
            throw e;
        }
    }

    void reload() {
        import std.file : exists;

        if (!_filePath.length)
            return;
        if (!exists(_filePath))
            return;
        cleanup();
        load(_filePath);
    }

    void restart() {
        if (!_isLoaded)
            return;
        try {
            _isLoaded = false;
            _engine = new GrEngine;
            _engine.load(_bytecode);
            _engine.spawn();
            _isLoaded = true;
        }
        catch (Exception e) {
            logMessage(e.msg);
            cleanup();
        }
        catch (Error e) {
            logMessage(e.msg);
            //We need to atleast kill the hanging thread.
            cleanup();
            throw e;
        }
    }

    void run() {
        import std.conv : to;

        if (_error) {
            /// @TODO: Error
            _error = null;
        }
        if (!_isLoaded)
            return;
        try {
            _isProcessing = true;
            _engine.process();
            _isProcessing = false;
            _cycle = _cycle + 1;
            if (_engine.isPanicking) {
                _timeout.isRunning = false;
                throw new Exception("Panic: " ~ to!string(_engine.panicMessage));
            }
            else if (!_engine.hasCoroutines) {
                _timeout.isRunning = false;
            }
        }
        catch (Exception e) {
            logMessage(e.msg);
            cleanup();
        }
        catch (Error e) {
            logMessage(e.msg);
            //We need to atleast kill the hanging thread.
            cleanup();
            throw e;
        }
    }

    void kill() {
        cleanup();
    }
}

private {
    ScriptHandler _handler;
    string _onNoteEnterEventName, _onNoteHitEventName, _onNoteExitEventName,
        _onNoteInputEventName, _onStartEventName, _onEndEventName, _onFileDropEventName;
    Logger _logger;
}

///Setup the script handler.
void initializeScript() {
    _handler = new ScriptHandler;
}

void setScriptLogger(Logger logger) {
    _logger = logger;
}

private void logMessage(string msg) {
    if (!_logger)
        return;
    _logger.add(msg);
}

///Compile and load the script.
void loadScript(string filePath) {
    if (!_handler)
        return;
    _handler.load(filePath);
}

///Process a single pass of the VM.
void runScript() {
    if (!_handler)
        return;
    _handler.run();
}

///Recompile the file.
void reloadScript() {
    if (!_handler)
        return;
    _handler.reload();
}

///Relaunch the VM without recompiling.
void restartScript() {
    if (!_handler)
        return;
    _handler.restart();
}

///Call upon quitting the program.
void killScript() {
    if (!_handler)
        return;
    _handler.kill();
}

string getScriptFilePath() {
    return _handler ? _handler._filePath : "";
}