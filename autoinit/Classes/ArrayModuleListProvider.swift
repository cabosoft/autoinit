//
//  ArrayModuleListProvider.swift
//  autoinit
//
//  Created by Jim Boyd on 6/12/17.
//

import Foundation
import DBC

public extension Array where Element == AutoInitModule.Type  {
	public var asProvider: AutoInitModuleListProvider {
		return ArrayModuleListProvider(moduleList: self)
	}
}

extension NSArray {
	@objc public var asProvider: AutoInitModuleListProvider {
		guard let moduleList = self as? [AutoInitModule.Type] else {
			requireFailure("NSArray does not contain all AutoInitModule Types")
			return ArrayModuleListProvider(moduleList: [])
		}
		
		return ArrayModuleListProvider(moduleList: moduleList)
	}
	
}

public class ArrayModuleListProvider : NSObject, AutoInitModuleListProvider {
	
	let moduleList: [AutoInitModule.Type]
	
	init(moduleList: [AutoInitModule.Type]) {
		self.moduleList = moduleList
	}
	
	public var moduleClassList: [AutoInitModule.Type] {
		return self.moduleList
	}
}
