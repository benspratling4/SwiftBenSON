//
//  ByteParser.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation


public enum ParseAction {
	case next	//read another byte
	case pop(Any?)	//remove me from the stack with object, or not
	case push	//indicates another object may get parsed
	case invalidFormat
}

public protocol ByteParser : class {
	
	/// read a byte from the bytes reader, push back if can't read
	/// return an instance of a parser if needed, it will go on the stack
	static func parser(reader:BytesReader)->ByteParser?
	
	func read(from reader:BytesReader)->ParseAction
	
}

public protocol LiteralByteParser : ByteParser {
	
}

open class CollectingBytesParser  {
	
	public private(set) var bytes:Data = Data()
	
	open func append(_ byte:UInt8) {
		bytes.append(byte)
	}
}


///sub-objects may get parsed inside here
public protocol ScopedParser : ByteParser {
	
	func push(_ object:Any?)
}

