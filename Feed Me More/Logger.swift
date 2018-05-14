//
//  Logger.swift
//  Feed Me More
//
//  Created by macbook on 15.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import Foundation

class Logger {
    
    enum LogLevel: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
        case fatal = "FATAL"
    }
    
    static let defaultLevel: LogLevel = .warning
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    class func log(_ message: String,
                   level: LogLevel = defaultLevel,
                   fileName: String = #file,
                   line: Int = #line,
                   funcName: String = #function) {
        
        #if !DEBUG
        if level == .debug {
            return
        }
        #endif
        NSLog("[%@] [%@:%ld] %@ -> %@", level.rawValue, sourceFileName(filePath: fileName), line, funcName, message)
    }
    
    class func debug(_ text: String,
                     fileName: String = #file,
                     line: Int = #line,
                     funcName: String = #function) {
        log(text, level: .debug, fileName: fileName, line: line, funcName: funcName)
    }
    
    class func info(_ text: String,
                    fileName: String = #file,
                    line: Int = #line,
                    funcName: String = #function) {
        log(text, level: .info, fileName: fileName, line: line, funcName: funcName)
    }
    
    class func warn(_ text: String,
                    fileName: String = #file,
                    line: Int = #line,
                    funcName: String = #function) {
        log(text, level: .warning, fileName: fileName, line: line, funcName: funcName)
    }
    
    class func error(_ text: String,
                     fileName: String = #file,
                     line: Int = #line,
                     funcName: String = #function) {
        log(text, level: .error, fileName: fileName, line: line, funcName: funcName)
    }
    
    class func fatal(_ text: String,
                     fileName: String = #file,
                     line: Int = #line,
                     funcName: String = #function) {
        log(text, level: .fatal, fileName: fileName, line: line, funcName: funcName)
    }
}
