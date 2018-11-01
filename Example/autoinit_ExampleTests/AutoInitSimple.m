//
//  AutoInitSimple.m
//  autoinit-swift
//
//  Created by Jim Boyd on 10/24/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

#import "AutoInitSimple.h"
@import DBC;
@import autoinit;

static BOOL sDidInit = NO;


@interface AutoInitSimple () <AutoInitModule>

@end


@implementation AutoInitSimple

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

