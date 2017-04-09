//
//  SubscriptPath.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/5/17.
//
//

import Foundation




public struct SubscriptPath {
	
	public enum Component {
		case index(Int)
		case key(String)
	}
	
	public var components:[Component]
	
	public init(_ components:[Component]) {
		self.components = components
	}
}
