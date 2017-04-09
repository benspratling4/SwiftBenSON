//
//  StringParser.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation

open class StringParser : CollectingBytesParser, ByteParser {
	
	public static func parser(reader:BytesReader)->ByteParser? {
		guard let byte = reader.read() else { return nil }
		if byte == 34 {	// "
			return StringParser()
		} else {
			reader.pushBack(byte)
			return nil
		}
	}
	
	private var escaping:Bool = false
	
	private func containedString()->String? {
		return String(data:bytes, encoding:.utf8)
	}
	
	public func read(from reader:BytesReader)->ParseAction {
		guard let byte:UInt8 = reader.read() else { return .invalidFormat }
		if escaping {
			switch byte {
			case 110:	//n
				append(10)
			case 116:	//t
				append(9)
			default:
				append(byte)
			}
			escaping = false
			return .next
		}
		switch byte {
		case 34:	// "
			return .pop(containedString())
		case 92:	// \
			escaping = true
			return .next
		default:
			append(byte)
			return .next
		}
		
	}
	
}



