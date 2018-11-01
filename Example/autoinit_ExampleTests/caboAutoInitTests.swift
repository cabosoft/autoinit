//
//  caboAutoInitTests.swift
//  autoinit-swift
//
//  Created by Jim Boyd on 11/5/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

import Foundation
import XCTest
import autoinit

class SwiftAutoInitTests: XCTestCase {

	override func setUp() {
		super.setUp()
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testSimpleSwiftInit() {
		XCTAssertFalse(SwiftAutoInitSimple.didInit())

		let classList:[AutoInitModule.Type] = [SwiftAutoInitSimple.self]
		AutoInitialize.initializeAll(classList.asProvider)

		XCTAssertTrue((SwiftAutoInitSimple.didInit()))

		AutoInitialize.destroyAll()

		XCTAssertFalse(SwiftAutoInitSimple.didInit())
	}

	func testSimpleSwift2() {
		let provider = RegisteredModuleListProvider()
		provider.register(SwiftAutoInitSimple.self)
		
		XCTAssertFalse(SwiftAutoInitSimple.didInit())

		AutoInitialize.initializeAll(provider)

		XCTAssertTrue((SwiftAutoInitSimple.didInit()))

		AutoInitialize.destroyAll()

		XCTAssertFalse(SwiftAutoInitSimple.didInit())
	}
	
	func testReflectiveInit() {
		let provider = ReflectionModuleListProvider()
		
		// Not testing cyclical modules
		provider.removeModule(AutoInitCyclical1.self as! AutoInitModule.Type)
		provider.removeModule(AutoInitCyclical2.self as! AutoInitModule.Type)
		provider.removeModule(AutoInitCyclical3.self as! AutoInitModule.Type)
		
		XCTAssertFalse(AutoInitSimple.didInit())
		XCTAssertFalse(AutoInitDependency1.didInit())
		XCTAssertFalse(AutoInitDependency2.didInit())
		XCTAssertFalse(AutoInitDependency3.didInit())
		XCTAssertFalse(AutoInitMultipleDependency.didInit())
		XCTAssertFalse(SwiftAutoInitSimple.didInit())
		
		XCTAssertNoThrow(AutoInitialize.initializeAll(provider))
		
		XCTAssertTrue(AutoInitSimple.didInit())
		XCTAssertTrue(AutoInitDependency1.didInit())
		XCTAssertTrue(AutoInitDependency2.didInit())
		XCTAssertTrue(AutoInitDependency3.didInit())
		XCTAssertTrue(AutoInitMultipleDependency.didInit())
		XCTAssertTrue(SwiftAutoInitSimple.didInit())
		
		XCTAssertNoThrow(AutoInitialize.destroyAll())
		
		XCTAssertFalse(AutoInitSimple.didInit())
		XCTAssertFalse(AutoInitDependency1.didInit())
		XCTAssertFalse(AutoInitDependency2.didInit())
		XCTAssertFalse(AutoInitDependency3.didInit())
		XCTAssertFalse(AutoInitMultipleDependency.didInit())
		XCTAssertFalse(SwiftAutoInitSimple.didInit())
	}
	
	func testRegisteredInit() {
		let provider = RegisteredModuleListProvider()
		provider.register(AutoInitSimple.self as! AutoInitModule.Type)
		provider.register(AutoInitDependency1.self as! AutoInitModule.Type)
		provider.register(AutoInitMultipleDependency.self as! AutoInitModule.Type)
		provider.register(SwiftAutoInitSimple.self)
		
		XCTAssertFalse(AutoInitSimple.didInit())
		XCTAssertFalse(AutoInitDependency1.didInit())
		XCTAssertFalse(AutoInitDependency2.didInit())
		XCTAssertFalse(AutoInitDependency3.didInit())
		XCTAssertFalse(AutoInitMultipleDependency.didInit())
		XCTAssertFalse(SwiftAutoInitSimple.didInit())
		
		XCTAssertNoThrow(AutoInitialize.initializeAll(provider))
		
		XCTAssertTrue(AutoInitSimple.didInit())
		XCTAssertTrue(AutoInitDependency1.didInit())
		XCTAssertTrue(AutoInitDependency2.didInit())
		XCTAssertTrue(AutoInitDependency3.didInit())
		XCTAssertTrue(AutoInitMultipleDependency.didInit())
		XCTAssertTrue(SwiftAutoInitSimple.didInit())
		
		XCTAssertNoThrow(AutoInitialize.destroyAll())
		
		XCTAssertFalse(AutoInitSimple.didInit())
		XCTAssertFalse(AutoInitDependency1.didInit())
		XCTAssertFalse(AutoInitDependency2.didInit())
		XCTAssertFalse(AutoInitDependency3.didInit())
		XCTAssertFalse(AutoInitMultipleDependency.didInit())
		XCTAssertFalse(SwiftAutoInitSimple.didInit())
	}
	
	func testCachedInit() {
		let provider = ReflectionModuleListProvider()
		let cached = CachedModuleListProvider(baseProvider: provider, cacheKey: "testCachedInit")
		
		_ = cached.moduleClassList
		XCTAssertFalse(cached.fromCache)
		
		_ = cached.moduleClassList
		XCTAssertTrue(cached.fromCache)
		
		cached.clearSavedClassList()
		
		_ = cached.moduleClassList
		XCTAssertFalse(cached.fromCache)
		
		_ = cached.moduleClassList
		XCTAssertTrue(cached.fromCache)
		
		cached.clearSavedClassList()
	}
	
	func testSwiftDependencies() {
		let classList:[AutoInitModule.Type] = [SwiftAutoInitDependency1.self];

		XCTAssertFalse(SwiftAutoInitDependency1.didInit());
		XCTAssertFalse(SwiftAutoInitDependency2.didInit());
		XCTAssertFalse(SwiftAutoInitDependency3.didInit());

		AutoInitialize.initializeAll(classList.asProvider)

		XCTAssertTrue(SwiftAutoInitDependency1.didInit());
		XCTAssertTrue(SwiftAutoInitDependency2.didInit());
		XCTAssertTrue(SwiftAutoInitDependency3.didInit());

		AutoInitialize.destroyAll()

		XCTAssertFalse(SwiftAutoInitDependency1.didInit());
		XCTAssertFalse(SwiftAutoInitDependency2.didInit());
		XCTAssertFalse(SwiftAutoInitDependency3.didInit());
	}

	func testSwiftMutipleDependency() {
		let classList:[AutoInitModule.Type] = [SwiftAutoInitMultipleDependency.self];

		XCTAssertFalse(SwiftAutoInitMultipleDependency.didInit());
		XCTAssertFalse(SwiftAutoInitSimple.didInit());
		XCTAssertFalse(SwiftAutoInitDependency1.didInit());
		XCTAssertFalse(SwiftAutoInitDependency2.didInit());
		XCTAssertFalse(SwiftAutoInitDependency3.didInit());

		AutoInitialize.initializeAll(classList.asProvider)

		XCTAssertTrue(SwiftAutoInitMultipleDependency.didInit());
		XCTAssertTrue(SwiftAutoInitSimple.didInit());
		XCTAssertTrue(SwiftAutoInitDependency1.didInit());
		XCTAssertTrue(SwiftAutoInitDependency2.didInit());
		XCTAssertTrue(SwiftAutoInitDependency3.didInit());

		AutoInitialize.destroyAll()

		XCTAssertFalse(SwiftAutoInitMultipleDependency.didInit());
		XCTAssertFalse(SwiftAutoInitSimple.didInit());
		XCTAssertFalse(SwiftAutoInitDependency1.didInit());
		XCTAssertFalse(SwiftAutoInitDependency2.didInit());
		XCTAssertFalse(SwiftAutoInitDependency3.didInit());
	}


	func testSwiftAutoInitObjCDependency() {
		let classList:[AutoInitModule.Type] = [SwiftAutoInitObjCDependency.self];

		XCTAssertFalse(SwiftAutoInitObjCDependency.didInit());
		XCTAssertFalse(AutoInitDependency1.didInit());

		AutoInitialize.initializeAll(classList.asProvider)

		XCTAssertTrue(SwiftAutoInitObjCDependency.didInit());
		XCTAssertTrue(AutoInitDependency1.didInit());

		AutoInitialize.destroyAll()

		XCTAssertFalse(SwiftAutoInitObjCDependency.didInit());
		XCTAssertFalse(AutoInitDependency1.didInit());
	}

}
