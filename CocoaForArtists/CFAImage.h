//
//  CFAImage.h
//  CFADevelop
//
//  Created by Travis Kirton on 10-09-12.
//  Copyright 2010 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CFAImage : NSObject {
}

+(CFAImage *)imageName:(NSString *)name andType:(NSString *)type;
+(CFAImage *)imageName:(NSString *)name andType:(NSString *)type loadPixelData:(BOOL)load;
-(id)initWithImageName:(NSString *)name;
-(id)initWithImageName:(NSString *)name andType:(NSString *)type;
-(void)drawAt:(NSPoint)p;
-(void)drawAt:(NSPoint)p withAlpha:(float)alpha;
-(void)drawAt:(NSPoint)p withWidth:(float)width andHeight:(float)height;
-(void)drawAt:(NSPoint)p withWidth:(float)width andHeight:(float)height withAlpha:(float)alpha;

-(int)width;
-(int)height;
-(CFAColor *)colorAtX:(int)x andY:(int)y;
-(void)loadPixelData;

@property(readwrite, retain) CIImage *ciimage;

@end
