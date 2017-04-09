//
//  TypedParser.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation

open class TypedParser : ScopedParser {
	
	public static func parser(reader:BytesReader)->ByteParser? {
		guard let byte = reader.read() else { return nil }
		if UnicodeScalar(byte) == "<" {
			return TypedParser()
		}
		reader.pushBack(byte)
		return nil
	}
	
	private var typeSpec:TypeSpec?
	private var specParser:TagParser = TagParser()
	private var literal:Any?
	
	
	public func read(from reader:BytesReader)->ParseAction {
		guard let spec:TypeSpec = typeSpec else {
			switch specParser.read(from: reader) {
			case .next:
				return .next
			case .pop(let spec):
				typeSpec = spec as? TypeSpec
				if typeSpec == nil {
					return .invalidFormat
				}
				return .next
			case .push:	//tag parser never does this
				return .invalidFormat
			case .invalidFormat:
				return .invalidFormat
			}
		}
		
		if let value:Any = literal {
			if value is TypedValue {
				return .invalidFormat
			}
			return .pop(TypedValue(type: spec, value: value))
		}
		
		guard let byte:UInt8 = reader.read() else { return .invalidFormat }
		
		switch UnicodeScalar(byte) {
		case " ", "\t", "\n":
			//ignore white space
			return .next
		default:
			reader.pushBack(byte)
			return .push
		}

	}
	
	
	public func push(_ object:Any?) {
		if object == nil {
		}
		literal = object
	}
}

