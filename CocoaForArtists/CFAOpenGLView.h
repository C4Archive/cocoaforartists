//
//  CFAView.h
//  Cocoa For Artists
//
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
	NSColor *backgroundColor;
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
-(void)frameRate:(int)rate;

-(int)height;
-(int)width;
-(NSSize)size;

-(int)screenWidth;
-(int)screenHeight;
-(NSSize)screenSize;

#pragma mark Background
-(void)drawBackground;
-(void)background:(int)grey;
-(void)background:(int)grey alpha:(int)alpha;
-(void)backgroundRed:(int)red green:(int)green blue:(int)blue;
-(void)backgroundRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha;
-(void)backgroundImage:(CFAImage*)bgImage;

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

@property(readwrite,retain) NSColor *backgroundColor;
@property(readwrite,retain) NSString *exportDir;
@property(readwrite,retain) NSString *exportFileName;
@property(readwrite,retain) NSString *exportFileType;
@end
