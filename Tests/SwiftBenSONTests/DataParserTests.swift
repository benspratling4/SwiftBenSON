//
//  DataParserTests.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation
import XCTest
@testable import SwiftBenSON


open class DataParserTests : XCTestCase {
	
	func reader(for testString:String)->BytesReader {
		let data:Data = testString.data(using: .utf8)!
		return DataBytesReader(data: data)
	}
	
	
	open func testByteLiteralRead() {
		let byteReader:BytesReader = reader(for: "#3:ABC")
		let parser = ParseIterator(reader: byteReader)
		let value:Any? = parser.parse()
		guard let dataValue = value as? Data else {
			XCTAssert(false, "value should be a Data")
			return
		}
		XCTAssertEqual(dataValue, Data([65, 66, 67]), "did'nt correctly parse bytes")
	}
	
	open func testByteHexRead() {
		let byteReader:BytesReader = reader(for: "#x020304")
		let parser = ParseIterator(reader: byteReader)
		let value:Any? = parser.parse()
		guard let dataValue = value as? Data else {
			XCTAssert(false, "value should be a Data")
			return
		}
		XCTAssertEqual(dataValue, Data([0x02, 0x03, 0x04]), "did'nt correctly parse bytes")
	}
	
	
	open func testBytesInAnArray() {
		let byteReader:BytesReader = reader(for: "[#x02 03 04, #12:ABCDEFGHIJKL]")
		let parser = ParseIterator(reader: byteReader)
		let value:Any? = parser.parse()
		guard let dataValues = value as? [Data] else {
			XCTAssert(false, "value should be a Data")
			return
		}
		XCTAssertEqual(dataValues, [Data([0x02, 0x03, 0x04]), Data([65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76])], "did'nt correctly parse bytes")
	}
}
