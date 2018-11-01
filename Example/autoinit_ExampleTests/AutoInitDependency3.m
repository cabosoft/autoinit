//
// Created by Jim Boyd on 10/21/14.
// Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

#import "AutoInitDependency3.h"
@import DBC;
@import autoinit;

static BOOL sDidInit = NO;


@interface AutoInitDependency3 () <AutoInitModule>

@end


@implementation AutoInitDependency3

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

@end
