//
//  CFAOpenGLView.m
//  Created by Travis Kirton.
//

#import "CFAOpenGLView.h"

@interface CFAOpenGLView (private)
BOOL readyToDraw = NO;
BOOL backgroundShouldDraw = YES;
BOOL firstFrame = YES;
BOOL flipped = NO;
BOOL firstSave = YES;
BOOL isSetup;
BOOL drawToPDF;

CFURLRef pdfURL;
CGContextRef pdfContext;
CGDataConsumerRef pdfConsumer;

int frameCount = 0;
int frameRate = 60;
int drawstyle = SINGLEFRAME;
int saveFrameCount = 0;

NSRect	backgroundRect;
NSSize	screenSize;
NSTimer *animationTimer;

-(void)prepareOpenGL;
-(void)getPixelData;
-(void)setAnimationTimer:(int)framerate;
-(void)stopAnimating;
-(void)checkClickCount:(NSEvent *)theEvent;
-(char const*)keyChar:(unichar)currentkey;
-(void)releaseOpenGLViewSnapshot;
-(void)initDefaults;
-(void)setupRect;
-(void)addTrackingArea;

@end

@implementation CFAOpenGLView

@synthesize backgroundColor, exportDir, exportFileName, exportFileType;

+(void)load {
	if(VERBOSELOAD) printf("CFAOpenGLView\n");
}

-(void)awakeFromNib {
	backgroundRect = NSZeroRect;
	screenSize = NSZeroSize;
	mousePressed = NO;
	isClean = YES;
	[self background:255];
	[self setCanDrawConcurrently:YES];
	[self prepareOpenGL];
	[self setupRect];
	[self addTrackingArea];
}

-(void)dealloc {
	if (drawToPDF) {
		[self endPDF];
	}
	[super dealloc];
}

#pragma mark Structure
-(void)setupRect{
	[self setup];
	[self redraw];
	isSetup = YES;
}
	 
-(void)setup {
}

-(void)drawRect:(NSRect)dirtyRect {
	if(readyToDraw) {
		if(isSetup){
			if (backgroundShouldDraw == YES) {
				[self drawBackground];
				backgroundShouldDraw = NO;
			}
			[self draw];
			frameCount++;
		} else {
			[self setupRect];
		}
	} else {
		[self prepareOpenGL];
	}
}

-(void)drawStyle:(int)style {
	drawstyle = style;
	switch (drawstyle) {
		case ANIMATED:
			[self setAnimationTimer:frameRate];
			break;
		default:
			[self stopAnimating];
			break;
	}
}

-(void)frameRate:(int)rate {
	frameRate = rate;
	[self setAnimationTimer:frameRate];
}

-(void)setAnimationTimer:(int)framerate {
	if (animationTimer != nil) [self stopAnimating];
	animationTimer = [NSTimer timerWithTimeInterval:(1.0f/(float)framerate)
											 target:self
										   selector:@selector(redraw)
										   userInfo:nil
											repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:animationTimer forMode:NSDefaultRunLoopMode];
}

-(void)stopAnimating {
	[animationTimer invalidate];
	animationTimer = nil;
}

-(void)draw {
}

-(void)redraw {
	if(readyToDraw == YES){
		[self setNeedsDisplay:YES];
	}
}

- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (BOOL)becomeFirstResponder
{
	return  YES;
}

- (BOOL)resignFirstResponder
{
	return YES;
}

-(void)windowWidth:(int)width andHeight:(int)height {
	screenSize = [[NSScreen mainScreen] frame].size;
	NSRect contentRect = [NSWindow contentRectForFrameRect:NSMakeRect(0, 0, width, height) 
													  styleMask:NSTitledWindowMask];
	float titleBarHeight = height - contentRect.size.height;
	[self.window setFrame:NSMakeRect(0, screenSize.height, width, height+titleBarHeight) display:YES];
}

