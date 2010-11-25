//
//  CFAShape.m
//  CocoaForArtists
//
//  Created by Travis Kirton on 10-09-12.
//  Copyright 2010 Travis Kirton. All rights reserved.
//

#import "CFAShape.h"

static CFAShape *cfaShape;

@interface CFAShape (private)
BOOL useFill = YES;
BOOL useStroke = YES;
BOOL checkShape = NO;
BOOL firstPoint	= YES;
BOOL drawToPDF = NO;
BOOL isClean;

CGContextRef pdfContext;

int rectMode = CORNER;
int ellipseMode = CENTER;

float strokeWidth = 0.1f;

NSColor *fillColor;
NSColor *strokeColor;
NSBezierPath *vertexPath;
CGFloat fillColorComponents[4];
CGFloat strokeColorComponents[4];

CGMutablePathRef currentShape;

+(void)fillColorSet;
+(void)strokeColorSet;
+(void)cgFillColorSet;
+(void)cgStrokeColorSet;
@end

@implementation CFAShape
GENERATE_SINGLETON(CFAShape, cfaShape);

+(void)load {
	if(VERBOSELOAD) printf("CFAShape\n");
	strokeWidth = 1.0f;
	fillColor = [NSColor whiteColor];
	strokeColor = [NSColor blackColor];
	ellipseMode = CENTER;
	rectMode = CORNER;
}

-(id)_init {
	return self;
}

#pragma mark Shapes
+(void)arcWithCenterAt:(NSPoint)p radius:(float)r startAngle:(float)startAngle endAngle:(float)endAngle {
	if(useFill == YES) {
		NSBezierPath *arcPath = [NSBezierPath bezierPath];
		[arcPath appendBezierPathWithArcWithCenter:p radius:r startAngle:startAngle endAngle:endAngle];
		[arcPath lineToPoint:p];
		[arcPath closePath];
		[self fillColorSet];
		[arcPath fill];
		if (drawToPDF) {
			[self cgFillColorSet];
			CGContextBeginPath(pdfContext);
			CGContextAddArc(pdfContext, p.x, p.y, r, DEGREES_TO_RADIANS(startAngle),DEGREES_TO_RADIANS(endAngle), 0);
			CGContextAddLineToPoint(pdfContext,p.x,p.y);
			CGContextFillPath(pdfContext);
		}
	}
	
	if (useStroke == YES) {
		NSBezierPath *arcPath = [NSBezierPath bezierPath];
		[arcPath appendBezierPathWithArcWithCenter:p radius:r startAngle:startAngle endAngle:endAngle];
		[self strokeColorSet];
		[arcPath setLineWidth:strokeWidth];
		[arcPath stroke];
		if (drawToPDF) {
			[self cgStrokeColorSet];
			CGContextBeginPath(pdfContext);
			CGContextAddArc(pdfContext, p.x, p.y, r, startAngle, endAngle, 0);
			CGContextClosePath(pdfContext);
			CGContextStrokePath(pdfContext);
		}
	}
	
	if (drawToPDF) {
		CFALog(@"Should draw - arc");
	}
}

+(void)curveFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 controlPoint1:(NSPoint)c1 controlPoint2:(NSPoint)c2 {
	if (useStroke == YES) {
		NSBezierPath *curvePath = [NSBezierPath bezierPath];
		[curvePath moveToPoint:p1];
		[curvePath curveToPoint:p2 controlPoint1:c1 controlPoint2:c2];
		[self strokeColorSet];
		[curvePath setLineWidth:strokeWidth];
		[curvePath stroke];
		if (drawToPDF) {
			[self cgStrokeColorSet];
			CGContextBeginPath(pdfContext);
			CGContextMoveToPoint(pdfContext, p1.x, p1.y);
			CGContextAddCurveToPoint(pdfContext, c1.x, c1.y, c2.x, c2.y, p2.x, p2.y);
			CGContextStrokePath(pdfContext);
		}
	}
	if (drawToPDF) {
		CFALog(@"Should draw - curve");
	}
}

