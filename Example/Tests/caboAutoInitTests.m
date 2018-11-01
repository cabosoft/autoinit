//
//  autoinitTests.m
//  autoinitTests
//
//  Created by Jim Boyd on 10/14/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AutoInitCyclical1.h"
#import "AutoInitCyclical2.h"
#import "AutoInitCyclical3.h"
#import "AutoInitDependency1.h"
#import "AutoInitDependency2.h"
#import "AutoInitDependency3.h"
#import "AutoInitSimple.h"
#import "AutoInitNoDestructor.h"
#import "AutoInitMultipleDependency.h"
#import "AutoInitSwiftDependency.h"
#import "autoInit_Tests-Swift.h"
@import autoinit;

@interface caboAutoInitTests : XCTestCase

@end

// todo rename

@implementation caboAutoInitTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testReflectiveInit
{
	ReflectionModuleListProvider* provider = [[ReflectionModuleListProvider alloc] init];
	
	// Not testing cyclical modules
	[provider removeModule:AutoInitCyclical1.class];
	[provider removeModule:AutoInitCyclical2.class];
	[provider removeModule:AutoInitCyclical3.class];
	
	XCTAssertFalse([AutoInitSimple didInit]);
	XCTAssertFalse([AutoInitDependency1 didInit]);
	XCTAssertFalse([AutoInitDependency2 didInit]);
	XCTAssertFalse([AutoInitDependency3 didInit]);
	XCTAssertFalse([AutoInitMultipleDependency didInit]);
	XCTAssertFalse([SwiftAutoInitSimple didInit]);

	XCTAssertNoThrow([AutoInitialize initializeAll:provider]);

	XCTAssertTrue([AutoInitSimple didInit]);
	XCTAssertTrue([AutoInitDependency1 didInit]);
	XCTAssertTrue([AutoInitDependency2 didInit]);
	XCTAssertTrue([AutoInitDependency3 didInit]);
	XCTAssertTrue([AutoInitMultipleDependency didInit]);
	XCTAssertTrue([SwiftAutoInitSimple didInit]);

	XCTAssertNoThrow([AutoInitialize destroyAll]);

	XCTAssertFalse([AutoInitSimple didInit]);
	XCTAssertFalse([AutoInitDependency1 didInit]);
	XCTAssertFalse([AutoInitDependency2 didInit]);
	XCTAssertFalse([AutoInitDependency3 didInit]);
	XCTAssertFalse([AutoInitMultipleDependency didInit]);
	XCTAssertFalse([SwiftAutoInitSimple didInit]);
}

- (void)testCachedInit
{
	ReflectionModuleListProvider* provider = [[ReflectionModuleListProvider alloc] init];
	CachedModuleListProvider* cached = [[CachedModuleListProvider alloc] initWithBaseProvider:provider cacheKey:@"testCachedInit"];
	
	(void) cached.moduleClassList;
	XCTAssertFalse(cached.fromCache);
	
	(void) cached.moduleClassList;
	XCTAssertTrue(cached.fromCache);
	
	[cached clearSavedClassList];
	
	(void) cached.moduleClassList;
	XCTAssertFalse(cached.fromCache);
	
	(void) cached.moduleClassList;
	XCTAssertTrue(cached.fromCache);
	
	[cached clearSavedClassList];
}

- (void)testRegisteredInit
{
	RegisteredModuleListProvider* provider = [[RegisteredModuleListProvider alloc] init];
	[provider register:AutoInitSimple.class];
	[provider register:AutoInitDependency1.class];
	[provider register:AutoInitMultipleDependency.class];
	[provider register:SwiftAutoInitSimple.class];
	
	XCTAssertFalse([AutoInitSimple didInit]);
	XCTAssertFalse([AutoInitDependency1 didInit]);
	XCTAssertFalse([AutoInitDependency2 didInit]);
	XCTAssertFalse([AutoInitDependency3 didInit]);
	XCTAssertFalse([AutoInitMultipleDependency didInit]);
	XCTAssertFalse([SwiftAutoInitSimple didInit]);
	
	XCTAssertNoThrow([AutoInitialize initializeAll:provider]);
	
	XCTAssertTrue([AutoInitSimple didInit]);
	XCTAssertTrue([AutoInitDependency1 didInit]);
	XCTAssertTrue([AutoInitDependency2 didInit]);
	XCTAssertTrue([AutoInitDependency3 didInit]);
	XCTAssertTrue([AutoInitMultipleDependency didInit]);
	XCTAssertTrue([SwiftAutoInitSimple didInit]);
	
	XCTAssertNoThrow([AutoInitialize destroyAll]);
	
	XCTAssertFalse([AutoInitSimple didInit]);
	XCTAssertFalse([AutoInitDependency1 didInit]);
	XCTAssertFalse([AutoInitDependency2 didInit]);
	XCTAssertFalse([AutoInitDependency3 didInit]);
	XCTAssertFalse([AutoInitMultipleDependency didInit]);
	XCTAssertFalse([SwiftAutoInitSimple didInit]);
}