-(void)addTrackingArea {
	[self addTrackingArea:[[NSTrackingArea alloc] initWithRect:self.visibleRect options:(NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow ) owner:self userInfo:nil]];
	backgroundRect = NSMakeRect(self.visibleRect.origin.x-5, self.visibleRect.origin.y-5, self.visibleRect.size.width+10, self.visibleRect.size.height+10);
}

-(void)flipCoordinates {
	flipped = YES;
	//[CFAShape flipCoordinates];
}

-(void)nativeCoordinates {
	flipped = NO;
	//[CFAShape nativeCoordinates];
}

-(BOOL)isFlipped {
	return flipped;
}

#pragma mark Environment
-(void)cursor {
	[NSCursor unhide];
}

-(void)noCursor {
	[NSCursor hide];
}

-(int)frameCount {
	return frameCount;
}

-(int)frameRate {
	return frameRate;
}

-(int)screenHeight {
	return screenSize.height;
}

-(int)screenWidth {
	return screenSize.width;
}

-(NSSize)screenSize {
	return screenSize;
}

-(int)width {
	return self.size.width;
}

-(int)height {
	return self.size.height;
}

-(NSSize)size {
	return self.visibleRect.size;
}

#pragma mark Background 
-(void)background:(float)grey {
	[self backgroundRed:grey green:grey blue:grey alpha:1.0f];
}

-(void)background:(float)grey alpha:(float)alpha {
	[self backgroundRed:grey green:grey blue:grey alpha:alpha];
}

-(void)backgroundRed:(float)red green:(float)green blue:(float)blue {
	[self backgroundRed:red green:green blue:blue alpha:1.0f];
}

-(void)backgroundRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha{
	[self setBackgroundColor:[CFAColor colorWithRed:red green:green blue:blue alpha:alpha]];
	backgroundShouldDraw = YES;
}

-(void)backgroundImage:(CFAImage*)bgImage {
	[bgImage drawAt:NSZeroPoint withWidth:self.width andHeight:self.height];
}