+(void)curveFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2 controlPoint1X:(int)cx1 Y:(int)cy1 controlPoint2X:(int)cx2 Y:(int)cy2 {
	[self curveFromPoint:NSMakePoint(x1, y1) 
				 toPoint:NSMakePoint(x2, y2) 
		   controlPoint1:NSMakePoint(cx1, cy1)
		   controlPoint2:NSMakePoint(cx2, cy2)];
}

+(void)circleAt:(NSPoint)p radius:(int)r {
	[self ellipseAt:p size:NSMakeSize(r*2, r*2)];
}

+(void)ellipseAt:(NSPoint)p	size:(NSSize)s {
	NSRect circleRect = NSZeroRect;
	circleRect.origin = p;
	circleRect.size = s;
	if (ellipseMode == CENTER) {
		circleRect.origin.x -= circleRect.size.width/2;
		circleRect.origin.y -= circleRect.size.height/2;
	}
	NSBezierPath *ellipse = [NSBezierPath bezierPathWithOvalInRect:circleRect];
	
	if(useFill == YES) {
		[self fillColorSet];
		[ellipse fill];
		if (drawToPDF) {
			[self cgFillColorSet];
			CGContextFillEllipseInRect(pdfContext, NSRectToCGRect(circleRect));
		}
	}
	
	if(useStroke == YES) {
		[ellipse setLineWidth:strokeWidth];
		[self strokeColorSet];
		[ellipse stroke];
		if (drawToPDF) {
			[self cgStrokeColorSet];
			CGContextStrokeEllipseInRect(pdfContext, NSRectToCGRect(circleRect));
		}
	}
}

+(void)ellipseWithXPos:(int)x yPos:(int)y width:(int)w andHeight:(int)h {
	[self ellipseAt:NSMakePoint(x,y) size:NSMakeSize(w, h)];
}

+(void)lineFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2 {
	[self lineFromPoint:NSMakePoint(x1, y1) toPoint:NSMakePoint(x2, y2)];
}

+(void)lineFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 {
	if(useStroke == YES) {
		NSBezierPath *linePath = [NSBezierPath bezierPath];
		[linePath moveToPoint:p1];
		[linePath lineToPoint:p2];
		[self strokeColorSet];
		[linePath setLineWidth:strokeWidth];
		[linePath stroke];
	
	if (drawToPDF) {
		[self cgStrokeColorSet];
		CGContextSetLineCap(pdfContext,kCGLineCapRound);
		CGContextBeginPath(pdfContext);
		CGContextMoveToPoint(pdfContext, p1.x, p1.y);
		CGContextAddLineToPoint(pdfContext, p2.x, p2.y);
		CGContextClosePath(pdfContext);
		CGContextStrokePath(pdfContext);
	}
		}
}

+(void)pointAtX:(int)x1 Y:(int)y1 {
	[self pointAt:NSMakePoint(x1, y1)];
}

+(void)pointAt:(NSPoint)p {
	BOOL strk = useStroke;
	[self noStroke];
	BOOL fll = useFill;
	[self fill];
	[self rectWithXPos:p.x yPos:p.y width:1 andHeight:1];
	if (strk) [self stroke]; //set stroke on if it was on before
	if (!fll) [self noFill]; //set fill off if it was off before
}

