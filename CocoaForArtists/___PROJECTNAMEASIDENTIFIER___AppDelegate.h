//
//  ___PROJECTNAME___
//	A Cocoa For Artists project
//  Created by ___FULLUSERNAME___ on ___DATE___.
//

#import <Cocoa/Cocoa.h>
#import "CFACanvas.h"

#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
@interface ___PROJECTNAMEASIDENTIFIER___AppDelegate : NSObject {
#else
	@interface ___PROJECTNAMEASIDENTIFIER___AppDelegate : NSObject <NSApplicationDelegate> {
#endif
		NSWindow *window;
		IBOutlet CFACanvas *cfaCanvas;
		
	@private
		CFAOpenGLView	*cfaOpenGLView;
		CFAColor		*cfaColor;
		CFADateTime		*cfaDateTime;
		CFAFoundation	*cfaFoundation;
		CFAMath			*cfaMath;
		CFAShape		*cfaShape;
		CFATransform	*cfaTransform;
		CFAString		*cfaString;
		CFAGlobalTypeAttributes	*cfaGlobalTypeAttributes;
		CFATuio			*cfaTuio;
		CFANoise		*cfaNoise;
	}

@property (assign) IBOutlet NSWindow *window;
	
@end