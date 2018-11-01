//
//  SwiftAutoInitObjCDependency.swift
//  autoinit-swift
//
//  Created by Jim Boyd on 11/6/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

import Foundation
import DBC
import autoinit


class SwiftAutoInitObjCDependency: NSObject, AutoInitModule {
	static var sDidInit = false

	class func initializeModule() {
		sDidInit = AutoInitDependency1.didInit()
	}
	
	class func destructModule() {
		sDidInit = false;
	}
	
	class func didInit() -> Bool {
		return sDidInit
	}
	
	class func moduleDependencies() -> [AutoInitModule.Type] {
		require(AutoInitDependency1.conforms(to: AutoInitModule.self));
		
		return [AutoInitDependency1.self as! AutoInitModule.Type];
	}
	
	// define the class
}
