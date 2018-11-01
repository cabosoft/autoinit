//
//  CachedModuleListProvider.swift
//  autoinit
//
//  Created by Jim Boyd on 6/12/17.
//

import Foundation

@objc(CachedModuleListProvider)
open class CachedModuleListProvider : NSObject, AutoInitModuleListProvider {
	
	fileprivate let baseProvider: AutoInitModuleListProvider
	fileprivate let cacheKey: String
	@objc public var fromCache = false;
	
	@objc public init(baseProvider: AutoInitModuleListProvider, cacheKey:String) {
		self.baseProvider = baseProvider
		self.cacheKey = cacheKey
	}
	
	public var moduleClassList: [AutoInitModule.Type] {
		var classList: [AutoInitModule.Type] = self.getSavedClassList()
		self.fromCache = true
		
		// Process a passed in list, if we do not have a cached list.
		if classList.isEmpty {
			classList = baseProvider.moduleClassList
			self.fromCache = false
		}
		
		// Save class-list cache
		self.saveCLassList(classList: classList)
		
		return classList
    }
	
	@objc public func clearSavedClassList() {
		UserDefaults.standard.removeObject(forKey:cacheKey)
		UserDefaults.standard.synchronize()
	}
}

fileprivate extension CachedModuleListProvider {
	func saveCLassList(classList: [AutoInitModule.Type]) {
		if classList.count > 0 {
			var classNameList = [String]()
			for initClass: AnyClass in classList {
				classNameList.append(NSStringFromClass(initClass))
			}
			UserDefaults.standard.set(classNameList, forKey: cacheKey)
		}
		else {
			UserDefaults.standard.removeObject(forKey: cacheKey)
		}
		
		UserDefaults.standard.synchronize()
	}
	
	func getSavedClassList() -> [AutoInitModule.Type] {
		let savedList = UserDefaults.standard.stringArray(forKey: cacheKey)
		var classList: [AutoInitModule.Type] = [AutoInitModule.Type]()
		
		if let savedList = savedList, !savedList.isEmpty {
			
			for className in savedList {
				let theClass:AnyClass? = NSClassFromString(className)
				
				if let initClass = theClass as? AutoInitModule.Type {
					classList.append(initClass)
				}
			}
		}
		
		return classList
	}
}
