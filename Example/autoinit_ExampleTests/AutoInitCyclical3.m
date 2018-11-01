//
// Created by Jim Boyd on 10/21/14.
// Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

#import "AutoInitCyclical3.h"
#import "AutoInitCyclical1.h"
@import DBC;
@import autoinit;

static BOOL sDidInit = NO;


@interface AutoInitCyclical3 () <AutoInitModule>

@end


@implementation AutoInitCyclical3

+(void) initializeModule
{
	sDidInit = YES;
}

+(void) destructModule
{
	sDidInit = NO;
}

+(BOOL) didInit;
{
	return sDidInit;
}

+(NSArray*) moduleDependencies
{
	REQUIRE([AutoInitCyclical1 conformsToProtocol:@protocol(AutoInitModule)]);

	return @[[AutoInitCyclical1 class]];
}

@end
