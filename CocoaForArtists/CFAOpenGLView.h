//
//  CFAOpenGLView.h
//  Created by Travis Kirton.
//

#import <Cocoa/Cocoa.h>

@interface CFAOpenGLView : NSOpenGLView {
	
	BOOL keyIsPressed, mouseIsPressed;
	NSInteger keyChar, keyCode, mouseButton;
	NSPoint mousePos, prevMousePos;
	
	@private
	NSRect canvasRect;
	NSSize canvasSize, screenSize;
	CGFloat canvasWidth, canvasHeight, screenWidth, screenHeight;	
	CFAColor *backgroundColor;
	NSString *exportDir, *exportFileName, *exportFileType;
	NSInteger frameCount, currentDrawStyle;
	CGFloat frameRate;
}

#pragma mark Singleton
-(id)_init;
+(CFAOpenGLView *)sharedManager;

#pragma mark Structure
-(void)setup;
-(void)draw;
-(void)redraw;
-(void)windowWidth:(NSInteger)width andHeight:(NSInteger)height;
-(void)flipCoordinates;
-(void)nativeCoordinates;
-(void)drawStyle:(NSInteger)style;

#pragma mark Environment
-(void)cursor;
-(void)noCursor;
-(void)enterFullScreen;
-(void)exitFullScreen;
-(IBAction)switchFullScreen:(id)sender;
+(CGFloat)getScreenWidth;
+(CGFloat)getScreenHeight;
+(CGFloat)getCanvasWidth;
+(CGFloat)getCanvasHeight;
+(NSRect)getCanvasRect;
+(NSPoint)getMousePos;
+(NSInteger)getMouseButton;

#pragma mark Background
-(void)drawBackground;
-(void)background:(CGFloat)grey;
-(void)background:(CGFloat)grey alpha:(CGFloat)alpha;
-(void)backgroundRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
-(void)backgroundRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
-(void)backgroundColor:(id)color;
-(void)backgroundImage:(CFAImage *)bgImage;

#pragma mark Input
-(void)keyPressed;
-(void)keyReleased;
-(void)mousePressed;
-(void)mouseReleased;
-(void)mouseDragged;
-(void)mouseMoved;
-(void)mouseClicked;
-(void)mouseDoubleClicked;

#pragma mark Output
-(void)setupPDF;
-(void)endPDF;

@property(readonly) BOOL keyIsPressed, mouseIsPressed;
@property(readonly) NSInteger keyChar, keyCode, mouseButton, frameCount, currentDrawStyle;
@property(readonly) NSPoint mousePos, prevMousePos;
@property(readonly) NSSize canvasSize, screenSize;
@property(readonly) NSRect canvasRect;
@property(readonly) CGFloat canvasWidth, canvasHeight, screenWidth, screenHeight;
@property(readwrite) CGFloat frameRate;

@property(readwrite,retain) CFAColor *backgroundColor;
@property(readwrite,retain) NSString *exportDir;
@property(readwrite,retain) NSString *exportFileName;
@property(readwrite,retain) NSString *exportFileType;

@end

@interface CFAOpenGLView (private)

BOOL isClean;

BOOL readyToDraw;
BOOL backgroundShouldDraw;
BOOL flipped;
BOOL isSetup;
BOOL drawToPDF;

CFURLRef pdfURL;
CGContextRef pdfContext;
CGDataConsumerRef pdfConsumer;

NSRect	backgroundRect;
NSTimer *animationTimer;
NSDictionary *fullScreenOptions;

-(void)prepareOpenGL;
-(void)getPixelData;
-(void)setAnimationTimer:(CGFloat)framerate;
-(void)stopAnimating;
-(void)checkClickCount:(NSEvent *)theEvent;
-(char const*)keyChar:(unichar)currentkey;
-(void)releaseOpenGLViewSnapshot;
-(void)initDefaults;
-(void)setupRect;
-(void)addTrackingArea;
@end
