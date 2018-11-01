//
// Created by Jim Boyd on 10/21/14.
// Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

#import "AutoInitCyclical1.h"
#import "AutoInitCyclical2.h"
@import DBC;
@import autoinit;

static BOOL sDidInit = NO;


@interface AutoInitCyclical1 () <AutoInitModule>

@end


@implementation AutoInitCyclical1

+(void) initializeModule
{
	sDidInit = [AutoInitCyclical2 didInit];
}

+(void) destructModule
{
	sDidInit = NO;
}

+(NSArray*) moduleDependencies
{
	REQUIRE([AutoInitCyclical2 conformsToProtocol:@protocol(AutoInitModule)]);

	return @[[AutoInitCyclical2 class]];
}

+(BOOL) didInit;
{
	return sDidInit;
}

@end
