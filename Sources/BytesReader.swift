//
//  BytesReader.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation

//a protocol to which both a DataBytesReader and a StreamBytesReader conform
public protocol BytesReader : class {
	
	///
	var index:Int { get }
	
	///return nil if there are no more bytes
	func read()->UInt8?
	
	
	func pushBack(_ byte:UInt8)
}



public class DataBytesReader : BytesReader {
	
	private let data:Data
	public private(set) var index:Int
	private var backStack:[UInt8] = []
	
	public init(data:Data) {
		self.data = data
		index = 0
	}
	
	public func read()->UInt8? {
		if !backStack.isEmpty {
			return backStack.removeLast()
		}
		if index >= data.count {
			return nil
		}
		let byte:UInt8 = data[index]
		index += 1
		return byte
	}
	
	public func pushBack(_ byte:UInt8) {
		backStack.append(byte)
	}
	
}

extension UInt8 {
	/// 0b0xxxxxxx	== 0
	/// 0b10xxxxxx	== 1
	/// 0b110xxxxx	== 2
	/// 0b1110xxxx	== 3
	/// 0b11110xxx	== 4
	/// 0b111110xx	== 5
	/// 0b1111110x	== 6
	/// 0b11111110	== 7
	/// 0b11111111	== 8
	public var countConsecutiveHighBits:Int {
		if self & 0x80 == 0 { return 0 }
		if self & 0xC0 == 0x80 { return 1 }
		if self & 0xE0 == 0xC0 { return 2 }
		if self & 0xF0 == 0xE0 { return 3 }
		if self & 0xF8 == 0xF0 { return 4 }
		if self & 0xFC == 0xF8 { return 5 }
		if self & 0xFE == 0xFC { return 6 }
		if self & 0xFF == 0xFE { return 7 }
		return 8
	}
	///returns the databits of a utf8 byte, and the number of those bits
	public var utf8DataBits:(data:UInt8,count:Int) {
		switch countConsecutiveHighBits {
		case 1:
			return (0x3F & self, 6)
		case 2:
			return (0x1F & self, 5)
		case 3:
			return (0x0F & self, 4)
		case 4:
			return (0x07 & self, 3)
		case 5:
			return (0x03 & self, 2)
		case 6:
			return (0x01 & self, 1)
		case 7, 8:
			return (0,0)
		default:
			return (self, 7)
		}
	}
}


extension BytesReader {
	
	public func readUtf8()->UnicodeScalar? {
		guard let firstByte:UInt8 = read() else { return nil }
		//most western characters, the first bit will be zero, and we return it directly
		if firstByte & 0x80 == 0 {
			return UnicodeScalar(firstByte)
		}
		let (bits, count) = firstByte.utf8DataBits
		var scalar:UInt32 = UInt32(bits)
		var index:Int = 1
		while index < count {
			guard let secondByte = read() else { return nil }
			let (secondBits, secondCount) = secondByte.utf8DataBits
			if secondCount != 2 { return nil }	//invalid
			scalar <<= 6
			scalar |= UInt32(secondBits)
			index += 1
		}
		return UnicodeScalar(scalar)
	}
	
	public func readUtf8Bytes()->[UInt8]? {
		guard let firstByte:UInt8 = read() else { return nil }
		//most western characters, the first bit will be zero, and we return it directly
		if firstByte & 0x80 == 0 {
			return [firstByte]
		}
		let (bits, count) = firstByte.utf8DataBits
		var bytes:[UInt8] = [bits]
		var index:Int = 1
		while index < count {
			guard let secondByte = read() else { return nil }
			let (secondBits, secondCount) = secondByte.utf8DataBits
			if secondCount != 2 { return nil }	//invalid
			bytes.append(secondBits)
			index += 1
		}
		return bytes
	}
	
}
