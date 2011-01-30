//
//  CFAFont.h
//  ___PROJECTNAME___
//
//  Created by Travis Kirton on 11-01-30.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CFAFont : NSObject {
	NSFont *font;
}

+(CFAFont *)fontWithName:(id)name size:(float)size;
+(CFAFont *)userFontOfSize:(float)size;
+(CFAFont *)boldSystemFontOfSize:(float)size;
+(CFAFont *)messageFontOfSize:(float)size;
+(CFAFont *)systemFontOfSize:(float)size;
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

@property(readwrite, retain) NSFont *font;
@end