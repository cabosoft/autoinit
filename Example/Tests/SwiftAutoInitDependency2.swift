//
//  SwiftAutoInitDependency2.swift
//  autoinit-swift
//
//  Created by Jim Boyd on 11/6/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

import Foundation
import DBC
import autoinit

@objc class SwiftAutoInitDependency2: NSObject, AutoInitModule {
	static var sDidInit = false

	class func initializeModule() {
		sDidInit = SwiftAutoInitDependency3.didInit()
	}
	
	class func destructModule() {
		sDidInit = false;
	}
	
	class func moduleDependencies() -> [AutoInitModule.Type] {
		require(SwiftAutoInitDependency3.conforms(to: AutoInitModule.self));
		
		return [SwiftAutoInitDependency3.self];
	}
	
	@objc class func didInit() -> Bool {
		return sDidInit
	}
	
	// define the class
}
