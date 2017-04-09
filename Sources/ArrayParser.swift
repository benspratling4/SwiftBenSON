//
//  ArrayParser.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation

open class ArrayParser : ScopedParser {
	
	public static func parser(reader:BytesReader)->ByteParser? {
		guard let byte = reader.read() else { return nil }
		if UnicodeScalar(byte) == "[" {
			return ArrayParser()
		}
		reader.pushBack(byte)
		return nil
	}
	
	private var objects:[Any] = []
	
	private var expectingObject:Bool = true
	
	public func read(from reader:BytesReader)->ParseAction {
		guard let byte:UInt8 = reader.read() else { return .invalidFormat }
		
		switch UnicodeScalar(byte) {
		case " ", "\t", "\n":
			//ignorable whitespace
			return .next
		case "]":
			//time to pop
			return .pop(objects)
		case ",":
			if expectingObject {
				return .invalidFormat
			}
			expectingObject = true
			return .next
		default:
			if !expectingObject {
				return .invalidFormat
			}
			reader.pushBack(byte)
			//some other kind of object
			return .push
		}
	}
	
	public func push(_ object:Any?) {
		if let newObject = object {
			objects.append(newObject)
			expectingObject = false	//expecting delimiter
		} else {
			//invalid format - this will cause an invalid format on next char
			expectingObject = true
		}
	}
}

