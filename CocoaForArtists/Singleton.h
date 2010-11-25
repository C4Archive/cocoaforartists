//
//  Singleton.h
//  E15
//
//  Created by buza on 10/22/08.
//  Copyright 2008 buza. All rights reserved.
//

#define GENERATE_SINGLETON(classname, instance)     \
+ (classname*)sharedManager                         \
{                                                   \
    if (instance == nil) {                          \
        instance = [[self alloc] _init];            \
    }                                               \
    return instance;                                \
}                                                   \
+ (id)allocWithZone:(NSZone *)zone                  \
{                                                   \
    if (instance == nil) {                          \
        instance = [super allocWithZone:zone];      \
        return instance;                            \
    }                                               \
    return nil;                                     \
}                                                   \
- (id)copyWithZone:(NSZone *)zone { return self; }  \
- (id)retain { return self; }                       \
- (NSUInteger)retainCount { return UINT_MAX; }      \
- (void)release { }                                 \
- (void)dealloc { [super dealloc]; }                \
- (id)autorelease { return self; }

#define GENERATE_SINGLETON_WITH_CONTEXT(classname, instance)        \
static NSOpenGLContext *sParentContext = nil;                       \
+ (void)seedWithContext:(NSOpenGLContext *) ctx                     \
{                                                                   \
    sParentContext = ctx;                                           \
}                                                                   \
+ (classname*)sharedManager                                         \
{                                                                   \
    if(sParentContext == nil) { NSLog(@"No shared OpenGL context found. Did you remember to seed it with seedWithContext:?"); return nil; } \
    if (instance == nil) {                          \
        instance = [[self alloc] _init];            \
    }                                               \
    return instance;                                \
}                                                   \
+ (id)allocWithZone:(NSZone *)zone                  \
{                                                   \
    if (instance == nil) {                          \
        instance = [super allocWithZone:zone];      \
        return instance;                            \
    }                                               \
    return nil;                                     \
}                                                   \
- (id)copyWithZone:(NSZone *)zone { return self; }  \
- (id)retain { return self; }                       \
- (unsigned)retainCount { return UINT_MAX; }        \
- (void)release { }                                 \
- (void)dealloc {     [pixelFormat release]; [renderContext release]; [super dealloc]; }                \
- (id)autorelease { return self; }
