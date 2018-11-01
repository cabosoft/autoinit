//
//  AutoInitNoDestructor.m
//  autoinit-swift
//
//  Created by Jim Boyd on 10/24/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

#import "AutoInitNoDestructor.h"
@import DBC;
@import autoinit;

static int sInitCount = 0;


@interface AutoInitNoDestructor () <AutoInitModule>

@end


@implementation AutoInitNoDestructor

+(void) initializeModule
{
	sInitCount += 1;
}

+(int) initCount
{
	return sInitCount;
}

@end

