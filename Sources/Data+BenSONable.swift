//
//  Data+BenSONable.swift
//  SwiftBenSON
//
//  Created by Ben Spratling on 4/9/17.
//
//

import Foundation

extension UInt8 {
	
	var hexBytes:[UInt8] {
		let highBits:UInt8 = self >> 4
		let lowBits:UInt8 = self & 0x0F
		return [highBits.lowBitsAsHexByte, lowBits.lowBitsAsHexByte]
	}
	
	
	//
	var lowBitsAsHexByte:UInt8 {
		switch self {
		case 0...9:
			return self + 48
		default:	//10...15
			return (self-10) + 65
		}
	}
	
}


extension Data : BenSONable {
	
	public func bensonData(at path:SubscriptPath, humanReadable:Bool)throws->Data {
		if humanReadable {
			return humanReadableBenson()
		}
		var leader = "#\(count):".data(using: .utf8)!
		leader.append(self)
		return leader
	}
	
	
	public func humanReadableBenson()->Data {
		
		//allocate an array of bytes big enough to capture all the data
		let groupsOf4:Int = count / 4
		let over4:Int = count % 4
		let sizeOfByteArray:Int = 2 + (groupsOf4 * 9) + (2 * over4)
		var bytes:[UInt8] = [UInt8](repeating:32, count:sizeOfByteArray)
		bytes[0] = 0x23	// #
		bytes[1] = 0x78	// x
		for i in 0..<groupsOf4 {
			let byte0:UInt8 = self[i*4]
			bytes[2 + (i*9)] = (byte0 >> 4).lowBitsAsHexByte
			bytes[2 + (i*9) + 1] = (byte0 & 0x0F).lowBitsAsHexByte
			
			let byte1:UInt8 = self[(i*4)+1]
			bytes[2 + (i*9) + 2] = (byte1 >> 4).lowBitsAsHexByte
			bytes[2 + (i*9) + 3] = (byte1 & 0x0F).lowBitsAsHexByte
			
			let byte2:UInt8 = self[(i*4)+2]
			bytes[2 + (i*9) + 4] = (byte2 >> 4).lowBitsAsHexByte
			bytes[2 + (i*9) + 5] = (byte2 & 0x0F).lowBitsAsHexByte
			
			let byte3:UInt8 = self[(i*4)+3]
			bytes[2 + (i*9) + 6] = (byte3 >> 4).lowBitsAsHexByte
			bytes[2 + (i*9) + 7] = (byte3 & 0x0F).lowBitsAsHexByte
		}
		//last group
		for i in 0..<over4 {
			let byte:UInt8 = self[groupsOf4 * 4 + i]
			bytes[2 + (groupsOf4*9) + (2*i)] = (byte >> 4).lowBitsAsHexByte
			bytes[2 + (groupsOf4*9) + (2*i) + 1] = (byte & 0x0F).lowBitsAsHexByte
		}
		
		return Data(bytes)
	}
	
	
	public init(benSONType:TypeSpec, data:Data, at path:SubscriptPath)throws{
		fatalError("Data.benSONType:data:at not implemented")
	}
	
}