+(void)rectWithXPos:(int)x yPos:(int)y width:(float)w andHeight:(float)h {
/*
	if (w < 1) {
		NSLog(@"Value for width (%f) invalid, width must be >= 1",w);
		return;
	}
	if (h < 1) {
		NSLog(@"Value for height (%f) invalid, width must be >= 1",h);
		return;
	}
*/
	NSRect rect = NSMakeRect(x, y, [CFAMath ceil:w], [CFAMath ceil:h]);
	if (rectMode == CENTER) {
		rect.origin.x -= w/2;
		rect.origin.y -= h/2;
	}
	
	NSBezierPath *rectPath = [NSBezierPath bezierPathWithRect:rect];

	if (useFill == YES) {
		[self fillColorSet];
		[rectPath fill];
		if (drawToPDF) {
			[self cgFillColorSet];
			CGContextFillRect(pdfContext, NSRectToCGRect(rect));
		}
	}
	if (useStroke == YES) {
		[self strokeColorSet];
		[rectPath setLineWidth:strokeWidth];
		[rectPath stroke];
		if (drawToPDF) {
			[self cgStrokeColorSet];
			CGContextStrokeRect(pdfContext, CGRectMake(x, y, w, h));
		}
	}
}

+(void)triangleFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2 toX:(int)x3 Y:(int)y3 {
	[self triangleUsingPoint:NSMakePoint(x1, y1) point:NSMakePoint(x2, y2) point:NSMakePoint(x3, y3)];
}

+(void)triangleUsingPoint:(NSPoint)p1 point:(NSPoint)p2 point:(NSPoint)p3 {
	NSBezierPath *trianglePath = [NSBezierPath bezierPath];
	[trianglePath moveToPoint:p1];
	[trianglePath lineToPoint:p2];
	[trianglePath lineToPoint:p3];
	[trianglePath lineToPoint:p1];
	
	if (useFill == YES) {
		[self fillColorSet];
		[trianglePath fill];
		if(drawToPDF) {
			[self cgFillColorSet];
			CGContextBeginPath(pdfContext);
			CGContextMoveToPoint(pdfContext, p1.x, p1.y);
			CGContextAddLineToPoint(pdfContext, p2.x, p2.y);
			CGContextAddLineToPoint(pdfContext, p3.x, p3.y);
			CGContextClosePath(pdfContext);
			CGContextFillPath(pdfContext);
		}
	}
	if(useStroke == YES){
		[self strokeColorSet];
		[trianglePath setLineWidth:strokeWidth];
		[trianglePath stroke];
		if (drawToPDF) {
			[self cgStrokeColorSet];
			
			CGContextBeginPath(pdfContext);
			CGContextMoveToPoint(pdfContext, p1.x, p1.y);
			CGContextAddLineToPoint(pdfContext, p2.x, p2.y);
			CGContextAddLineToPoint(pdfContext, p3.x, p3.y);
			CGContextAddLineToPoint(pdfContext, p1.x, p1.y);
			CGContextClosePath(pdfContext);
			CGContextStrokePath(pdfContext);
		}
	}
}

+(void)quadUsingPoint:(NSPoint)p1 point:(NSPoint)p2 point:(NSPoint)p3 point:(NSPoint)p4 {
	NSBezierPath *quadPath = [NSBezierPath bezierPath];
	[quadPath moveToPoint:p1];
	[quadPath lineToPoint:p2];
	[quadPath lineToPoint:p3];
	[quadPath lineToPoint:p4];
	[quadPath lineToPoint:p1];
	
	if(useFill == YES) {
		[self fillColorSet];
		[quadPath fill];
		if(drawToPDF) {
			[self cgFillColorSet];
			CGContextBeginPath(pdfContext);
			CGContextMoveToPoint(pdfContext, p1.x, p1.y);
			CGContextAddLineToPoint(pdfContext, p2.x, p2.y);
			CGContextAddLineToPoint(pdfContext, p3.x, p3.y);
			CGContextAddLineToPoint(pdfContext, p4.x, p4.y);
			CGContextClosePath(pdfContext);
			CGContextFillPath(pdfContext);
		}
	}
	if(useStroke == YES){ 
		[self strokeColorSet];
		[quadPath setLineWidth:strokeWidth];
		[quadPath stroke];
		if (drawToPDF) {
			[self cgStrokeColorSet];
			CGContextBeginPath(pdfContext);
			CGContextMoveToPoint(pdfContext, p1.x, p1.y);
			CGContextAddLineToPoint(pdfContext, p2.x, p2.y);
			CGContextAddLineToPoint(pdfContext, p3.x, p3.y);
			CGContextAddLineToPoint(pdfContext, p4.x, p4.y);
			CGContextAddLineToPoint(pdfContext, p1.x, p1.y);
			CGContextClosePath(pdfContext);
			CGContextStrokePath(pdfContext);
		}
	}
}

