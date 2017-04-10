//
//  DataWritingTests.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation
import XCTest
@testable import SwiftBenSON


open class DataWritingTests : XCTestCase {
	
	public func testHex() {
		let data = Data([0x00, 0x01, 0x02, 0x0E, 0x0F]).humanReadableBenson()
		XCTAssertEqual(data, "#x0001020E 0F".data(using: .utf8)!)
	}
	
	public func testHexLessThan4() {
		let data = Data([0x72, 0x05]).humanReadableBenson()
		XCTAssertEqual(data, "#x7205".data(using: .utf8)!)
	}
	
	public func testHexMoreThan2() {
		let data = Data([0x00, 0x01, 0xD2, 0x0E, 0x3F, 0x72, 0xB2, 0xE1, 0xF7, 0x3D, 0x11]).humanReadableBenson()
		XCTAssertEqual(data, "#x0001D20E 3F72B2E1 F73D11".data(using: .utf8)!)
	}
	
}
