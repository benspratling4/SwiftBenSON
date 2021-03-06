//
//  BenSONable.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/5/17.
//
//

import Foundation

/// A BenSON-able type is one which can read and write BenSON
public protocol BenSONable {
	
	func bensonData(at path:SubscriptPath, humanReadable:Bool)throws->Data
	
	
	init(benSONType:TypeSpec, data:Data, at path:SubscriptPath)throws
	
}

public class BenSONableError : Error {
	public var path:SubscriptPath
	
	public init(path:SubscriptPath) {
		self.path = path
	}
}