+(void)quadFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2 toX:(int)x3 Y:(int)y3 toX:(int)x4 Y:(int)y4 {	
	[self quadUsingPoint:NSMakePoint(x1, y1) point:NSMakePoint(x2, y2) point:NSMakePoint(x3, y3) point:NSMakePoint(x4, y4)];
}

#pragma mark Vertex Shapes
+(void)beginShape {
	if (checkShape) {
		[NSException raise:@"[CFAShape beginShape] Exception" format:@"[CFAShape beginShape] already called, you must call [CFAShape endShape] before beginning another shape."];
	}
	checkShape = YES;
	firstPoint = YES;
	vertexPath = [NSBezierPath bezierPath];
	if (drawToPDF) {
		CGContextBeginPath(pdfContext);
	}
}

+(void)endShape {
	if (!checkShape) {
		[NSException raise:@"[CFAShape endShape] Exception" format:@"[CFAShape endShape] already called, you must call [CFAShape beginShape] to start a new shape."];
	} else if ([vertexPath elementCount] < 2){
		[NSException raise:@"[CFAShape endShape] Exception" format:@"The current shape has %d points, but needs at least 2 points.", [vertexPath elementCount]];
	}
	checkShape = NO;
	
	if(useFill == YES) {
		[self fillColorSet];
		[vertexPath fill];
		if (drawToPDF) {
			[self cgFillColorSet];
			CGContextFillPath(pdfContext);
		}
	}
	if(useStroke == YES){ 
		[self strokeColorSet];
		[vertexPath setLineWidth:strokeWidth];
		[vertexPath stroke];
		if(drawToPDF) {
			[self cgStrokeColorSet];
			CGContextStrokePath(pdfContext);
		}
	}
}

+(void)closeShape {
	if (!checkShape) {
		[NSException raise:@"[CFAShape endShape] Exception" format:@"[CFAShape endShape] already called, you must call [CFAShape beginShape] to start a new shape."];
	} else if ([vertexPath elementCount] < 2){
		[NSException raise:@"[CFAShape closeShape] Exception" format:@"The current shape has %d points, but needs at least 2 points.", [vertexPath elementCount]];
	}
	[vertexPath closePath];
	CGContextClosePath(pdfContext);
}

+(void)vertexAtX:(int)x Y:(int)y {
	[self vertexAt:NSMakePoint(x, y)];
}

+(void)vertexAt:(NSPoint)point {
	if (!checkShape) {
		[NSException raise:@"[CFAShape vertexAt:] Exception" format:@"You must call [CFAShape beginShape] before adding vertices."];
	}
	if (firstPoint) {
		[vertexPath moveToPoint:point];
		if (drawToPDF) {
			CGContextMoveToPoint(pdfContext, point.x, point.y);
		}
		firstPoint = NO;
	} else {
		[vertexPath lineToPoint:point];
		if (drawToPDF) {
			CGContextAddLineToPoint(pdfContext, point.x, point.y);
		}
	}
}

#pragma mark Current Shape
+(void)clearCurrentShape {
	if(currentShape != nil){
		CFRelease(currentShape);
		currentShape = nil;
	}
	currentShape = CGPathCreateMutable();
}

+(CGMutablePathRef)currentShape {
	return currentShape;
}
+(void)addArcWithCenterAt:(NSPoint)p radius:(float)r startAngle:(float)startAngle endAngle:(float)endAngle {
	CGPathAddArc(currentShape, NULL, p.x, p.y, r, DEGREES_TO_RADIANS(startAngle),DEGREES_TO_RADIANS(endAngle), 0);
}

