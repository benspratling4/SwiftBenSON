//
//  NumberParserTests.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation
import XCTest
@testable import SwiftBenSON


open class NumberParserTests : XCTestCase {

	func reader(for testString:String)->BytesReader {
		let data:Data = testString.data(using: .utf8)!
		return DataBytesReader(data: data)
	}
	
	open func testNumbers() {
		let testCases:[(String,Float80)] = [
			("1", 1.0)
			,("2.5", 2.5)
			,("-10.3", -10.3)
			,("1.3e4", 1.3e4)
		]
		for (text, cert) in testCases {
			let byteReader:BytesReader = reader(for: text)
			let parser = ParseIterator(reader: byteReader)
			let value:Any? = parser.parse()
			guard let floatValue = value as? Float80 else {
				XCTAssert(false, "value should be a float")
				return
			}
			XCTAssertEqual(floatValue, cert, "did'nt correctly parse number")
		}
	}
}
