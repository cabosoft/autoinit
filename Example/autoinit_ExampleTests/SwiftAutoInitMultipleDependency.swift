//
//  SwiftAutoInitMultipleDependency.swift
//  autoinit-swift
//
//  Created by Jim Boyd on 11/6/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

import Foundation
import DBC
import autoinit


class SwiftAutoInitMultipleDependency: NSObject, AutoInitModule {
	static var sDidInit = false

	class func initializeModule() {
		sDidInit = SwiftAutoInitSimple.didInit() && SwiftAutoInitDependency1.didInit()
	}
	
	class func destructModule() {
		sDidInit = false;
	}
	
	class func didInit() -> Bool {
		return sDidInit
	}
	
	class func moduleDependencies() -> [AutoInitModule.Type] {
		require(SwiftAutoInitSimple.conforms(to: AutoInitModule.self));
		require(SwiftAutoInitDependency1.conforms(to: AutoInitModule.self));
		
		return [SwiftAutoInitSimple.self, SwiftAutoInitDependency1.self];
	}
	
	// define the class
}