+(void)addCircleAt:(NSPoint)p radius:(int)r{
	CGRect circleRect;
	circleRect.origin = (CGPoint)p;
	circleRect.size = CGSizeMake(r*2, r*2);
	if (ellipseMode == CENTER) {
		circleRect.origin.x -= r;
		circleRect.origin.y -= r;
	}
	CGPathAddEllipseInRect(currentShape, NULL, circleRect);
}

+(void)addCurveFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 controlPoint1:(NSPoint)c1 controlPoint2:(NSPoint)c2 {
	[self addCurveFromX:p1.x Y:p1.y toX:p2.x Y:p2.y controlPoint1X:c1.x Y:c1.y controlPoint2X:c2.x Y:c2.y];
}

+(void)addCurveFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2 controlPoint1X:(int)cx1 Y:(int)cy1 controlPoint2X:(int)cx2 Y:(int)cy2{
	CGMutablePathRef curvePath = CGPathCreateMutable();
	CGPathMoveToPoint(curvePath, NULL, x1, y1);
	CGPathAddCurveToPoint(curvePath, NULL, cx1, cy1, cx2, cy2, x2, y2);
	CGPathAddPath(currentShape, NULL, curvePath);
}

+(void)addEllipseAt:(NSPoint)p size:(NSSize)s {
	CGRect ellipseRect;
	ellipseRect.origin = (CGPoint)p;
	ellipseRect.size = s;
	if (ellipseMode == CENTER) {
		ellipseRect.origin.x -= ellipseRect.size.width/2;
		ellipseRect.origin.y -= ellipseRect.size.height/2;
	}
	CGPathAddEllipseInRect(currentShape, NULL, ellipseRect);
}

+(void)addEllipseWithXPos:(int)x yPos:(int)y width:(int)w andHeight:(int)h {
	[self addEllipseAt:NSMakePoint(x, y) size:NSMakeSize(w, h)];
}

+(void)addLineFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2{
	CGMutablePathRef linePath = CGPathCreateMutable();
	CGPathMoveToPoint(linePath, NULL, x1, y1);
	CGPathAddLineToPoint(linePath, NULL, x2, y2);
	CGPathAddPath(currentShape, NULL, linePath);
}

+(void)addLineFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2{ 
	[self addLineFromX:p1.x Y:p1.y toX:p2.x Y:p2.y];
}

+(void)addLineTo:(NSPoint)p {
	[self addLineToX:p.x Y:p.y];
}

+(void)addLineToX:(int)x Y:(int)y {
	CGPathAddLineToPoint(currentShape, NULL, x, y);
}

+(void)addPointAt:(NSPoint)p{
	[self addRectWithXPos:p.x yPos:p.y width:1 andHeight:1];
}
+(void)addPointAtX:(int)x1 Y:(int)y1{
	[self addPointAt:NSMakePoint(x1,y1)];
}
+(void)addRectWithXPos:(int)x yPos:(int)y width:(float)w andHeight:(float)h { 
	CGPathAddRect(currentShape,NULL,CGRectMake(x, y, w, h));
}
+(void)addTriangleFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2 toX:(int)x3 Y:(int)y3{
	[self addTriangleUsingPoint:NSMakePoint(x1, y1) point:NSMakePoint(x2, y2) point:NSMakePoint(x3, y3)];
}
+(void)addTriangleUsingPoint:(NSPoint)p1 point:(NSPoint)p2 point:(NSPoint)p3 {
	CGMutablePathRef trianglePath = CGPathCreateMutable();
	CGPathMoveToPoint(trianglePath, NULL, p1.x, p1.y);
	CGPathAddLineToPoint(trianglePath, NULL, p2.x, p2.y);
	CGPathAddLineToPoint(trianglePath, NULL, p3.x, p3.y);
	CGPathAddLineToPoint(trianglePath, NULL, p1.x, p1.y);
	CGPathAddPath(currentShape, NULL, trianglePath);
}
+(void)addQuadUsingPoint:(NSPoint)p1 point:(NSPoint)p2 point:(NSPoint)p3 point:(NSPoint)p4{
	[self addQuadFromX:p1.x Y:p1.y toX:p2.x Y:p2.y toX:p3.x Y:p3.y toX:p4.x Y:p4.y];
}
+(void)addQuadFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2 toX:(int)x3 Y:(int)y3 toX:(int)x4 Y:(int)y4{
	CGMutablePathRef quadPath = CGPathCreateMutable();
	CGPathMoveToPoint(quadPath, NULL, x1, y1);
	CGPathAddLineToPoint(quadPath, NULL, x2, y2);
	CGPathAddLineToPoint(quadPath, NULL, x3, y3);
	CGPathAddLineToPoint(quadPath, NULL, x4, y4);
	CGPathAddLineToPoint(quadPath, NULL, x1, y1);
	CGPathAddPath(currentShape, NULL, quadPath);
}

