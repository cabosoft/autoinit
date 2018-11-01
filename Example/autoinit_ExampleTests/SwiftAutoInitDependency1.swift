//
//  SwiftAutoInitDependency1.swift
//  autoinit-swift
//
//  Created by Jim Boyd on 11/6/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

import Foundation
import DBC
import autoinit

@objc(SwiftAutoInitDependency1)
public class SwiftAutoInitDependency1: NSObject, AutoInitModule {
	static var sDidInit: Bool = false

	public class func initializeModule() {
		sDidInit = SwiftAutoInitDependency2.didInit()
	}
	
	public class func destructModule() {
		sDidInit = false;
	}
	
	public class func moduleDependencies() -> [AutoInitModule.Type] {
		require(SwiftAutoInitDependency2.conforms(to: AutoInitModule.self));
		
		return [SwiftAutoInitDependency2.self];
	}

	@objc public  class func didInit() -> Bool {
		return sDidInit
	}
	
	// define the class
}
