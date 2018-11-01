//
//  SwiftAutoInitDependency3.swift
//  autoinit-swift
//
//  Created by Jim Boyd on 11/6/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

import Foundation
import autoinit

@objc class SwiftAutoInitDependency3: NSObject, AutoInitModule {
	static var sDidInit = false

	class func initializeModule() {
		sDidInit = true
	}
	
	class func destructModule() {
		sDidInit = false;
	}
	
	@objc class func didInit() -> Bool {
		return sDidInit
	}
	
	// define the class
}
