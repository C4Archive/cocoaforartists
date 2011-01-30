//
//  CFAImage.m
//  Created by Travis Kirton
//

#import "CFAImage.h"
@implementation CFAImage

@synthesize ciimage, width, height, size;

+(void)load {
	if(VERBOSELOAD) printf("CFAImage\n");
}

-(id)init {
	if (![super init]) {
		return nil;
	}
	self.ciimage = [CIImage emptyImage];
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
	
	self.ciimage = [CIImage imageWithContentsOfURL:url];
	size = NSSizeFromCGSize([ciimage extent].size);
	return self;
}

-(id)initWithImageName:(NSString *)name {
	return [self initWithImageName:name andType:nil];
}

-(float)width {
	return size.width;
}

-(float)height {
	return size.height;
}

-(void)loadPixelData {
	NSBitmapImageRep* rep = [[[NSBitmapImageRep alloc] initWithCIImage:ciimage] autorelease];
	
	// First get the image into your data buffer
	CGImageRef imageRef = [rep CGImage];
	NSUInteger w = CGImageGetWidth(imageRef);
	NSUInteger h = CGImageGetHeight(imageRef);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	rawData = malloc(h * w * 4);
	bytesPerPixel = 4;
	NSUInteger bytesPerRow = bytesPerPixel * w;
	NSUInteger bitsPerComponent = 8;
	CGContextRef context = CGBitmapContextCreate(rawData, w, h,
												 bitsPerComponent, bytesPerRow, colorSpace,
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	
	CGContextDrawImage(context, CGRectMake(0, 0, w, h), imageRef);
	CGContextRelease(context);
}

-(CFAColor *)colorAtX:(int)x andY:(int)y {
	int byteIndex = (bytesPerPixel * self.width * y) + x * bytesPerPixel;
	CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
	CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
	CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
	CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
	
	return [CFAColor colorWithRed:red green:green blue:blue alpha:alpha];
}

-(void)drawAt:(NSPoint)p {
	[ciimage drawAtPoint:p fromRect:NSRectFromCGRect([ciimage extent]) operation:NSCompositeCopy fraction:1.0];
}

-(void)drawAt:(NSPoint)p withAlpha:(float)alpha{
	[ciimage drawAtPoint:p fromRect:NSRectFromCGRect([ciimage extent]) operation:NSCompositeSourceOver fraction:alpha];
}

-(void)drawAt:(NSPoint)p withWidth:(float)w andHeight:(float)h {
	[ciimage drawInRect:NSMakeRect(p.x, p.y, w, h) fromRect:NSRectFromCGRect([ciimage extent]) operation:NSCompositeCopy fraction:1.0];
}

-(void)drawAt:(NSPoint)p withWidth:(float)w andHeight:(float)h withAlpha:(float)a{
	[ciimage drawInRect:NSMakeRect(p.x, p.y, w, h) fromRect:NSRectFromCGRect([ciimage extent]) operation:NSCompositeSourceOver fraction:a];
}

@end
