//
//  BenSONParseError.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/8/17.
//
//

import Foundation


public struct BenSONParseError : Error {
	
	public var index:SubscriptPath
	
	public var code:Code
	
	public enum Code {
		case ZeroLengthTag
	}
	
	public init(index:SubscriptPath, code:Code) {
		self.index = index
		self.code = code
	}
}