-(void)drawBackground {
	[[self backgroundColor] set];
	[NSBezierPath fillRect:backgroundRect];
	if(drawToPDF){
		CGFloat components[4];
		[[[self backgroundColor] nsColor] getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
		CGContextSetRGBFillColor(pdfContext,components[0],components[1],components[2],components[3]);
		CGContextFillRect(pdfContext, NSRectToCGRect(backgroundRect));
	}
}

#pragma mark Input
-(void)keyPressed {
}

-(void)keyReleased {
}

-(void)keyDown:(NSEvent *)theEvent {
	keyCode = [theEvent keyCode];
	keyChar = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
	keyPressed = YES;
	if(drawstyle == EVENTBASED) [self redraw];
	[self keyPressed];
}

-(void)keyUp:(NSEvent *)theEvent {
	keyPressed = NO;
	if(drawstyle == EVENTBASED) [self redraw];
	[self keyReleased];
}

-(void)mouseMoved:(NSEvent *)theEvent {
	prevMousePos = mousePos;
	mousePos = [theEvent locationInWindow];
	if([self isFlipped]) {
		mousePos.y *= -1;
		mousePos.y += self.visibleRect.size.height;
	}
	if (drawstyle == EVENTBASED) [self redraw];
	[self mouseMoved];
}

-(void)mouseDragged:(NSEvent *)theEvent {
	prevMousePos = mousePos;
	mousePos = [theEvent locationInWindow];
	if([self isFlipped]) {
		mousePos.y *= -1;
		mousePos.y += self.visibleRect.size.height;
	}
	if(drawstyle == EVENTBASED) [self redraw];
	[self mouseDragged];
}


-(void)mousePressed {
}

-(void)mouseReleased {
}

-(void)mouseDragged {
}

-(void)mouseClicked {
}

-(void)mouseDoubleClicked {
}

-(void)mouseMoved{
}

-(void)mouseDown:(NSEvent *)theEvent {
	currentMouseButton = MOUSELEFT;
	mousePressed = YES;
	if(drawstyle == EVENTBASED) [self redraw];
	[self mousePressed];
}

-(void)mouseUp:(NSEvent *)theEvent {
	[self checkClickCount:theEvent];
	currentMouseButton = NOMOUSE;
	mousePressed = NO;
	if(drawstyle == EVENTBASED) [self redraw];
	[self mouseReleased];
}

-(void)rightMouseDown:(NSEvent *)theEvent {
	currentMouseButton = MOUSERIGHT;
	mousePressed = YES;
	if(drawstyle == EVENTBASED) [self redraw];
	[self mousePressed];
}

-(void)rightMouseUp:(NSEvent *)theEvent {
	[self checkClickCount:theEvent];
	currentMouseButton = NOMOUSE;
	mousePressed = NO;
	if(drawstyle == EVENTBASED) [self redraw];
	[self mouseReleased];
}

-(void)otherMouseDown:(NSEvent *)theEvent {
	currentMouseButton = ([theEvent buttonNumber] == 2) ? MOUSECENTER : (int)[theEvent buttonNumber];
	mousePressed = YES;
	if(drawstyle == EVENTBASED) [self redraw];
	[self mousePressed];
}

-(void)otherMouseUp:(NSEvent *)theEvent {
	[self checkClickCount:theEvent];
	currentMouseButton = NOMOUSE;
	mousePressed = NO;
	if(drawstyle == EVENTBASED) [self redraw];
	[self mouseReleased];
}

-(void)checkClickCount:(NSEvent*)theEvent {
	if ([theEvent clickCount] == 2) {
		[self mouseDoubleClicked];
	} else if ([theEvent clickCount] == 1) {
		[self mouseClicked];
	}
}

#pragma mark Output

-(void)setupPDF {
	drawToPDF = YES;
	isClean = NO;

	NSString *path = nil;
	NSArray	*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
	if([paths count]) {
		NSString *appName = [[NSFileManager defaultManager] displayNameAtPath:[[NSBundle mainBundle] bundlePath]];
		
		path = [paths objectAtIndex:0];
		path = [path stringByAppendingPathComponent:appName];
		
		BOOL isDir;
		NSFileManager *defaultManager = [NSFileManager defaultManager];
		[defaultManager fileExistsAtPath:path isDirectory:&isDir];
		if (!isDir) {
			[defaultManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
		}
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMddYY(hhmmss)"];

		NSString *fileName = [NSString stringWithFormat:@"%@-%@.pdf",appName,[format stringFromDate:[NSDate date]]];
		pdfURL = (CFURLRef)[NSURL fileURLWithPath:[path stringByAppendingPathComponent:fileName]];
		CFRetain(pdfURL);
		NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
		pdfConsumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)data);
		CGDataConsumerRetain(pdfConsumer);
		CGRect bounds = CGRectMake(0, 0, self.width, self.height);
		pdfContext = CGPDFContextCreateWithURL(pdfURL, &bounds, NULL);
		CGContextRetain(pdfContext);
		CGContextBeginPage(pdfContext, &bounds);
		CGContextSetFillColorSpace(pdfContext,CGColorSpaceCreateDeviceRGB());
		[CFAShape beginDrawShapesToPDFContext:pdfContext];
		[CFAString beginDrawStringsToPDFContext:pdfContext];
	}
}

-(void)endPDF {
	drawToPDF = NO;
	[CFAShape endDrawShapesToPDFContext];
	[CFAString endDrawStringsToPDFContext];
	CGContextEndPage(pdfContext);
	CGPDFContextClose(pdfContext);
	CGDataConsumerRelease(pdfConsumer);
	CFRelease(pdfURL);
	isClean = YES;
}

#pragma mark OPENGL
-(void)prepareOpenGL {
	GLint opacity = 0;
	[[self openGLContext] setValues:&opacity forParameter:NSOpenGLCPSurfaceOpacity];	
	readyToDraw = YES;
	glEnable( GL_DEPTH_TEST );
	[self redraw];
}

@end
