//
//  ObjectParser.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation


open class ObjectParser : ScopedParser {
	
	public static func parser(reader:BytesReader)->ByteParser? {
		guard let byte = reader.read() else { return nil }
		if UnicodeScalar(byte) == "{" {
			return ObjectParser()
		}
		reader.pushBack(byte)
		return nil
	}
	
	private var objects:[AnyHashable:Any] = [:]
	
	private var lastKey:AnyHashable? = nil
	
	private var expectingObject:Bool = false
	private var expectingKey:Bool = true
	
	public func read(from reader:BytesReader)->ParseAction {
		guard let byte:UInt8 = reader.read() else { return .invalidFormat }
		
		switch UnicodeScalar(byte) {
		case " ", "\t", "\n":
			//ignorable whitespace
			return .next
		case "}":
			//time to pop
			return .pop(objects)
		case ":":
			if lastKey == nil {
				return .invalidFormat
			}
			expectingKey = false
			expectingObject = true
			return .next
		case ",":
			if lastKey != nil {
				return .invalidFormat
			}
			expectingObject = false
			expectingKey = true
			return .next
		default:
			if !expectingObject && !expectingKey {
				return .invalidFormat
			}
			reader.pushBack(byte)
			//some other kind of object
			return .push
		}
	}
	
	public func push(_ object:Any?) {
		if let newObject = object {
			if let key = lastKey {
				objects[key] = newObject
				lastKey = nil
				expectingObject = false
				expectingKey = false
			} else if let hashableKey = newObject as? AnyHashable {
				lastKey = hashableKey
				expectingKey = false
				expectingObject = false
			}
		} else {
			//invalid format - this will cause an invalid format on next char
			expectingObject = true
		}
	}
}
