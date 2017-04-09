//
//  ScopeParser.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation


open class ParseIterator {
	
	private let reader:BytesReader
	
	public init(reader:BytesReader) {
		self.reader = reader
	}
	
	private var parserStack:[ByteParser] = []
	
	open lazy var availableParserTypes:[ByteParser.Type] = type(of:self).defaultParserTypes
	
	open class var defaultParserTypes:[ByteParser.Type] {
		return [StringParser.self, NumericalParser.self, ArrayParser.self, DataParser.self, ObjectParser.self, TypedParser.self]
	}
	
	func findNextParser()->ByteParser? {
		for parseType in availableParserTypes {
			if let parser = parseType.parser(reader: reader) {
				return parser
			}
		}
		return nil
	}
	
	
	public func parse()->Any? {
		
		repeat {
			guard let topParser = parserStack.last else {
				guard let newParser = findNextParser() else { return nil }
				parserStack.append(newParser)
				continue
			}
			
			switch topParser.read(from: reader) {
			case .next:
				continue
			case .invalidFormat:
				return nil
			case .pop(let value):
				let _ = parserStack.removeLast()
				guard let lastParser = parserStack.last as? ScopedParser else { return value }
				lastParser.push(value)
			case .push:
				guard let nextParser:ByteParser = findNextParser() else {
					break
				}
				parserStack.append(nextParser)
			}
		} while true
		
	}
	
	
}


