//
//  DataParser.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation




open class DataParser : CollectingBytesParser, ByteParser {
	
	public static func parser(reader:BytesReader)->ByteParser? {
		guard let byte = reader.read() else { return nil }
		if UnicodeScalar(byte) == "#" {
			guard let next = reader.read() else { return nil }
			if UnicodeScalar(next) == "x" {
				return DataHexParser()
			} else {
				reader.pushBack(next)
				return DataParser()
			}
		} else {
			reader.pushBack(byte)
			return nil
		}
	}
	
	private var readLength:Bool = false
	
	private var expectedLength:Int?
	
	private var lengthStringBytes:[UInt8] = []
	
	private var lenthComponents:[Int] = []
	
	public func read(from reader:BytesReader)->ParseAction {
		guard let byte:UInt8 = reader.read() else { return .invalidFormat }
		
		if readLength {
			append(byte)
			if bytes.count == expectedLength {
				return .pop(bytes)
			}
			return .next
		}
		if UnicodeScalar(byte) == "," {
			guard let lengthString:String = String(data:Data(lengthStringBytes), encoding:.utf8)
				,let length:Int = Int(lengthString)
				else { return .invalidFormat }
			expectedLength = length * (expectedLength ?? 1)
			lengthStringBytes = []
			return .next
		}
		
		if UnicodeScalar(byte) == ":" {
			guard let lengthString:String = String(data:Data(lengthStringBytes), encoding:.utf8)
				,let length:Int = Int(lengthString)
				else { return .invalidFormat }
			expectedLength = length * (expectedLength ?? 1)
			readLength = true
			return .next
		}
		lengthStringBytes.append(byte)
		return .next
	}
}


open class DataHexParser : CollectingBytesParser , ByteParser{
	///don't call me, use DataParser instead
	public static func parser(reader:BytesReader)->ByteParser? {
		return nil
	}
	
	var highBits:UInt8?
	
	static let validChars:CharacterSet = CharacterSet(charactersIn: "0123456789abcdefgABCDEFG \n\r\t")
	
	public func read(from reader:BytesReader)->ParseAction {
		guard let byte:UInt8 = reader.read() else {
			if highBits == nil {
				return .pop(bytes)
			}
			return .invalidFormat
		}
		switch UnicodeScalar(byte) {
		case " ", "\n", "\r", "\t":
			return .next
		case "0"..."9", "a"..."f", "A"..."F":
			addHexByte(byte)
			return .next
		default:
			reader.pushBack(byte)
			return .pop(bytes)
		}
	}
	
	private func addHexByte(_ byte:UInt8) {
		guard let bits:UInt8 = self.highBits else {
			self.highBits = maskedBits(byte) << 4
			return
		}
		let newByte = bits | maskedBits(byte)
		append(newByte)
		self.highBits = nil
	}
	
	private func maskedBits(_ byte:UInt8)->UInt8 {
		switch byte {
		case 0x30...0x39:
			return byte & 0x0F
		case 0x41...0x46:
			return byte-0x41+10
		case 0x61...0x66:
			return byte-0x61+10
		default:
			//developer error
			return 0
		}
	}
	
}
