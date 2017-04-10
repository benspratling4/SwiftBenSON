//
//  BenSONFormatter.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/5/17.
//
//

import Foundation
public class BenSONFormatter {
	
	///set to true for generated data to be human-readable
	public var humanReadable:Bool = false
	
	
	public func data(for benson:BenSONable)->Data {
		fatalError("write me")
	}
	
	///to init a type with data
	public var supportedTypes:[String:(TypeSpec, BenSONable.Type)] = [:]
	
	
	
	
}
