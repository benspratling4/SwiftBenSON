//
//  TypeSpec.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/5/17.
//
//

import Foundation

public struct TypedValue {
	public var type:TypeSpec
	public var value:Any
	
	public init(type:TypeSpec, value:Any) {
		self.type = type
		self.value = value
	}
}


public struct TypeSpec {
	public var name:String
	
	public var mimeTypes:[String]
	
	/// uniform type identifiers
	public var utis:[String]
	
	/// include the leading `.`
	public var fileExtensions:[String]
	
	public init(name:String, mimeTypes:[String] = [], utis:[String] = [], fileExtensions:[String] = []) {
		self.name = name
		self.mimeTypes = mimeTypes
		self.utis = utis
		self.fileExtensions = fileExtensions
	}
	
	/// init'd from the benson file tag (not including leading/trailing <>
	public init(tag:String, index: SubscriptPath)throws {
		//parse until :
		let topLevelComponents:[String] = tag.components(separatedBy: ":")
		guard let tagName:String = topLevelComponents.first
			,!tagName.isEmpty
			else {
				throw BenSONParseError(index: index, code: .ZeroLengthTag)
		}
		
		self.name = tagName
		mimeTypes = []
		utis = []
		fileExtensions = []
		
		guard topLevelComponents.count > 1 else { return }
		
		//split by ,
		let typeStrings:[String] = topLevelComponents[1].components(separatedBy: ",")
		for typeString in typeStrings {
			//trim leading/trailing white space
			let type = typeString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
			if type.hasPrefix(".") {
				//	leading . = file extension
				fileExtensions.append(type)
			} else if type.contains("/") {
				//	contains / = mime type
				mimeTypes.append(type)
			} else {
				//	everything else: uti
				utis.append(type)
			}
		}
	}
	
	/// not including <>
	public var fullTag:String {
		var allTags:[String] = mimeTypes
		allTags.append(contentsOf:utis)
		allTags.append(contentsOf:fileExtensions)
		var tag = name
		if allTags.count > 0 {
			tag = tag + ":" + allTags.joined(separator:",")
		}
		return "\(name)"
	}
	
	///not including <>
	public var optimizedTag:String {
		return name
	}
	
	public static let pdf:TypeSpec = TypeSpec(name:"pdf", mimeTypes:["application/pdf"], utis:["com.adobe.pdf"], fileExtensions:[".pdf"])
	
	
	//TODO: include popular formats, like .pdf, and .jpg
	
}