#pragma mark Attributes
+(void)strokeWidth:(int)width {
	if (strokeWidth > 0) {
		strokeWidth = width;
	} else {
		NSLog(@"stroke width must be greater than 0");
	}
}

+(void)rectMode:(int)mode {
	if (mode == CENTER || mode == CORNER) {
		rectMode = mode;
	} else {
		NSLog(@"rect mode must be CENTER or CORNER");
	}
}

+(void)ellipseMode:(int)mode {
	if (mode == CENTER || mode == CORNER) {
		ellipseMode = mode;
	} else {
		NSLog(@"ellipse mode must be CENTER or CORNER");
	}
}

+(void)strokeCapMode:(int)mode {
	if(mode >= NSButtLineCapStyle && mode <= NSSquareLineCapStyle)
		[NSBezierPath setDefaultLineCapStyle:mode];
	else
		CFALog(@"Stroke Cap Mode must be one of: CAPBUTT, CAPROUND, CAPSQUARE");		
}

+(void)strokeJoinMode:(int)mode {
	if (mode >= NSMiterLineJoinStyle && mode <= NSBevelLineJoinStyle)
		[NSBezierPath setDefaultLineJoinStyle:mode];
	else
		CFALog(@"Stroke Join Mode must be one of: JOINMITRE, JOINROUND, JOINBEVEL");
}

+(void)strokeDetail:(float)level {
	[NSBezierPath setDefaultFlatness:fabsf(level)];
}

#pragma mark Colors
+(void)fillColor:(NSColor *)color {
	fillColor = color;
	[fillColor getRed:&fillColorComponents[0] green:&fillColorComponents[1] blue:&fillColorComponents[2] alpha:&fillColorComponents[3]];
}

+(void)fillColor:(NSColor *)color alpha:(int)alpha{
	fillColor = [color colorWithAlphaComponent:FLOAT_FROM_255(alpha)];
	[fillColor getRed:&fillColorComponents[0] green:&fillColorComponents[1] blue:&fillColorComponents[2] alpha:&fillColorComponents[3]];
}

+(void)fill:(int)grey {
	fillColor = [CFAColor colorFromIntValuesRed:grey green:grey blue:grey alpha:255];
	[fillColor getRed:&fillColorComponents[0] green:&fillColorComponents[1] blue:&fillColorComponents[2] alpha:&fillColorComponents[3]];
}

+(void)fill:(int)grey alpha:(int)alpha{
	
	/*
	crashes when called in -(void)setup{}
	 */
	fillColor = [CFAColor colorFromIntValuesRed:grey green:grey blue:grey alpha:alpha];
	[fillColor getRed:&fillColorComponents[0] green:&fillColorComponents[1] blue:&fillColorComponents[2] alpha:&fillColorComponents[3]];
}

+(void)fillRed:(int)red green:(int)green blue:(int)blue {
	fillColor = [CFAColor colorFromIntValuesRed:red green:green blue:blue alpha:255];
	[fillColor getRed:&fillColorComponents[0] green:&fillColorComponents[1] blue:&fillColorComponents[2] alpha:&fillColorComponents[3]];
	//CFALog(@"%4.2f,%4.2f,%4.2f,%4.2f",fillColorComponents[0],fillColorComponents[1],fillColorComponents[2],fillColorComponents[3]);
}

