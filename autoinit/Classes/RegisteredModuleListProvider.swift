//
//  RegisteredModuleListProvider.swift
//  autoinit
//
//  Created by Jim Boyd on 6/12/17.
//

import Foundation
import DBC

public class RegisteredModuleListProvider : NSObject, AutoInitModuleListProvider {
	
	fileprivate var registeredClasses = [AutoInitModule.Type]()
	
	public var moduleClassList: [AutoInitModule.Type] {
		return self.registeredClasses
	}
	
	@objc public func register(_ initClass: AutoInitModule.Type) {
		// Simply add each registered class name in the list for later use.
		registeredClasses.append(initClass)
	}
	
	@objc public func registerClasses(_ classList: [AutoInitModule.Type]) {
		require(classList.count > 0)

		// Simply add each registered class name in the list for later use.
		registeredClasses += classList
    }
}
