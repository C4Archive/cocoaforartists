//
//  CFAImage.m
//  CFADevelop
//
//  Created by Travis Kirton on 10-09-12.
//  Copyright 2010 Travis Kirton. All rights reserved.
//

#import "CFAImage.h"
@interface CFAImage (private)
CIImage *ciimage;
unsigned char *rawData;
NSUInteger bytesPerPixel = 4;
@end

@implementation CFAImage

@synthesize ciimage;

+(void)load {
	if(VERBOSELOAD) printf("CFAImage\n");
}

-(id)init {
	if (![super init]) {
		return nil;
	}
	[self setCiimage:[CIImage emptyImage]];
	return self;
}

-(void)dealloc {
	free(rawData);
	[super dealloc];
}

+(CFAImage *)imageName:(NSString *)name andType:(NSString *)type {
	return [self imageName:name andType:type loadPixelData:NO];
}

+(CFAImage *)imageName:(NSString *)name andType:(NSString *)type loadPixelData:(BOOL)load{
	CFAImage *newImage = [[[CFAImage alloc] initWithImageName:name andType:type] retain];
	if(load) [newImage loadPixelData];
	return newImage;
}

-(id)initWithImageName:(NSString *)name andType:(NSString *)type{
	if(![super init]){
		return nil;
	}
	
	NSString *   path = [[NSBundle mainBundle] pathForResource:name
														ofType:type];
	NSURL *      url = [NSURL fileURLWithPath: path];
	
	[self setCiimage:[CIImage imageWithContentsOfURL:url]];
	return self;
}

-(id)initWithImageName:(NSString *)name {
	return [self initWithImageName:name andType:nil];
}

-(int)width {
	return (int)[ciimage extent].size.width;
}

-(int)height {
	return (int)[ciimage extent].size.height;
}

-(void)loadPixelData {
	NSBitmapImageRep* rep = [[[NSBitmapImageRep alloc] initWithCIImage:ciimage] autorelease];
	
	// First get the image into your data buffer
	CGImageRef imageRef = [rep CGImage];
	NSUInteger width = CGImageGetWidth(imageRef);
	NSUInteger height = CGImageGetHeight(imageRef);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	rawData = malloc(height * width * 4);
	bytesPerPixel = 4;
	NSUInteger bytesPerRow = bytesPerPixel * width;
	NSUInteger bitsPerComponent = 8;
	CGContextRef context = CGBitmapContextCreate(rawData, width, height,
												 bitsPerComponent, bytesPerRow, colorSpace,
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
	CGContextRelease(context);
}

-(NSColor *)colorAtX:(int)x andY:(int)y {
	int byteIndex = (bytesPerPixel * [self width] * y) + x * bytesPerPixel;
	CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
	CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
	CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
	CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
	
	return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
}

-(void)drawAt:(NSPoint)p {
	[[self ciimage] drawAtPoint:p fromRect:NSRectFromCGRect([[self ciimage] extent]) operation:NSCompositeCopy fraction:1.0];
}

-(void)drawAt:(NSPoint)p withAlpha:(float)alpha{
	[[self ciimage] drawAtPoint:p fromRect:NSRectFromCGRect([[self ciimage] extent]) operation:NSCompositeSourceOver fraction:alpha];
}

-(void)drawAt:(NSPoint)p withWidth:(float)width andHeight:(float)height {
	[[self ciimage] drawInRect:NSMakeRect(p.x, p.y, width, height) fromRect:NSRectFromCGRect([[self ciimage] extent]) operation:NSCompositeCopy fraction:1.0];
}

-(void)drawAt:(NSPoint)p withWidth:(float)width andHeight:(float)height withAlpha:(float)alpha{
	[[self ciimage] drawInRect:NSMakeRect(p.x, p.y, width, height) fromRect:NSRectFromCGRect([[self ciimage] extent]) operation:NSCompositeSourceOver fraction:alpha];
}

@end
