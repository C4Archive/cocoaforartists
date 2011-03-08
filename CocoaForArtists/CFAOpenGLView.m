//
//  CFAOpenGLView.m
//  Created by Travis Kirton.
//

#import "CFAOpenGLView.h"

static CFAOpenGLView *cfaOpenGLView;
@implementation CFAOpenGLView
GENERATE_SINGLETON(CFAOpenGLView, cfaOpenGLView);

@synthesize backgroundColor, exportDir, exportFileName, exportFileType;
@synthesize keyIsPressed, mouseIsPressed;
@synthesize keyChar, keyCode, mouseButton, frameCount, frameRate;
@synthesize mousePos, prevMousePos;
@synthesize canvasSize, screenSize;
@synthesize canvasRect;
@synthesize canvasWidth, canvasHeight, screenWidth, screenHeight, currentDrawStyle;

+(void)load {
	if(VERBOSELOAD) printf("CFAOpenGLView\n");
}

-(id)_init {
	return self;
}

-(void)awakeFromNib {
	readyToDraw = NO;
	backgroundShouldDraw = YES;
	flipped = NO;
	isSetup = NO;
	drawToPDF = NO;
	
	frameCount = 0;
	frameRate = 60.0f;
	currentDrawStyle = SINGLEFRAME;
	
	backgroundRect = NSZeroRect;
	mouseIsPressed = NO;
	isClean = YES;
	screenSize = [[NSScreen mainScreen] frame].size;
	screenWidth = screenSize.width;
	screenHeight = screenSize.height;
	[self setCanDrawConcurrently:YES];
	[self prepareOpenGL];
	[self windowWidth:100 andHeight:100];
	fullScreenOptions = [[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]  
													 forKey:NSFullScreenModeAllScreens] retain];
}

#pragma mark Structure
-(void)setupRect{
	[self setup];
	[self addTrackingArea];
	isSetup = YES;
	[self redraw];
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
		}
	} else {
		[self prepareOpenGL];
	}
}

-(void)drawStyle:(int)style {
	currentDrawStyle = style;
	switch (currentDrawStyle) {
		case ANIMATED:
			[self setAnimationTimer:frameRate];
			break;
		default:
			[self stopAnimating];
			break;
	}
}

-(void)setFrameRate:(CGFloat)rate {
	frameRate = rate;
	if (frameRate <= 0.0f) {
		frameRate = 0.001;
	}
	[self setAnimationTimer:frameRate];
}

