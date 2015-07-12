//
//  StreamReader.swift
//  ArabicDictionary
//
//  Created by Gilad Gurantz on 7/11/15.
//  Copyright (c) 2015 Lazy Arcade. All rights reserved.
//

import Foundation

// http://stackoverflow.com/questions/24581517/read-a-file-url-line-by-line-in-swift
public class StreamReader  {
    
    private let encoding: UInt
    private let chunkSize: Int
    private let fileHandle: NSFileHandle
    private let buffer: NSMutableData
    private let delimData: NSData
    private var atEof : Bool = false
    
    private init(fileHandle: NSFileHandle,
        buffer: NSMutableData,
        delimData: NSData,
        encoding: UInt,
        chunkSize: Int)
    {
        self.fileHandle = fileHandle
        self.buffer = buffer
        self.delimData = delimData
        self.encoding = encoding
        self.chunkSize = chunkSize
    }
    
    convenience init?(path: String,
        delimiter: String = "\n",
        encoding: UInt = NSUTF8StringEncoding,
        chunkSize: Int = 4096)
    {
        if let fileHandle = NSFileHandle(forReadingAtPath: path),
            delimData = delimiter.dataUsingEncoding(encoding),
            buffer = NSMutableData(capacity: chunkSize)
        {
            self.init(fileHandle: fileHandle,
                buffer: buffer,
                delimData: delimData,
                encoding: encoding,
                chunkSize: chunkSize)
        } else {
            self.init(fileHandle: NSFileHandle(),
                buffer: NSMutableData(),
                delimData: NSData(),
                encoding: 0,
                chunkSize: 0)
            return nil
        }
    }
    
    deinit {
        self.fileHandle.closeFile()
    }
    
    private func rangeOfDelimiter() -> NSRange {
        return self.buffer.rangeOfData(self.delimData,
            options: nil,
            range: NSMakeRange(0, self.buffer.length))
    }
    
    /// Return next line, or nil on EOF.
    public func nextLine() -> String? {
        if self.atEof {
            return nil
        }
        
        // Read data chunks from file until a line delimiter is found:
        var range = self.rangeOfDelimiter()
        
        while range.location == NSNotFound {
            let tmpData = self.fileHandle.readDataOfLength(chunkSize)
            if tmpData.length == 0 {
                // EOF or read error.
                self.atEof = true
                if buffer.length > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = NSString(data: self.buffer, encoding: self.encoding)
                    
                    self.buffer.length = 0
                    return line as String?
                }
                // No more lines.
                return nil
            }
            self.buffer.appendData(tmpData)
            range = self.rangeOfDelimiter()
        }
        
        // Convert complete line (excluding the delimiter) to a string:
        let line = NSString(data: self.buffer.subdataWithRange(NSMakeRange(0, range.location)),
            encoding: encoding)

        // Remove line (and the delimiter) from the buffer:
        self.buffer.replaceBytesInRange(NSMakeRange(0, range.location + range.length),
            withBytes: nil,
            length: 0)

        return line as String?
    }
    
    /// Start reading from the beginning of file.
    public func rewind() -> Void {
        self.fileHandle.seekToFileOffset(0)
        self.buffer.length = 0
        self.atEof = false
    }
}
