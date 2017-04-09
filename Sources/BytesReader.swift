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
