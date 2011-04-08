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

+(void)load {
	if(VERBOSELOAD) printf("CFAGlobalTypeAttributes\n");
}

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

-(id)objectForKey:(NSString *)key {
	return [self.attributes objectForKey:key];
}

-(CFAString *)description {
	return [CFAString stringWithString:[self.attributes description]];
}

-(CFDictionaryRef)attributesAsCFDictionaryRef {
	return [self CFDictionaryRefFrom:self.attributes];
}
-(CFDictionaryRef)CFDictionaryRefFrom:(NSDictionary *)dictionary {
	CFMutableDictionaryRef mDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, NULL);
	NSArray *keys = [dictionary allKeys];
	
	for(NSString *aKey in keys){
		if([aKey isEqualTo:NSFontAttributeName]) {
			CTFontRef font = (CTFontRef)[dictionary objectForKey:aKey];
			CFDictionaryAddValue(mDict, kCTFontAttributeName, font);
		}
		else if([aKey isEqualTo:NSKernAttributeName]) {
			CGFloat value[1]; 
			value[0] = [(NSNumber *)[dictionary objectForKey:aKey] floatValue];
			CFNumberRef kernValue = CFNumberCreate(kCFAllocatorDefault, kCFNumberFloatType, &value[0]);
			CFDictionaryAddValue(mDict, kCTKernAttributeName, kernValue);
		}
		else if([aKey isEqualTo:NSForegroundColorAttributeName]) {
			CGColorRef colorRef = [CFAColor NSColorToCGColor:[dictionary objectForKey:aKey]];
			CFDictionaryAddValue(mDict, kCTForegroundColorAttributeName, colorRef);
			CFRelease(colorRef);
		}
		else if([aKey isEqualTo:NSStrokeWidthAttributeName]) {
			CGFloat value[1]; 
			value[0] = [(NSNumber *)[dictionary objectForKey:aKey] floatValue];
			CFNumberRef strokeWidthValue = CFNumberCreate(kCFAllocatorDefault, kCFNumberFloatType, &value[0]);
			CFDictionaryAddValue(mDict, kCTStrokeWidthAttributeName, strokeWidthValue);
		}
		else if([aKey isEqualTo:NSStrokeColorAttributeName]) {
			CGColorRef colorRef = [CFAColor NSColorToCGColor:[dictionary objectForKey:aKey]];
			CFDictionaryAddValue(mDict, kCTStrokeColorAttributeName, colorRef);
			CFRelease(colorRef);
		}
		else if([aKey isEqualTo:NSUnderlineStyleAttributeName]) {
			int32_t value[1]; 
			value[0] = [(NSNumber *)[dictionary objectForKey:aKey] intValue];
			CFNumberRef underlineStyleValue = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &value[0]);
			CFDictionaryAddValue(mDict, kCTUnderlineStyleAttributeName, underlineStyleValue);
		}
		else if([aKey isEqualTo:NSUnderlineColorAttributeName]) {
			CGColorRef colorRef = [CFAColor NSColorToCGColor:[dictionary objectForKey:aKey]];
			CFDictionaryAddValue(mDict, kCTUnderlineColorAttributeName, colorRef);
			CFRelease(colorRef);
		}
	}
	return mDict;
}
@end
