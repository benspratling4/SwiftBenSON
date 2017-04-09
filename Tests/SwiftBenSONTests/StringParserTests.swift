//
//  TypeSpec.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/5/17.
//
//

import Foundation
import XCTest
@testable import SwiftBenSON


open class StringParserTests : XCTestCase {
	
	func reader(for testString:String)->BytesReader {
		let data:Data = testString.data(using: .utf8)!
		return DataBytesReader(data: data)
	}
	
	open func testStringStart() {
		let byteReader:BytesReader = reader(for: "\"a\"")
		let parser:ByteParser? = StringParser.parser(reader: byteReader)
		XCTAssertNotNil(parser, "quote character should begin parsing")
	}
	
	open func testStringRead() {
		let byteReader:BytesReader = reader(for: "\"a\"")
		let parser = ParseIterator(reader: byteReader)
		let value:Any? = parser.parse()
		guard let stringValue = value as? String else {
			XCTAssert(false, "value should be a string")
			return
		}
		XCTAssertEqual(stringValue, "a", "did'nt correctly parse string")
	}
	
	open func testStringEscapeN() {
		let byteReader:BytesReader = reader(for: "\"a\\n\"")
		let parser = ParseIterator(reader: byteReader)
		let value:Any? = parser.parse()
		guard let stringValue = value as? String else {
			XCTAssert(false, "value should be a string")
			return
		}
		XCTAssertEqual(stringValue, "a\n", "didn't correctly parse string")
	}
	
	open func testStringEscapeT() {
		let byteReader:BytesReader = reader(for: "\"a\\t\"")
		let parser = ParseIterator(reader: byteReader)
		let value:Any? = parser.parse()
		guard let stringValue = value as? String else {
			XCTAssert(false, "value should be a string")
			return
		}
		XCTAssertEqual(stringValue, "a\t", "didn't correctly parse string")
	}
	
	open func testStringEscapeQuote() {
		let byteReader:BytesReader = reader(for: "\"a\\\"\"")
		let parser = ParseIterator(reader: byteReader)
		let value:Any? = parser.parse()
		guard let stringValue = value as? String else {
			XCTAssert(false, "value should be a string")
			return
		}
		XCTAssertEqual(stringValue, "a\"", "didn't correctly parse string")
	}
}
