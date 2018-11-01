//
//  AutoInitMultipleDependency.m
//  autoinit-swift
//
//  Created by Jim Boyd on 10/24/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

#import "AutoInitMultipleDependency.h"
#import "AutoInitSimple.h"
#import "AutoInitDependency1.h"
@import DBC;
@import autoinit;

static BOOL sDidInit = NO;


@interface AutoInitMultipleDependency () <AutoInitModule>

@end


@implementation AutoInitMultipleDependency

+(void) initializeModule
{
	sDidInit = [AutoInitSimple didInit] && [AutoInitDependency1 didInit];
}

+(void) destructModule
{
	sDidInit = NO;
}

+(NSArray*) moduleDependencies
{
	REQUIRE([AutoInitSimple conformsToProtocol:@protocol(AutoInitModule)]);
	REQUIRE([AutoInitDependency1 conformsToProtocol:@protocol(AutoInitModule)]);
	
	return @[[AutoInitSimple class], [AutoInitDependency1 class]];
}

+(BOOL) didInit;
{
	return sDidInit;
}

@end
