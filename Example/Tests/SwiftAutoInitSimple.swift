//
//  AutoInitSimple.swift
//  autoinit-swift
//
//  Created by Jim Boyd on 11/6/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

import Foundation
import autoinit

@objc(SwiftAutoInitSimple)
public class SwiftAutoInitSimple: NSObject, AutoInitModule {
	static var sDidInit = false
	
	//	override class func load()
//	override open class func initialize() {
//		AutoInitialize.registerClass(SwiftAutoInitSimple.self);
//	}
	
	public class func initializeModule() {
		sDidInit = true
	}
	
	public class func destructModule() {
		sDidInit = false;
	}
	
	@objc public class func didInit() -> Bool {
		return sDidInit
	}
	
	// define the class
}