- (void)testNoDestruct
{
	RegisteredModuleListProvider* provider = [[RegisteredModuleListProvider alloc] init];
	[provider register:AutoInitNoDestructor.class];
	
	int beforeInit = [AutoInitNoDestructor initCount];

	XCTAssertNoThrow([AutoInitialize initializeAll:provider]);

	int afterInit = [AutoInitNoDestructor initCount];

	XCTAssertNoThrow([AutoInitialize destroyAll]);

	int afterDestroy = [AutoInitNoDestructor initCount];
	
	XCTAssertTrue(beforeInit < afterInit);
	XCTAssertTrue(afterInit == afterDestroy);
}

- (void)testDependencies
{
	NSArray* initList = @[[AutoInitDependency1 class]];

	XCTAssertFalse([AutoInitDependency1 didInit]);
	XCTAssertFalse([AutoInitDependency2 didInit]);
	XCTAssertFalse([AutoInitDependency3 didInit]);

	XCTAssertNoThrow([AutoInitialize initializeAll:initList.asProvider]);

	XCTAssertTrue([AutoInitDependency1 didInit]);
	XCTAssertTrue([AutoInitDependency2 didInit]);
	XCTAssertTrue([AutoInitDependency3 didInit]);

	XCTAssertNoThrow([AutoInitialize destroyAll]);

	XCTAssertFalse([AutoInitDependency1 didInit]);
	XCTAssertFalse([AutoInitDependency2 didInit]);
	XCTAssertFalse([AutoInitDependency3 didInit]);
}

- (void)testMultipleDependency
{
	NSArray* initList = @[[AutoInitMultipleDependency class]];
	
	XCTAssertFalse([AutoInitMultipleDependency didInit]);
	XCTAssertFalse([AutoInitSimple didInit]);
	XCTAssertFalse([AutoInitDependency1 didInit]);
	XCTAssertFalse([AutoInitDependency2 didInit]);
	XCTAssertFalse([AutoInitDependency3 didInit]);
	
	XCTAssertNoThrow([AutoInitialize initializeAll:initList.asProvider]);
	
	XCTAssertTrue([AutoInitMultipleDependency didInit]);
	XCTAssertTrue([AutoInitSimple didInit]);
	XCTAssertTrue([AutoInitDependency1 didInit]);
	XCTAssertTrue([AutoInitDependency2 didInit]);
	XCTAssertTrue([AutoInitDependency3 didInit]);
	
	XCTAssertNoThrow([AutoInitialize destroyAll]);
	
	XCTAssertFalse([AutoInitMultipleDependency didInit]);
	XCTAssertFalse([AutoInitSimple didInit]);
	XCTAssertFalse([AutoInitDependency1 didInit]);
	XCTAssertFalse([AutoInitDependency2 didInit]);
	XCTAssertFalse([AutoInitDependency3 didInit]);
}

- (void)testSwiftDependency
{
	NSArray* initList = @[[AutoInitSwiftDependency class]];
	
	XCTAssertFalse([AutoInitSwiftDependency didInit]);
	XCTAssertFalse([SwiftAutoInitDependency1 didInit]);
	XCTAssertFalse([SwiftAutoInitDependency2 didInit]);
	XCTAssertFalse([SwiftAutoInitDependency3 didInit]);
	
	XCTAssertNoThrow([AutoInitialize initializeAll:initList.asProvider]);
	
	XCTAssertTrue([AutoInitSwiftDependency didInit]);
	XCTAssertTrue([SwiftAutoInitDependency1 didInit]);
	XCTAssertTrue([SwiftAutoInitDependency2 didInit]);
	XCTAssertTrue([SwiftAutoInitDependency3 didInit]);
	
	XCTAssertNoThrow([AutoInitialize destroyAll]);
	
	XCTAssertFalse([AutoInitSwiftDependency didInit]);
	XCTAssertFalse([SwiftAutoInitDependency1 didInit]);
	XCTAssertFalse([SwiftAutoInitDependency2 didInit]);
	XCTAssertFalse([SwiftAutoInitDependency3 didInit]);
}

- (void)testCyclicalDependencyFailure
{
	NSArray* initList = @[[AutoInitCyclical1 class]];
	XCTAssertThrows([AutoInitialize initializeAll:initList.asProvider]);
}

@end
