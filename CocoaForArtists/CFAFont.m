//
//  CFAFont.m
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-01-30.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import "CFAFont.h"

@implementation CFAFont
@synthesize font;

+(void)load {
	if(VERBOSELOAD) printf("CFAFont\n");
}

-(id)init {
	if(!(self = [super init])) return nil;
	return self;
}

-(id)initWithName:(id)name {
	return [self initWithName:name size:14.0f];
}

-(id)initWithName:(id)name size:(CGFloat)size {
	if([name isKindOfClass:[NSString class]]) {
		self.font = [NSFont fontWithName:(NSString *)name size:size];
		return self;
	} else if ([name isKindOfClass:[CFAString class]]) {
		self.font = [NSFont fontWithName:((CFAString *)name).string size:size];
		return self;
	}
	return nil;
}

-(id)initWithFont:(id)aFont {
	if([aFont isKindOfClass:[NSFont class]]) {
		self.font = (NSFont *)aFont;
		return self;
	} else if ([aFont isKindOfClass:[CFAFont class]]) {
		self.font = ((CFAFont *)aFont).font;
		return self;
	}
	return nil;
}

+(CFAFont *)fontWithFont:(id)aFont {
	return [[[CFAFont alloc] initWithFont:aFont] autorelease];
}

+(CFAFont *)fontWithName:(id)name {
	return [[[CFAFont alloc] initWithName:name size:14.0f] autorelease];
}

+(CFAFont *)fontWithName:(id)name size:(CGFloat)size {
	return [[[CFAFont alloc] initWithName:name size:size] autorelease];
}

+(CFAFont *)userFontOfSize:(CGFloat)size {
	return [CFAFont fontWithFont:[NSFont userFontOfSize:size]];
}

+(CFAFont *)boldSystemFontOfSize:(CGFloat)size {
	return [CFAFont fontWithFont:[NSFont boldSystemFontOfSize:size]];
}

+(CFAFont *)messageFontOfSize:(CGFloat)size {
	return [CFAFont fontWithFont:[NSFont messageFontOfSize:size]];
}

+(CFAFont *)systemFontOfSize:(CGFloat)size {
	return [CFAFont fontWithFont:[NSFont systemFontOfSize:size]];
}

+(CGFloat)smallSystemFontSize {
	return [NSFont smallSystemFontSize];
}

+(CGFloat)systemFontSize {
	return [NSFont systemFontSize];
}


-(CGFloat)ascender {
	return self.font.ascender;
}

-(CGFloat)capHeight {
	return self.font.capHeight;
}

-(CGFloat)descender {
	return self.font.descender;
}

-(CGFloat)italicAngle {
	return self.font.italicAngle;
}

-(CGFloat)leading {
	return self.font.leading;
}

-(CGFloat)pointSize {
	return self.font.pointSize;
}

-(CGFloat)underlinePosition {
	return self.font.underlinePosition;
}

-(CGFloat)underlineThickness {
	return self.font.underlineThickness;
}

-(CGFloat)xHeight {
	return self.font.xHeight;
}


-(CFAString *)displayName {
	return [CFAString stringWithString:self.font.displayName];
}

-(CFAString *)familyName {
	return [CFAString stringWithString:self.font.familyName];
}

-(CFAString *)fontName {
	return [CFAString stringWithString:self.font.fontName];
}

+(NSArray *)availableFonts {
	return [[NSFontManager sharedFontManager] availableFonts];
}

-(NSString *)description {
	return [NSString stringWithFormat:@"%@ %4.2fpt",[self.font fontName],[self.font pointSize]];
}

@end