+(void)fillRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha{
	fillColor = [CFAColor colorFromIntValuesRed:red green:green blue:blue alpha:alpha];
	[fillColor getRed:&fillColorComponents[0] green:&fillColorComponents[1] blue:&fillColorComponents[2] alpha:&fillColorComponents[3]];
}

+(void)noFill {
	useFill = NO;
}

+(void)fill {
	useFill = YES;
}

+(void)stroke {
	useStroke = YES;
}

+(void)strokeColor:(NSColor *)color {
	strokeColor = color;
	[strokeColor getComponents:strokeColorComponents];
}

+(void)strokeColor:(NSColor *)color alpha:(int)alpha{
	strokeColor = [color colorWithAlphaComponent:FLOAT_FROM_255(alpha)];
	[strokeColor getComponents:strokeColorComponents];
}

+(void)stroke:(int)grey {
	strokeColor = [CFAColor colorFromIntValuesRed:grey green:grey blue:grey alpha:255];
	[strokeColor getComponents:strokeColorComponents];
}

+(void)stroke:(int)grey alpha:(int)alpha {
	strokeColor = [CFAColor colorFromIntValuesRed:grey green:grey blue:grey alpha:alpha];
	[strokeColor getComponents:strokeColorComponents];
}

+(void)strokeRed:(int)red green:(int)green blue:(int)blue {
	strokeColor = [CFAColor colorFromIntValuesRed:red green:green blue:blue alpha:255];
	[strokeColor getComponents:strokeColorComponents];
}

+(void)strokeRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha{
	strokeColor = [CFAColor colorFromIntValuesRed:red green:green blue:blue alpha:alpha];
	[strokeColor getComponents:strokeColorComponents];
}

+(void)noStroke {
	useStroke = NO;
}

+(void)fillColorSet {
	/*
	 THIS CRASHES RANDOMLY SOMETIMES
	 FIGURE OUT WHY... NOTICED IT WHEN I WAS WORKING ON THE KEYBOARDFUNCTIONS EXAMPLE
	 */
	
	if (useFill == YES) [fillColor set];
	else [[NSColor colorWithCalibratedWhite:1.0f alpha:0.0f] set];
}

+(void)strokeColorSet {
	if (useStroke == YES) [strokeColor set];
	else [[NSColor colorWithCalibratedWhite:1.0f alpha:0.0f] set];
}

+(void)cgFillColorSet {
	if(useFill == YES) CGContextSetRGBFillColor(pdfContext,fillColorComponents[0],fillColorComponents[1],fillColorComponents[2],fillColorComponents[3]);
	else CGContextSetRGBFillColor(pdfContext, 0, 0, 0, 0);
}

+(void)cgStrokeColorSet {
	if (strokeWidth < 1) {
		strokeWidth = 1;
	}
	CGContextSetLineWidth(pdfContext, strokeWidth);
	if(useStroke == YES) CGContextSetRGBStrokeColor(pdfContext, strokeColorComponents[0], strokeColorComponents[1], strokeColorComponents[2], strokeColorComponents[3]);
	else CGContextSetRGBStrokeColor(pdfContext, 0, 0, 0, 0);
}

#pragma mark Coordinates
-(void)flipCoordinates {
}

-(void)nativeCoordinates {
}

#pragma mark Output
+(BOOL)isClean {
	return isClean;
}

+(void)beginDrawToPDFContext:(CGContextRef)context {
	pdfContext = context;
	CGContextRetain(pdfContext);
	drawToPDF = YES;
	isClean = NO;
}

+(void)endDrawToPDFContext {
	drawToPDF = NO;
	CGContextRelease(pdfContext);
	isClean = YES;
	CFALog(@"endDrawToPDFContext");
}

@end