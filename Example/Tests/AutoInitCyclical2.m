//
// Created by Jim Boyd on 10/21/14.
// Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

#import "AutoInitCyclical2.h"
#import "AutoInitCyclical3.h"
@import DBC;
@import autoinit;

static BOOL sDidInit = NO;


@interface AutoInitCyclical2 () <AutoInitModule>

@end


@implementation AutoInitCyclical2

+(void) initializeModule
{
	sDidInit = [AutoInitCyclical3 didInit];
}

+(void) destructModule
{
	sDidInit = NO;
}

+(NSArray*) moduleDependencies
{
	REQUIRE([AutoInitCyclical3 conformsToProtocol:@protocol(AutoInitModule)]);

	return @[[AutoInitCyclical3 class]];
}

+(BOOL) didInit;
{
	return sDidInit;
}

@end
