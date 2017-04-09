//
//  String+BenSONable.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/5/17.
//
//

import Foundation

extension String : BenSONable {
	
	public func bensonData(at path:SubscriptPath, humanReadable:Bool)throws->Data {
		let middle:String = self.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")
		let final:String = "\"" + middle + "\""
		guard let data = final.data(using: .utf8)
			else {
				throw BenSONableError(path: path)
		}
		return data
	}
	
	public init(benSONType:TypeSpec, data:Data, at path:SubscriptPath)throws {
		//TODO: write me
		fatalError("write me")
	}
	
}

