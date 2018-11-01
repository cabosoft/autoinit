//
//  ReflectionModuleListProvider.swift
//  autoinit
//
//  Created by Jim Boyd on 6/12/17.
//

import Foundation

public class ReflectionModuleListProvider : NSObject, AutoInitModuleListProvider {
	
	var moduleList: [AutoInitModule.Type] = []
	
	public var moduleClassList: [AutoInitModule.Type] {
		
		if (moduleList.isEmpty) {
			moduleList = getClassesImplementingProtocol(p: AutoInitModule.self) as! [AutoInitModule.Type]
		}
		
		return moduleList
	}
	
	@objc public func removeModule(_ module: AutoInitModule.Type) {
		if (moduleList.isEmpty) {
			moduleList = getClassesImplementingProtocol(p: AutoInitModule.self) as! [AutoInitModule.Type]
		}
		
		moduleList = moduleList.filter{ (thisMod) -> Bool in
			return "\(thisMod.self)" != "\(module.self)"
		}
	}
	
	private func getClassesImplementingProtocol(p: Protocol) -> [AnyClass] {
		
		let typeCount = Int(objc_getClassList(nil, 0))
		let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
		let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
		objc_getClassList(autoreleasingTypes, Int32(typeCount))
		
		var classes = [AnyClass]()
		let conformsToProtocolSelector: Selector = #selector(NSObject.conforms(to:))

		for index in 0 ..< typeCount {
			let currentClass:AnyClass = autoreleasingTypes[index]
			
			if class_conformsToProtocol(currentClass, p) { 
				classes.append(currentClass)
			}
			else if class_respondsToSelector(currentClass, conformsToProtocolSelector) {
				if currentClass.conforms(to:p) {
					classes.append(currentClass)
				}
			}
		}
		
		types.deallocate()
		return classes
	}
}


public class CachedReflectionModuleListProvider : CachedModuleListProvider {
	public init() {
		super.init(baseProvider: ReflectionModuleListProvider(), cacheKey: "AutoInitialize:savedClassList")
	}
}
