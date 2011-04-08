//
//  CFAShape.h
//  Created by Travis Kirton
//

#import <Cocoa/Cocoa.h>

@interface CFAShape : CFAObject {
}

#pragma mark Singleton
-(id)_init;
+(CFAShape *)sharedManager;

/*
 Not too sure what to do...
 Should I make this an object container?
 At the moment it simply draws shapes, but doesn't keep them in memory.
 
 I think I should make it an object into which you can add/compound shapes.
 */

#pragma mark Shapes
+(void)arcWithCenterAt:(NSPoint)p radius:(CGFloat)r startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;
+(void)circleAt:(NSPoint)p radius:(CGFloat)r;
+(void)curveFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 controlPoint1:(NSPoint)c1 controlPoint2:(NSPoint)c2;
+(void)curveFromX:(NSInteger)x1 Y:(NSInteger)y1 toX:(NSInteger)x2 Y:(NSInteger)y2 controlPoint1X:(NSInteger)cx1 Y:(NSInteger)cx1 controlPoint2X:(NSInteger)cx2 Y:(NSInteger)cy2;
+(void)ellipseAt:(NSPoint)p size:(NSSize)s;
+(void)ellipseWithXPos:(NSInteger)x yPos:(NSInteger)y width:(NSInteger)w andHeight:(NSInteger)h;
+(void)lineFromX:(NSInteger)x1 Y:(NSInteger)y1 toX:(NSInteger)x2 Y:(NSInteger)y2;
+(void)lineFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2;
+(void)pointAtX:(NSInteger)x1 Y:(NSInteger)y1;
+(void)pointAt:(NSPoint)p;
+(void)rectWithXPos:(NSInteger)x yPos:(NSInteger)y width:(CGFloat)w andHeight:(CGFloat)h;
+(void)rectAt:(NSPoint)p size:(NSSize)s;
+(void)triangleFromX:(NSInteger)x1 Y:(NSInteger)y1 toX:(NSInteger)x2 Y:(NSInteger)y2 toX:(NSInteger)x3 Y:(NSInteger)y3;
+(void)triangleUsingPoint:(NSPoint)p1 point:(NSPoint)p2 point:(NSPoint)p3;
+(void)quadUsingPoint:(NSPoint)p1 point:(NSPoint)p2 point:(NSPoint)p3 point:(NSPoint)p4;
+(void)quadFromX:(NSInteger)x1 Y:(NSInteger)y1 toX:(NSInteger)x2 Y:(NSInteger)y2 toX:(NSInteger)x3 Y:(NSInteger)y3 toX:(NSInteger)x4 Y:(NSInteger)y4;

#pragma mark Vertex Shapes
+(void)beginShape;
+(void)endShape;
+(void)closeShape;
+(void)vertexAtX:(NSInteger)x Y:(NSInteger)y;
+(void)vertexAt:(NSPoint)point;

#pragma mark Current Shape 
+(void)clearCurrentShape;
+(CGMutablePathRef)currentShape;
+(void)addArcWithCenterAt:(NSPoint)p radius:(CGFloat)r startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;
+(void)addCircleAt:(NSPoint)p radius:(NSInteger)r;
+(void)addCurveFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 controlPoint1:(NSPoint)c1 controlPoint2:(NSPoint)c2;
+(void)addCurveFromX:(NSInteger)x1 Y:(NSInteger)y1 toX:(NSInteger)x2 Y:(NSInteger)y2 controlPoint1X:(NSInteger)cx1 Y:(NSInteger)cx1 controlPoint2X:(NSInteger)cx2 Y:(NSInteger)cy2;
+(void)addEllipseAt:(NSPoint)p size:(NSSize)s;
+(void)addEllipseWithXPos:(NSInteger)x yPos:(NSInteger)y width:(NSInteger)w andHeight:(NSInteger)h;
+(void)addLineFromX:(NSInteger)x1 Y:(NSInteger)y1 toX:(NSInteger)x2 Y:(NSInteger)y2;
+(void)addLineFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2;
+(void)addLineTo:(NSPoint)p;
+(void)addLineToX:(NSInteger)x Y:(NSInteger)y;
+(void)addPointAtX:(NSInteger)x1 Y:(NSInteger)y1;
+(void)addPointAt:(NSPoint)p;
+(void)addRectWithXPos:(NSInteger)x yPos:(NSInteger)y width:(CGFloat)w andHeight:(CGFloat)h;
+(void)addTriangleFromX:(NSInteger)x1 Y:(NSInteger)y1 toX:(NSInteger)x2 Y:(NSInteger)y2 toX:(NSInteger)x3 Y:(NSInteger)y3;
+(void)addTriangleUsingPoint:(NSPoint)p1 point:(NSPoint)p2 point:(NSPoint)p3;
+(void)addQuadUsingPoint:(NSPoint)p1 point:(NSPoint)p2 point:(NSPoint)p3 point:(NSPoint)p4;
+(void)addQuadFromX:(NSInteger)x1 Y:(NSInteger)y1 toX:(NSInteger)x2 Y:(NSInteger)y2 toX:(NSInteger)x3 Y:(NSInteger)y3 toX:(NSInteger)x4 Y:(NSInteger)y4;

#pragma mark Attributes
+(void)strokeWidth:(CGFloat)width;
+(void)rectMode:(NSInteger)mode;
+(void)ellipseMode:(NSInteger)mode;
+(void)strokeCapMode:(NSInteger)mode;
+(void)strokeJoinMode:(NSInteger)mode;
+(void)strokeDetail:(CGFloat)level;

#pragma mark Colors
+(void)fill;
+(void)fillColor:(CFAColor *)color;
+(void)fill:(CGFloat)grey;
+(void)fill:(CGFloat)grey alpha:(CGFloat)alpha;
+(void)fillRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+(void)fillRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+(void)noFill;
+(void)stroke;
+(void)strokeColor:(CFAColor *)color;
+(void)stroke:(CGFloat)grey;
+(void)stroke:(CGFloat)grey alpha:(CGFloat)alpha;
+(void)strokeRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+(void)strokeRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)a;
+(void)noStroke;

#pragma mark Coordinates
-(void)flipCoordinates;
-(void)nativeCoordinates;

#pragma mark Output
+(BOOL)isClean;
+(void)beginDrawShapesToPDFContext:(CGContextRef)context;
+(void)endDrawShapesToPDFContext;
@end