-(void)setAnimationTimer:(CGFloat)framerate {
	if (animationTimer != nil) [self stopAnimating];
	animationTimer = [NSTimer timerWithTimeInterval:(1.0f/framerate)
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
	canvasSize = NSMakeSize(width, height);
	canvasWidth = canvasSize.width;
	canvasHeight = canvasSize.height;
	canvasRect.size = canvasSize;
	canvasRect.origin = NSZeroPoint;
	NSRect contentRect = [NSWindow contentRectForFrameRect:canvasRect 
													  styleMask:NSTitledWindowMask];
	float titleBarHeight = height - contentRect.size.height;
	// this centers the window to the screen when it first runs
	[self.window setFrame:NSMakeRect((screenWidth-canvasWidth)/2, (screenHeight-titleBarHeight-canvasHeight) / 2 , canvasWidth, canvasHeight+titleBarHeight) display:YES];
}

-(void)addTrackingArea {
	[self addTrackingArea:[[NSTrackingArea alloc] initWithRect:self.visibleRect options:(NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow ) owner:self userInfo:nil]];
	backgroundRect = NSMakeRect(self.visibleRect.origin.x-1, self.visibleRect.origin.y-1, self.visibleRect.size.width+2, self.visibleRect.size.height+2);
}

-(void)flipCoordinates {
	flipped = YES;
}

-(void)nativeCoordinates {
	flipped = NO;
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

+(CGFloat)getScreenWidth {
	return [self sharedManager].screenWidth;
}
+(CGFloat)getScreenHeight {
	return [self sharedManager].screenHeight;
}
+(CGFloat)getCanvasWidth {
	return [self sharedManager].canvasWidth;
}
+(CGFloat)getCanvasHeight {
	return [self sharedManager].canvasHeight;
}
+(NSRect)getCanvasRect {
	return [self sharedManager].canvasRect;
}
+(NSPoint)getMousePos {
	return [self sharedManager].mousePos;
}

+(NSUInteger)getMouseButton {
	return [self sharedManager].mouseButton;
}

-(void)enterFullScreen {
	[[NSNotificationCenter defaultCenter] postNotificationName:FULLSCREEN object:self];
	[self enterFullScreenMode:[NSScreen mainScreen] withOptions:fullScreenOptions];
	[self removeTrackingArea:[[self trackingAreas] objectAtIndex:0]];
	[self addTrackingArea];
	canvasSize = screenSize;
	canvasHeight = canvasSize.height;
	canvasWidth = canvasSize.width;
}

-(void)exitFullScreen {
	[[NSNotificationCenter defaultCenter] postNotificationName:FULLSCREEN object:self];
	[self exitFullScreenModeWithOptions:fullScreenOptions];
	[self removeTrackingArea:[[self trackingAreas] objectAtIndex:0]];
	[self addTrackingArea];
	canvasSize = self.visibleRect.size;
	canvasHeight = canvasSize.height;
	canvasWidth = canvasSize.width;
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

-(void)backgroundColor:(id)color {
	if([color isKindOfClass:[CFAColor class]]) {
		[self setBackgroundColor:(CFAColor*)color];
	}
	else if([color isKindOfClass:[NSColor class]]) {
		[self setBackgroundColor:[CFAColor colorWithNSColor:(NSColor *)color]];
	}
	backgroundShouldDraw = YES;
}

-(void)backgroundImage:(CFAImage*)bgImage {
	[bgImage drawAt:NSZeroPoint withWidth:canvasWidth andHeight:canvasHeight];
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
	keyIsPressed = YES;
	if(currentDrawStyle == EVENTBASED) [self redraw];
	[self keyPressed];
}

-(void)keyUp:(NSEvent *)theEvent {
	keyIsPressed = NO;
	if(currentDrawStyle == EVENTBASED) [self redraw];
	[self keyReleased];
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

-(void)mouseMoved:(NSEvent *)theEvent {
	//[[NSNotificationCenter defaultCenter] postNotificationName:MOUSEMOVED object:self];
	prevMousePos = mousePos;
	mousePos = [theEvent locationInWindow];
	if([self isFlipped]) {
		mousePos.y *= -1;
		mousePos.y += self.visibleRect.size.height;
	}
	if (currentDrawStyle == EVENTBASED) [self redraw];
	[self mouseMoved];
}

-(void)mouseDown:(NSEvent *)theEvent {
	[[NSNotificationCenter defaultCenter] postNotificationName:MOUSEPRESSED object:self];
	mouseButton = MOUSELEFT;
	mouseIsPressed = YES;
	if(currentDrawStyle == EVENTBASED) [self redraw];
	[self mousePressed];
}

-(void)mouseDragged:(NSEvent *)theEvent {
	[[NSNotificationCenter defaultCenter] postNotificationName:MOUSEDRAGGED object:self];
	prevMousePos = mousePos;
	mousePos = [theEvent locationInWindow];
	if([self isFlipped]) {
		mousePos.y *= -1;
		mousePos.y += self.visibleRect.size.height;
	}
	if(currentDrawStyle == EVENTBASED) [self redraw];
	[self mouseDragged];
}

-(void)mouseUp:(NSEvent *)theEvent {
	[[NSNotificationCenter defaultCenter] postNotificationName:MOUSERELEASED object:self];
	[self checkClickCount:theEvent];
	mouseButton = NOMOUSE;
	mouseIsPressed = NO;
	if(currentDrawStyle == EVENTBASED) [self redraw];
	[self mouseReleased];
}

-(void)rightMouseDown:(NSEvent *)theEvent {
	mouseButton = MOUSERIGHT;
	mouseIsPressed = YES;
	if(currentDrawStyle == EVENTBASED) [self redraw];
	[self mousePressed];
}

-(void)rightMouseUp:(NSEvent *)theEvent {
	[self checkClickCount:theEvent];
	mouseButton = NOMOUSE;
	mouseIsPressed = NO;
	if(currentDrawStyle == EVENTBASED) [self redraw];
	[self mouseReleased];
}

-(void)otherMouseDown:(NSEvent *)theEvent {
	//[[NSNotificationCenter defaultCenter] postNotificationName: object:self];
	mouseButton = ([theEvent buttonNumber] == 2) ? MOUSECENTER : (int)[theEvent buttonNumber];
	mouseIsPressed = YES;
	if(currentDrawStyle == EVENTBASED) [self redraw];
	[self mousePressed];
}

-(void)otherMouseUp:(NSEvent *)theEvent {
	//[[NSNotificationCenter defaultCenter] postNotificationName: object:self];
	[self checkClickCount:theEvent];
	mouseButton = NOMOUSE;
	mouseIsPressed = NO;
	if(currentDrawStyle == EVENTBASED) [self redraw];
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
		CGRect bounds = CGRectMake(0, 0, canvasWidth, canvasHeight);
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
}

@end
