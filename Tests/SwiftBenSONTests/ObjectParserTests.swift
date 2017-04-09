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


open class ObjectParserTests : XCTestCase {

	
	func reader(for testString:String)->BytesReader {
		let data:Data = testString.data(using: .utf8)!
		return DataBytesReader(data: data)
	}
	
	open func testObjectOfString() {
		
		let byteReader:BytesReader = reader(for: "{\"a\":\"b\"}")
		let parser = ParseIterator(reader: byteReader)
		let value:Any? = parser.parse()
		guard let objectValue = value as? [AnyHashable:Any] else {
			XCTAssert(false, "value should be an object")
			return
		}
		XCTAssertEqual(objectValue["a"] as? String, "b", "didn't correctly parse object")
	}
	
	open func testObjectOfStrings() {
		
		let byteReader:BytesReader = reader(for: "{\"a\" : \"b\" , \"c\": \"d\"}")
		let parser = ParseIterator(reader: byteReader)
		let value:Any? = parser.parse()
		guard let objectValue = value as? [AnyHashable:Any] else {
			XCTAssert(false, "value should be an object")
			return
		}
		XCTAssertEqual(objectValue["a"] as? String, "b", "didn't correctly parse object")
		
		XCTAssertEqual(objectValue["c"] as? String, "d", "didn't correctly parse object")
	}
	
	
	open func testObjectOfObjects() {
		
		let byteReader:BytesReader = reader(for: "{\"a\" : 17.0 , \"c\": \"d\", 4:[#x040506]}")
		let parser = ParseIterator(reader: byteReader)
		let value:Any? = parser.parse()
		guard let objectValue = value as? [AnyHashable:Any] else {
			XCTAssert(false, "value should be an object")
			return
		}
		XCTAssertEqual(objectValue["a"] as? Float80, 17.0, "didn't correctly parse object")
		XCTAssertEqual(objectValue["c"] as? String, "d", "didn't correctly parse object")
		guard let fourData = objectValue[4.0 as Float80] as? [Data] else {
			XCTAssert(false, "didn't use 4 as key")
			return
		}
		
		XCTAssertEqual(fourData[0], Data([0x04, 0x05, 0x06]), "didn't correctly parse object")
	}
	
	
}
