//
// Created by Jim Boyd on 10/21/14.
// Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

#import "AutoInitDependency2.h"
#import "AutoInitDependency3.h"
@import DBC;
@import autoinit;

static BOOL sDidInit = NO;


@interface AutoInitDependency2 () <AutoInitModule>

@end


@implementation AutoInitDependency2


+(void) initializeModule
{
	sDidInit = [AutoInitDependency3 didInit];
}

+(void) destructModule
{
	sDidInit = NO;
}

+(NSArray*) moduleDependencies
{
	REQUIRE([AutoInitDependency3 conformsToProtocol:@protocol(AutoInitModule)]);

	return @[[AutoInitDependency3 class]];
}

+(BOOL) didInit;
{
	return sDidInit;
}

@end
