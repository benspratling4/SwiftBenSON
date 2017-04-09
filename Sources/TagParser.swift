//
//  TagParser.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation

open class TagParser : CollectingBytesParser, ByteParser {
	
	public static func parser(reader:BytesReader)->ByteParser? {
		guard let byte = reader.read() else { return nil }
		if byte == 60 {	// <
			return TagParser()
		} else {
			return nil
		}
	}
	
	private func containedString()->String? {
		return String(data:bytes, encoding:.utf8)
	}
	
	public func read(from reader:BytesReader)->ParseAction {
		guard let byte:UInt8 = reader.read() else { return .invalidFormat }
		switch byte {
		case 62:	// >
			guard let tagString = containedString()
				,let tag = try? TypeSpec(tag: tagString, index: SubscriptPath([])) else{
					return .invalidFormat
			}
			
			return .pop(tag)
		default:
			append(byte)
			return .next
		}
		
	}
	
}
