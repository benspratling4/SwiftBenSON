//
//  NumericalParser.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation

open class NumericalParser : CollectingBytesParser, ByteParser {
	
	///characters which can begin a number, float or int
	private static let introChars:CharacterSet = CharacterSet(charactersIn: "-0123456789.+")
	
	private static let continuationChars:CharacterSet = CharacterSet(charactersIn: "-0123456789.+e^")
	
	public static func parser(reader:BytesReader)->ByteParser? {
		guard let byte:UInt8 = reader.read() else { return nil }
		let char = UnicodeScalar(byte)
		if NumericalParser.introChars.contains(char) {
			return NumericalParser(byte: byte)
		}
		reader.pushBack(byte)
		return nil
	}
	
	public init(byte:UInt8) {
		super.init()
		append(byte)
	}
	
	private func computeNumber()->Any? {
		guard let string = String(data:bytes, encoding:.utf8) else { return nil }
		//TODO: recognize infinity explicitly
		//TODO: replace ^ with e
		return Float80(string)
	}
	
	private var includedExponent:Bool = false
	private var includedDecimal:Bool = false
	
	public func read(from reader:BytesReader)->ParseAction {
		guard let byte:UInt8 = reader.read() else {
			if let number = computeNumber() {
				return .pop(number)
			}
			return .invalidFormat
		}
		let char = UnicodeScalar(byte)
		if !NumericalParser.continuationChars.contains(char) {
			reader.pushBack(byte)
			if let number = computeNumber() {
				return .pop(number)
			}
			return .invalidFormat
		}
		//certain logic
		
		if (char == "-" || char == "+") && ((bytes.last != 101 && bytes.last != 69) || (bytes.last != 94)) {	//101 = e, 69 = E, 94 = ^
			return .invalidFormat
		}
		let isExponent:Bool = char == "e" || char == "E" || char == "^"
		if isExponent {
			if includedExponent {
				//no doubling up on the exponents
				return .invalidFormat
			} else {
				includedExponent = true
				includedDecimal = false
				append(byte)
				return .next
			}
		}
		if char == "." {
			if includedDecimal {
				return .invalidFormat
			} else {
				includedDecimal = true
				append(byte)
				return .next
			}
		}
		//collect continuation characters
		append(byte)
		return .next
	}
	
}

