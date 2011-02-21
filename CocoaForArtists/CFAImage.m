//
//  CFAImage.m
//  Created by Travis Kirton
//

#import "CFAImage.h"
@implementation CFAImage

@synthesize originalImage, filteredImage, imageWidth, imageHeight, imageSize, imageRect, drawFilteredImage, filterContext;

+(void)load {
	if(VERBOSELOAD) printf("CFAImage\n");
}

-(id)init {
	if (![super init]) {
		return nil;
	}
	self.originalImage = [CIImage emptyImage];
	imageRect = [originalImage extent];
	filterContext = [[CIContext contextWithCGContext:[[NSGraphicsContext currentContext] graphicsPort]
											 options:nil] retain];
	singleFilter = YES;
	return self;
}

-(id)initWithImage:(CFAImage *)image {
	[self setOriginalImage:image.originalImage];
	imageRect = [originalImage extent];
	filterContext = [[CIContext contextWithCGContext:[[NSGraphicsContext currentContext] graphicsPort]
									  options:nil] retain];
	singleFilter = YES;
	return self;
}

-(id)initWithImageName:(NSString *)name {
	NSArray *nameComponents = [name componentsSeparatedByString:@"."];
	if([nameComponents count] == 2) [self initWithImageName:[nameComponents objectAtIndex:0] andType:[nameComponents objectAtIndex:1]];
	return nil;
}

-(id)initWithImageName:(NSString *)name andType:(NSString *)type{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	NSString *   path = [[NSBundle mainBundle] pathForResource:name
														ofType:type];
	NSURL *      url = [NSURL fileURLWithPath: path];
	
	self.originalImage = [CIImage imageWithContentsOfURL:url];
	imageRect = [originalImage extent];
	[self setFilterContext:[CIContext contextWithCGContext:[[NSGraphicsContext currentContext] graphicsPort] options:nil]];
	singleFilter = YES;
	[pool release];
	return self;
}

+(CFAImage *)imageName:(NSString *)name {
	NSArray *nameComponents = [name componentsSeparatedByString:@"."];
	if([nameComponents count] == 2) return [CFAImage imageName:[nameComponents objectAtIndex:0] andType:[nameComponents objectAtIndex:1]];
	return nil;
			
}

+(CFAImage *)imageName:(NSString *)name andType:(NSString *)type {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	CFAImage *image = [[CFAImage alloc] initWithImageName:name andType:type];
	if(image == nil) {
		[image release];
		image = nil;
	} else {
		[image retain];
	}
	[pool release];
	return image;
}

-(void)dealloc {
	free(rawData);
	[super dealloc];
}

-(void)loadPixelData {
	NSBitmapImageRep* rep = [[[NSBitmapImageRep alloc] initWithCIImage:originalImage] autorelease];
	
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
	int byteIndex = (bytesPerPixel * self.imageWidth * y) + x * bytesPerPixel;
	CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
	CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
	CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
	CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
	
	return [CFAColor colorWithRed:red green:green blue:blue alpha:alpha];
}

