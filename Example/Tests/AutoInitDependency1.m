//
// Created by Jim Boyd on 10/21/14.
// Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

#import "AutoInitDependency1.h"
#import "AutoInitDependency2.h"
@import DBC;
@import autoinit;

static BOOL sDidInit = NO;


@interface AutoInitDependency1 () <AutoInitModule>

@end


@implementation AutoInitDependency1

+(void) initializeModule
{
	sDidInit = [AutoInitDependency2 didInit];
}

+(void) destructModule
{
	sDidInit = NO;
}

+(NSArray*) moduleDependencies
{
	REQUIRE([AutoInitDependency2 conformsToProtocol:@protocol(AutoInitModule)]);
	
	return @[[AutoInitDependency2 class]];
}

+(BOOL) didInit;
{
	return sDidInit;
}

@end
