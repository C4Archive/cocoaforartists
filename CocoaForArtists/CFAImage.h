//
//  CFAImage.h
//  Created by Travis Kirton
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface CFAImage : CFAObject {
	@private
	CIContext *filterContext;
	NSSize imageSize;
	NSRect imageRect;
	CGFloat imageHeight, imageWidth;
	unsigned char *rawData;
	CIImage *originalImage, *filteredImage;
	BOOL singleFilter, drawFilteredImage;
	NSUInteger bytesPerPixel;
}


+(CFAImage *)imageName:(NSString *)name;
+(CFAImage *)imageName:(NSString *)name andType:(NSString *)type;

-(id)initWithImage:(CFAImage *)image;
-(id)initWithImageName:(NSString *)name;
-(id)initWithImageName:(NSString *)name andType:(NSString *)type;

-(void)drawAt:(NSPoint)p;
-(void)drawAt:(NSPoint)p withAlpha:(float)alpha;
-(void)drawAt:(NSPoint)p withWidth:(float)w andHeight:(float)h;
-(void)drawAt:(NSPoint)p withWidth:(float)w andHeight:(float)h withAlpha:(float)a;
-(void)drawInRect:(NSRect)rect;
-(void)drawInRect:(NSRect)rect withAlpha:(CGFloat)alpha;

-(CFAColor *)colorAtX:(int)x andY:(int)y;
-(void)loadPixelData;

@property(readwrite,retain) CIImage *originalImage, *filteredImage;
@property(readonly) CGFloat imageWidth, imageHeight;
@property(readonly) NSSize imageSize;
@property(readonly) NSRect imageRect;
@property(readwrite, retain) CIContext *filterContext;
@property(readwrite) BOOL drawFilteredImage;

/*
 Filters
 */

-(void)singleFilter;
-(void)combinedFilter;

-(void)gaussianBlur:(CGFloat)radius;
-(void)motionBlur:(CGFloat)radius angle:(CGFloat)angle;
-(void)zoomBlur:(NSPoint)center amount:(CGFloat)amount;

-(void)kaleidoscope:(NSPoint)center count:(NSUInteger)count angle:(CGFloat)angle;
-(void)opTile:(NSPoint)center scale:(CGFloat)scale angle:(CGFloat)angle width:(CGFloat)width;
-(void)parallelogramTile:(NSPoint)center angle:(CGFloat)angle acuteAngle:(CGFloat)acute width:(CGFloat)width;
-(void)perspectiveTile:(NSPoint)topLeft topRight:(NSPoint)topRight bottomRight:(NSPoint)bottomRight bottomLeft:(NSPoint)bottomLeft;
-(void)triangleTile:(NSPoint)center angle:(CGFloat)angle width:(CGFloat)width;

-(void)colorControls:(CGFloat)saturation brightness:(CGFloat)brightness contrast:(CGFloat)contrast;
-(void)exposureAdjust:(CGFloat)exposure;
-(void)gammaAdjust:(CGFloat)gamma;
-(void)hueAdjust:(CGFloat)hue;

-(void)invert;
-(void)monochrome:(CFAColor *)color intensity:(CGFloat)intensity;
-(void)posterize:(CGFloat)intensity;
-(void)maxGrayscale;
-(void)minGrayscale;
-(void)sepia:(CGFloat)intensity;

-(void)colorBlend:(CFAImage *)backgroundImage;
-(void)burnBlend:(CFAImage *)backgroundImage;
-(void)darkenBlend:(CFAImage *)backgroundImage;
-(void)differenceBlend:(CFAImage *)backgroundImage;
-(void)exclusionBlend:(CFAImage *)backgroundImage;
-(void)hardLightBlend:(CFAImage *)backgroundImage;
-(void)hueBlend:(CFAImage *)backgroundImage;
-(void)lightenBlend:(CFAImage *)backgroundImage;
-(void)luminosityBlend:(CFAImage *)backgroundImage;
-(void)multiplyBlend:(CFAImage *)backgroundImage;
-(void)overlayBlend:(CFAImage *)backgroundImage;
-(void)saturationBlend:(CFAImage *)backgroundImage;
-(void)screenBlend:(CFAImage *)backgroundImage;
-(void)softLightBlend:(CFAImage *)backgroundImage;

-(void)bumpDistortion:(NSPoint)center radius:(CGFloat)radius scale:(CGFloat)scale;
-(void)bumpLinearDistortion:(NSPoint)center radius:(CGFloat)radius angle:(CGFloat)angle scale:(CGFloat)scale;
-(void)circleDistortion:(NSPoint)center radius:(CGFloat)radius;
-(void)circularScreen:(NSPoint)center width:(CGFloat)width sharpness:(CGFloat)sharpness;
-(void)circularWrap:(NSPoint)center radius:(CGFloat)radius angle:(CGFloat)angle;
-(void)holeDistortion:(NSPoint)center radius:(CGFloat)radius;
-(void)twirlDistortion:(NSPoint)center radius:(CGFloat)radius angle:(CGFloat)angle;
-(void)vortexDistortion:(NSPoint)center radius:(CGFloat)radius angle:(CGFloat)angle;

-(void)dotScreen:(NSPoint)center angle:(CGFloat)angle width:(CGFloat)width sharpness:(CGFloat)sharpness;
-(void)hatchedScreen:(NSPoint)center angle:(CGFloat)angle width:(CGFloat)width sharpness:(CGFloat)sharpness;
-(void)lineScreen:(NSPoint)center angle:(CGFloat)angle width:(CGFloat)width sharpness:(CGFloat)sharpness;

-(void)blendWithMask:(CFAImage *)backgroundImage maskImage:(CFAImage *)maskImage;
-(void)bloom:(CGFloat)radius intensity:(CGFloat)intensity;
-(void)comicEffect;
-(void)crystallize:(NSPoint)center radius:(CGFloat)radius;
-(void)edges:(CGFloat)intensity;
-(void)edgeWork:(CGFloat)radius;
-(void)gloom:(CGFloat)radius intensity:(CGFloat)intensity;
-(void)hexagonalPixellate:(NSPoint)center scale:(CGFloat)scale;
-(void)pixellate:(NSPoint)center scale:(CGFloat)scale;
-(void)pointillize:(NSPoint)center radius:(CGFloat)radius;
@end

@interface CFAImage (private)
-(void)drawFilteredImageAt:(NSPoint)p;
-(void)drawFilteredImageInRect:(NSRect)aRect;
@end

