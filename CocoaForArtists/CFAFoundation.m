//
//  CFAFoundation.m
//  CocoaForArtists
//
//  Created by Travis Kirton on 10-09-12.
//  Copyright 2010 Travis Kirton. All rights reserved.
//

#import "CFAFoundation.h"

static CFAFoundation *cfaFoundation;

@implementation CFAFoundation
GENERATE_SINGLETON(CFAFoundation, cfaFoundation);

+(void)load {
	if(VERBOSELOAD) printf("CFAFoundation\n");
}

-(id)_init {
	return self;
}

void CFALog(NSString *logString,...) {
    va_list args;
	
    va_start (args, logString);
    NSString *finalString = [[[NSString alloc] initWithFormat:[logString stringByAppendingString: @"\n"] arguments:args] autorelease];
    va_end (args);
    
	fprintf(stderr,"CFALog: %s",[finalString UTF8String]);
}

@end
