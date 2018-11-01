//
//  AutoInitSwiftDependency.m
//  autoinit-swift
//
//  Created by Jim Boyd on 10/24/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

#import "AutoInitSwiftDependency.h"
#import "autoInit_Tests-Swift.h"

@import DBC;
@import autoinit;


static BOOL sDidInit = NO;


@interface AutoInitSwiftDependency () <AutoInitModule>

@end


@implementation AutoInitSwiftDependency

+(void) initializeModule
{
	sDidInit = [SwiftAutoInitDependency1 didInit];
}

+(void) destructModule
{
	sDidInit = NO;
}

+(NSArray*) moduleDependencies
{
	REQUIRE([SwiftAutoInitDependency1 conformsToProtocol:@protocol(AutoInitModule)]);
	
	return @[[SwiftAutoInitDependency1 class]];
}

+(BOOL) didInit;
{
	return sDidInit;
}

@end
