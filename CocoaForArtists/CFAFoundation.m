//
//  CFAFoundation.m
//  CocoaForArtists
//
//  Created by Travis Kirton on 10-09-12.
//  Copyright 2010 Travis Kirton. All rights reserved.
//

#import "CFAFoundation.h"

static CFAFoundation *cfaFoundation;
@interface CFAFoundation (private)
NSInteger numSort(id num1, id num2, void *context);
NSInteger strSort(id str1, id str2, void *context);
NSInteger floatSort(id obj1, id obj2, void *context);	
@end

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
NSInteger basicSort(id obj1, id obj2, void *context) {
	if([obj1 class] == [NSNumber class]){
		return numSort(obj1, obj2, context);
	}
	
	if([obj1 class] == [@"" class] || [obj1 class] == [NSString class]){
		return strSort(obj1, obj2, context);
	}
	
	return floatSort(obj1, obj2, context);
}

NSInteger numSort(id num1, id num2, void *context) {
	return [num1 compare:num2];
}

NSInteger strSort(id str1, id str2, void *context) {
	return [str1 localizedStandardCompare:str2];
}

NSInteger floatSort(id obj1, id obj2, void *context) {
	float flt1 = [obj1 floatValue];
	float flt2 = [obj2 floatValue];
	if (flt1 < flt2)
        return NSOrderedAscending;
    else if (flt1 > flt2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}
@end
