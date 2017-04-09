//
//  BenSONParser.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/5/17.
//
//

import Foundation


class Parser {
	
	enum Action {
		case complete
		case push(token:String)
		case pop(BenSONable)
	}
	
}



protocol SubParser {
	
	var discriminator:String { get }
	
	
	
}
