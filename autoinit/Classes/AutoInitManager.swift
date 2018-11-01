//
//  AutoInitManager.swift
//  autoinit
//
//  Created by Jim Boyd on 6/6/17.
//

import Foundation
import DBC

@objc(AutoInitialize)
public class AutoInitialize: NSObject {
	
	private static var sClassList = [AutoInitModule.Type]()
	
	@objc public class func initializeAll() {
		initializeAll(ReflectionModuleListProvider())
	}
	
	@objc public class func initializeAll(_ provider: AutoInitModuleListProvider) {
		
		let newList = orderdListWithDependencies(from: provider.moduleClassList)
		
		// Execute the "initializeModule" implementation for each class in the class-list.
		for initClass in newList {
			initClass.initializeModule()
			inform("AutoInitialize : called initializeModule for class \(initClass)")
		}
		
		// Add this to the list of
		AutoInitialize.sClassList += newList
		inform("AutoInitialize.initializeAll : \(newList.count) init functions called")
	}
	
    @objc public class func destroyAll() {
		for initClass in AutoInitialize.sClassList.reversed() {
			if let destructModule = initClass.destructModule {
				destructModule()
				inform("AutoInitialize : called destructModule for class \(initClass)")
			}
		}
    }
}

fileprivate extension AutoInitialize {
	class func orderdListWithDependencies(from classList: [AutoInitModule.Type]) -> [AutoInitModule.Type] {
		var orderedList = [AutoInitModule.Type]()
		
		for testClass in classList {
			if !orderedList.contains(where: {$0 == testClass})
			{
				// Create an array to test cyclic dependencies.
				var cyclicTestArray = [AutoInitModule.Type]()
				cyclicTestArray.append(testClass)
				
				// Process dependencies before we add this class to the list.
				checkDependencies(for: testClass, resultList: &orderedList, cyclicTestArray: &cyclicTestArray)
				orderedList.append(testClass)
			}
		}
		
		return orderedList
	}
	
	class func checkDependencies(for initClass:AutoInitModule.Type, resultList orderedList: inout [AutoInitModule.Type], cyclicTestArray: inout [AutoInitModule.Type]) {
		if let dependencies = initClass.moduleDependencies?(), !dependencies.isEmpty {
			for dependency in dependencies {
				
				if !orderedList.contains(where: {$0 == dependency})
				{
					if cyclicTestArray.contains(where: {$0 == dependency})
					{
						// THROW AN EXCEPTION HERE???
						let exception = NSException(
							name: NSExceptionName(rawValue: "AutoInitialize:CyclicalDependency"),
							reason: "AutoInitialize : cyclic dependenecy detected in path \(cyclicTestArray)",
							userInfo: nil
						)
						
						exception.raise()
					}
					else {
						// Add this class to the cyclic list so we can test cyclic dependencies.
						cyclicTestArray.append(dependency)
						
						// Process dependencies before we add this class to the list.
						checkDependencies(for: dependency, resultList: &orderedList, cyclicTestArray: &cyclicTestArray)
						orderedList.append(dependency)
					}
				}
			}
		}
	}
}
