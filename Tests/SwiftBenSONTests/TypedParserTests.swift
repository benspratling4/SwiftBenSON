//
//  TypedParserTests.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation
import XCTest
@testable import SwiftBenSON


open class TypedValueParserTests : XCTestCase {
	
	
	func reader(for testString:String)->BytesReader {
		let data:Data = testString.data(using: .utf8)!
		return DataBytesReader(data: data)
	}
	
	open func testObjectOfString() {
		
		let byteReader:BytesReader = reader(for: "<pdf:.pdf>{\"a\":\"b\"}")
		let parser = ParseIterator(reader: byteReader)
		let value:Any? = parser.parse()
		guard let typedValue = value as? TypedValue else {
			XCTAssert(false, "value should be an object")
			return
		}
		XCTAssertEqual(typedValue.type.name, "pdf", "didn't parse tag")
		XCTAssertTrue(typedValue.type.fileExtensions.contains(".pdf"), "didn't parse tag")
		
	}



}