-(void)drawAt:(NSPoint)p {
	if(!drawFilteredImage) {
		[originalImage drawAtPoint:p fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
	}
	else {
		[filteredImage drawAtPoint:p fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
	}
}

-(void)drawAt:(NSPoint)p withAlpha:(float)alpha{
	if(!drawFilteredImage) {
		[originalImage drawAtPoint:p fromRect:imageRect operation:NSCompositeSourceOver fraction:alpha];
	}
	else {
		[filteredImage drawAtPoint:p fromRect:imageRect operation:NSCompositeSourceOver fraction:alpha];
	}
}

-(void)drawAt:(NSPoint)p withWidth:(float)w andHeight:(float)h {
	if(!drawFilteredImage) {
		[originalImage drawInRect:NSMakeRect(p.x, p.y, w, h) fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
	}
	else {
		[filteredImage drawInRect:NSMakeRect(p.x, p.y, w, h) fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
	}
}

-(void)drawAt:(NSPoint)p withWidth:(float)w andHeight:(float)h withAlpha:(float)a{
	if(!drawFilteredImage) {
		[originalImage drawInRect:NSMakeRect(p.x, p.y, w, h) fromRect:imageRect operation:NSCompositeSourceOver fraction:a];
	}
	else {
		[filteredImage drawInRect:NSMakeRect(p.x, p.y, w, h) fromRect:imageRect operation:NSCompositeSourceOver fraction:a];
	}
}

-(void)drawInRect:(NSRect)rect {
	[self drawInRect:rect withAlpha:1.0f];
}

-(void)drawInRect:(NSRect)rect withAlpha:(CGFloat)alpha{
	if (!drawFilteredImage) {
		[originalImage drawInRect:rect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
	} else {
		[filteredImage drawInRect:rect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
	}
}

/*
 Filters
 */

-(void)drawFilteredImageAt:(NSPoint)p {
	[filterContext drawImage:filteredImage
					 atPoint:NSPointToCGPoint(p)
					fromRect:[CFACanvas getCanvasRect]];
}

-(void)drawFilteredImageInRect:(NSRect)aRect {
}

-(void)singleFilter {
	singleFilter = YES;
	filteredImage = nil;
}

-(void)combinedFilter {
	singleFilter = NO;
	filteredImage = [originalImage copy];
}

/*
 CIFilter *filter = [CIFilter filterWithName:];
 [filter setDefaults];
 if(singleFilter) {
 [filter setValue:originalImage forKey:@"inputImage"];
 } else {
 [filter setValue:filteredImage forKey:@"inputImage"];
 }
 
 [filter setValue: forKey:@""];
 filteredImage = [filter valueForKey: @"outputImage"];
*/

#pragma mark BLUR FILTERS
-(void)gaussianBlur:(CGFloat)radius {
	CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}

	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	filteredImage = [filter valueForKey: @"outputImage"];
}

-(void)motionBlur:(CGFloat)radius angle:(CGFloat)angle {
	CIFilter *filter = [CIFilter filterWithName:@"CIMotionBlur"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	filteredImage = [filter valueForKey: @"outputImage"];
	
}

-(void)zoomBlur:(NSPoint)center amount:(CGFloat)amount {
	CIFilter *filter = [CIFilter filterWithName:@"CIZoomBlur"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:amount] forKey:@"inputAmount"];
	filteredImage = [filter valueForKey: @"outputImage"];
}

#pragma mark TILE FILTERS
-(void)kaleidoscope:(NSPoint)center count:(NSUInteger)count angle:(CGFloat)angle {
	CIFilter *filter = [CIFilter filterWithName:@"CIKaleidoscope"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	count = [CFAMath constrain:count min:1 max:64];
	[filter setValue:[NSNumber numberWithInt:count] forKey:@"inputCount"];
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)opTile:(NSPoint)center scale:(CGFloat)scale angle:(CGFloat)angle width:(CGFloat)width {
	CIFilter *filter = [CIFilter filterWithName:@"CIOpTile"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	if(scale < 0.0f) scale = 0.0f;
	[filter setValue:[NSNumber numberWithFloat:scale] forKey:@"inputScale"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	[filter setValue:[NSNumber numberWithFloat:width] forKey:@"inputWidth"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)parallelogramTile:(NSPoint)center angle:(CGFloat)angle acuteAngle:(CGFloat)acute width:(CGFloat)width{
	CIFilter *filter = [CIFilter filterWithName:@"CIParallelogramTile"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	[filter setValue:[NSNumber numberWithFloat:acute] forKey:@"inputAcuteAngle"];
	[filter setValue:[NSNumber numberWithFloat:width] forKey:@"inputWidth"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)perspectiveTile:(NSPoint)topLeft topRight:(NSPoint)topRight bottomRight:(NSPoint)bottomRight bottomLeft:(NSPoint)bottomLeft{
	CIFilter *filter = [CIFilter filterWithName:@"CIPerspectiveTile"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:topLeft.x Y:topLeft.y] forKey:@"inputTopLeft"];
	[filter setValue:[CIVector vectorWithX:topRight.x Y:topRight.y] forKey:@"inputTopRight"];
	[filter setValue:[CIVector vectorWithX:bottomRight.x Y:bottomRight.y] forKey:@"inputBottomRight"];
	[filter setValue:[CIVector vectorWithX:bottomLeft.x Y:bottomLeft.y] forKey:@"inputBottomLeft"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)triangleTile:(NSPoint)center angle:(CGFloat)angle width:(CGFloat)width{
	CIFilter *filter = [CIFilter filterWithName:@"CITriangleTile"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	[filter setValue:[NSNumber numberWithFloat:width] forKey:@"inputWidth"];
	filteredImage = [filter valueForKey: @"outputImage"];
}

-(void)colorControls:(CGFloat)saturation brightness:(CGFloat)brightness contrast:(CGFloat)contrast{
	CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[NSNumber numberWithFloat:saturation] forKey:@"inputSaturation"];
	[filter setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputBrightness"];
	[filter setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputContrast"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)exposureAdjust:(CGFloat)exposure{
	CIFilter *filter = [CIFilter filterWithName:@"CIExposureAdjust"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[NSNumber numberWithFloat:exposure] forKey:@"inputEV"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)gammaAdjust:(CGFloat)gamma{
	CIFilter *filter = [CIFilter filterWithName:@"CIGammaAdjust"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[NSNumber numberWithFloat:gamma] forKey:@"inputPower"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)hueAdjust:(CGFloat)hue{
	CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[NSNumber numberWithFloat:hue] forKey:@"inputAngle"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)invert{
	CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)monochrome:(CFAColor *)color intensity:(CGFloat)intensity{
	CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIColor colorWithCGColor:[color cgColor]] forKey:@"inputColor"];
	[filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)posterize:(CGFloat)intensity{
	CIFilter *filter = [CIFilter filterWithName:@"CIColorPosterize"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputLevels"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)maxGrayscale{
	CIFilter *filter = [CIFilter filterWithName:@"CIMaximumComponent"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)minGrayscale{
	CIFilter *filter = [CIFilter filterWithName:@"CIMinimumComponent"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)sepia:(CGFloat)intensity{
	CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
	filteredImage = [filter valueForKey: @"outputImage"];
}

-(void)colorBlend:(CFAImage *)backgroundImage{
	CIFilter *filter = [CIFilter filterWithName:@"CIColorBlendMode"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)burnBlend:(CFAImage *)backgroundImage{
	CIFilter *filter = [CIFilter filterWithName:@"CIColorBurnBlendMode"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)darkenBlend:(CFAImage *)backgroundImage{
	CIFilter *filter = [CIFilter filterWithName:@"CIDarkenBlendMode"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)differenceBlend:(CFAImage *)backgroundImage{
	CIFilter *filter = [CIFilter filterWithName:@"CIDifferenceBlendMode"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)exclusionBlend:(CFAImage *)backgroundImage{
	CIFilter *filter = [CIFilter filterWithName:@"CIExclusionBlendMode"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)hardLightBlend:(CFAImage *)backgroundImage{
	CIFilter *filter = [CIFilter filterWithName:@"CIHardLightBlendMode"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)hueBlend:(CFAImage *)backgroundImage{
	CIFilter *filter = [CIFilter filterWithName:@"CIHueBlendMode"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)lightenBlend:(CFAImage *)backgroundImage{
	CIFilter *filter = [CIFilter filterWithName:@"CILightenBlendMode"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)luminosityBlend:(CFAImage *)backgroundImage{
	CIFilter *filter = [CIFilter filterWithName:@"CILuminosityBlendMode"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)multiplyBlend:(CFAImage *)backgroundImage{
	CIFilter *filter = [CIFilter filterWithName:@"CIMultiplyBlendMode"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)overlayBlend:(CFAImage *)backgroundImage{
	CIFilter *filter = [CIFilter filterWithName:@"CIOverlayBlendMode"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)saturationBlend:(CFAImage *)backgroundImage{
	CIFilter *filter = [CIFilter filterWithName:@"CISaturationBlendMode"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)screenBlend:(CFAImage *)backgroundImage{
	CIFilter *filter = [CIFilter filterWithName:@"CIScreenBlendMode"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)softLightBlend:(CFAImage *)backgroundImage{
	CIFilter *filter = [CIFilter filterWithName:@"CISoftLightBlendMode"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}

-(void)bumpDistortion:(NSPoint)center radius:(CGFloat)radius scale:(CGFloat)scale{
	CIFilter *filter = [CIFilter filterWithName:@"CIBumpDistortion"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	[filter setValue:[NSNumber numberWithFloat:scale] forKey:@"inputScale"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)bumpLinearDistortion:(NSPoint)center radius:(CGFloat)radius angle:(CGFloat)angle scale:(CGFloat)scale{
	CIFilter *filter = [CIFilter filterWithName:@"CIBumpDistortionLinear"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	[filter setValue:[NSNumber numberWithFloat:scale] forKey:@"inputScale"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)circleDistortion:(NSPoint)center radius:(CGFloat)radius{
	CIFilter *filter = [CIFilter filterWithName:@"CICircleSplashDistortion"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	filteredImage = [filter valueForKey: @"outputImage"];
}

-(void)circularScreen:(NSPoint)center width:(CGFloat)width sharpness:(CGFloat)sharpness{
	CIFilter *filter = [CIFilter filterWithName:@"CICircularScreen"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:width] forKey:@"inputWidth"];
	[filter setValue:[NSNumber numberWithFloat:sharpness] forKey:@"inputSharpness"];
	
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)circularWrap:(NSPoint)center radius:(CGFloat)radius angle:(CGFloat)angle{
	CIFilter *filter = [CIFilter filterWithName:@"CICircularWrap"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}

	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)holeDistortion:(NSPoint)center radius:(CGFloat)radius{
	CIFilter *filter = [CIFilter filterWithName:@"CIHoleDistortion"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)twirlDistortion:(NSPoint)center radius:(CGFloat)radius angle:(CGFloat)angle{
	CIFilter *filter = [CIFilter filterWithName:@"CITwirlDistortion"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)vortexDistortion:(NSPoint)center radius:(CGFloat)radius angle:(CGFloat)angle{
	CIFilter *filter = [CIFilter filterWithName:@"CIVortexDistortion"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	filteredImage = [filter valueForKey: @"outputImage"];
}

-(void)dotScreen:(NSPoint)center angle:(CGFloat)angle width:(CGFloat)width sharpness:(CGFloat)sharpness{
	CIFilter *filter = [CIFilter filterWithName:@"CIDotScreen"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	[filter setValue:[NSNumber numberWithFloat:width] forKey:@"inputWidth"];
	[filter setValue:[NSNumber numberWithFloat:sharpness] forKey:@"inputSharpness"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)hatchedScreen:(NSPoint)center angle:(CGFloat)angle width:(CGFloat)width sharpness:(CGFloat)sharpness{
	CIFilter *filter = [CIFilter filterWithName:@"CIHatchedScreen"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	[filter setValue:[NSNumber numberWithFloat:width] forKey:@"inputWidth"];
	[filter setValue:[NSNumber numberWithFloat:sharpness] forKey:@"inputSharpness"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)lineScreen:(NSPoint)center angle:(CGFloat)angle width:(CGFloat)width sharpness:(CGFloat)sharpness{
	CIFilter *filter = [CIFilter filterWithName:@"CILineScreen"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	[filter setValue:[NSNumber numberWithFloat:width] forKey:@"inputWidth"];
	[filter setValue:[NSNumber numberWithFloat:sharpness] forKey:@"inputSharpness"];
	filteredImage = [filter valueForKey: @"outputImage"];
}

-(void)blendWithMask:(CFAImage *)backgroundImage maskImage:(CFAImage *)maskImage{
	CIFilter *filter = [CIFilter filterWithName:@"CIBlendWithMask"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:backgroundImage.originalImage forKey:@"inputBackgroundImage"];
	[filter setValue:maskImage.originalImage forKey:@"inputMaskImage"];
	filteredImage = [filter valueForKey: @"outputImage"];
}

-(void)bloom:(CGFloat)radius intensity:(CGFloat)intensity{
	CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	[filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)comicEffect{
	CIFilter *filter = [CIFilter filterWithName:@"CIComicEffect"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)crystallize:(NSPoint)center radius:(CGFloat)radius{
	CIFilter *filter = [CIFilter filterWithName:@"CICrystallize"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)edges:(CGFloat)intensity{
	CIFilter *filter = [CIFilter filterWithName:@"CIEdges"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)edgeWork:(CGFloat)radius{
	CIFilter *filter = [CIFilter filterWithName:@"CIEdgeWork"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)gloom:(CGFloat)radius intensity:(CGFloat)intensity{
	CIFilter *filter = [CIFilter filterWithName:@"CIGloom"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)hexagonalPixellate:(NSPoint)center scale:(CGFloat)scale{
	CIFilter *filter = [CIFilter filterWithName:@"CIHexagonalPixellate"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:scale] forKey:@"inputScale"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)pixellate:(NSPoint)center scale:(CGFloat)scale{
	CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}
	
	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:scale] forKey:@"inputScale"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
-(void)pointillize:(NSPoint)center radius:(CGFloat)radius{
	CIFilter *filter = [CIFilter filterWithName:@"CIPointillize"];
	[filter setDefaults];
	if(singleFilter) {
		[filter setValue:originalImage forKey:@"inputImage"];
	} else {
		[filter setValue:filteredImage forKey:@"inputImage"];
	}

	[filter setValue:[CIVector vectorWithX:center.x Y:center.y] forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	filteredImage = [filter valueForKey: @"outputImage"];
}
@end
