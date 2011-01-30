//
//  CFAGlobalTypeAttributes.m
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-01-30.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import "CFAGlobalTypeAttributes.h"

static CFAGlobalTypeAttributes *cfaGlobalTypeAttributes;

@implementation CFAGlobalTypeAttributes
GENERATE_SINGLETON(CFAGlobalTypeAttributes, cfaGlobalTypeAttributes);

@synthesize attributes;

-(id)_init {
	self.attributes = [[[NSMutableDictionary alloc] initWithCapacity:0] retain];

	//Default attributes
	[self.attributes setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
	[self.attributes setObject:[NSFont systemFontOfSize:14.0f] forKey:NSFontAttributeName];
	
	return self;
}

-(void)setObject:(id)object forKey:(NSString *)key {
	[self.attributes setObject:object forKey:key];
}

-(void)setValue:(id)object forKey:(NSString *)key {
	[self.attributes setValue:object forKey:key];	
}

-(void)removeObjectForKey:(NSString *)key {
	[self.attributes removeObjectForKey:key];
}

@end
