//
//  ArrayParserTests.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation
import XCTest
@testable import SwiftBenSON


open class ArrayParserTests : XCTestCase {

	
	func reader(for testString:String)->BytesReader {
		let data:Data = testString.data(using: .utf8)!
		return DataBytesReader(data: data)
	}
	
	open func testArrayOfFloats() {
		
		let byteReader:BytesReader = reader(for: "[1.0, 2.0, 3.0, 4.0]")
		let parser = ParseIterator(reader: byteReader)
		let value:Any? = parser.parse()
		guard let floatsValue = value as? [Float80] else {
			XCTAssert(false, "value should be an array of floats")
			return
		}
		XCTAssertEqual(floatsValue, [1.0, 2.0, 3.0, 4.0], "did'nt correctly array or numbers correctly")
	}
	
	open func testArrayOfStrings() {
		
		let byteReader:BytesReader = reader(for: "[\"1.0\", \"2.0\", \"3.0\", \"4.0\"]")
		let parser = ParseIterator(reader: byteReader)
		let value:Any? = parser.parse()
		guard let stringsValue = value as? [String] else {
			XCTAssert(false, "value should be an array of strings")
			return
		}
		XCTAssertEqual(stringsValue, ["1.0", "2.0", "3.0", "4.0"], "did'nt correctly array or numbers correctly")
	}
	
	
	
}
