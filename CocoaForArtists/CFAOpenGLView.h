//
//  CFAOpenGLView.h
//  Created by Travis Kirton.
//

#import <Cocoa/Cocoa.h>

@interface CFAOpenGLView : NSOpenGLView {
	BOOL keyPressed;
	unichar keyChar;
	int	 keyCode;
	BOOL mousePressed;
	int currentMouseButton;
	NSPoint mousePos;
	NSPoint prevMousePos;
	
@private
	BOOL isClean;
	CFAColor *backgroundColor;
	NSString *exportDir, *exportFileName, *exportFileType;
}

#pragma mark Structure
-(void)setup;
-(void)draw;
-(void)redraw;
-(void)windowWidth:(int)width andHeight:(int)height;
-(void)flipCoordinates;
-(void)nativeCoordinates;
-(void)drawStyle:(int)style;

#pragma mark Environment
-(void)cursor;
-(void)noCursor;
-(int)frameCount;
-(int)frameRate;
-(void)frameRate:(CGFloat)rate;

-(int)height;
-(int)width;
-(NSSize)size;

-(int)screenWidth;
-(int)screenHeight;
-(NSSize)screenSize;

#pragma mark Background
-(void)drawBackground;
-(void)background:(float)grey;
-(void)background:(float)grey alpha:(float)alpha;
-(void)backgroundRed:(float)red green:(float)green blue:(float)blue;
-(void)backgroundRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
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

@property(readwrite,retain) CFAColor *backgroundColor;
@property(readwrite,retain) NSString *exportDir;
@property(readwrite,retain) NSString *exportFileName;
@property(readwrite,retain) NSString *exportFileType;
@end
