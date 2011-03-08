//
//  CFAFont.h
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-01-30.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CFAFont : CFAObject {
	NSFont *font;
}

-(id)init;
-(id)initWithName:(id)name;
-(id)initWithName:(id)name size:(CGFloat)size;
-(id)initWithFont:(id)aFont;

+(CFAFont *)fontWithFont:(id)aFont;
+(CFAFont *)fontWithName:(id)name size:(CGFloat)size;
+(CFAFont *)userFontOfSize:(CGFloat)size;
+(CFAFont *)boldSystemFontOfSize:(CGFloat)size;
+(CFAFont *)messageFontOfSize:(CGFloat)size;
+(CFAFont *)systemFontOfSize:(CGFloat)size;

+(CGFloat)smallSystemFontSize;
+(CGFloat)systemFontSize;

-(CGFloat)ascender;
-(CGFloat)capHeight;
-(CGFloat)descender;
-(CGFloat)italicAngle;
-(CGFloat)leading;
-(CGFloat)pointSize;
-(CGFloat)underlinePosition;
-(CGFloat)underlineThickness;
-(CGFloat)xHeight;

-(CFAString *)displayName;
-(CFAString *)familyName;
-(CFAString *)fontName;

+(NSArray *)availableFonts;

@property(readwrite, retain) NSFont *font;
@end