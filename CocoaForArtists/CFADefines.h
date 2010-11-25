//
//  CFADefines.h
//  Cocoa For Artists
//
//  Created by Travis Kirton.
//

#define NOW mach_absolute_time()

#define VERBOSELOAD NO

#define DEGREES_TO_RADIANS(n)		((n) * (PI / 180.0f))
#define RADIANS_TO_DEGREES(n)		((n) * (180.0f / PI))
#define	FLOAT_FROM_255(n)			((n)/255.0f)
#define	FLOAT_TO_255(n)				(n*255.0f);

#define CENTER 0
#define CORNER 1

#define	ANIMATED	2
#define SINGLEFRAME	3
#define	EVENTBASED	4

#define MOUSELEFT	5
#define MOUSERIGHT	6
#define MOUSECENTER	7
#define MOUSEOTHER	8
#define NOMOUSE		9

#define UP			NSUpArrowFunctionKey
#define DOWN		NSDownArrowFunctionKey
#define LEFT		NSLeftArrowFunctionKey
#define RIGHT		NSRightArrowFunctionKey
#define F1			NSF1FunctionKey
#define F2			NSF2FunctionKey
#define F3			NSF3FunctionKey
#define F4			NSF4FunctionKey
#define F5			NSF5FunctionKey
#define F6			NSF6FunctionKey
#define F7			NSF7FunctionKey
#define F8			NSF8FunctionKey
#define F9			NSF9FunctionKey
#define F10			NSF10FunctionKey
#define F11			NSF11FunctionKey
#define F12			NSF12FunctionKey
#define INSERT		NSInsertFunctionKey
#define BACKSPACE	NSDeleteFunctionKey
#define HOME		NSHomeFunctionKey
#define BEGIN		NSBeginFunctionKey
#define END			NSEndFunctionKey
#define PAGEUP		NSPageUpFunctionKey
#define PAGEDOWN	NSPageDownFunctionKey
#define PRINTSCREEN	NSPrintScreenFunctionKey
#define UNDO		NSUndoFunctionKey
#define REDO		NSRedoFunctionKey
#define HELP		NSHelpFunctionKey
#define TAB			'\t'
#define SPACEBAR	' '
#define RETURN		'\r'
#define ENTER		'\003'
#define BACKTAB		'\031'
#define ESCAPE		'\033'
#define DELETE		'\177'

#define CAPBUTT		NSButtLineCapStyle
#define CAPROUND	NSRoundLineCapStyle
#define CAPSQUARE	NSSquareLineCapStyle
#define JOINMITRE	NSMiterLineJoinStyle
#define JOINROUND	NSRoundLineJoinStyle
#define JOINBEVEL	NSBevelLineJoinStyle
