//
//  CFAImage.h
//  Created by Travis Kirton
//

#import <Cocoa/Cocoa.h>

@interface CFAImage : NSObject {
	@private
	NSSize size;
	float height, width;
	unsigned char *rawData;
	CIImage *ciimage;
	NSUInteger bytesPerPixel;
}

+(CFAImage *)imageName:(NSString *)name andType:(NSString *)type;
+(CFAImage *)imageName:(NSString *)name andType:(NSString *)type loadPixelData:(BOOL)load;
-(id)initWithImageName:(NSString *)name;
-(id)initWithImageName:(NSString *)name andType:(NSString *)type;
-(void)drawAt:(NSPoint)p;
-(void)drawAt:(NSPoint)p withAlpha:(float)alpha;
-(void)drawAt:(NSPoint)p withWidth:(float)w andHeight:(float)h;
-(void)drawAt:(NSPoint)p withWidth:(float)w andHeight:(float)h withAlpha:(float)a;

-(CFAColor *)colorAtX:(int)x andY:(int)y;
-(void)loadPixelData;

@property(readwrite,retain) CIImage *ciimage;
@property(readonly) float width;
@property(readonly) float height;
@property(readonly) NSSize size;
@end
