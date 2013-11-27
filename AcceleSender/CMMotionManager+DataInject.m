//
//  CMMotionManager+DataInject.m
//  AcceleSender
//
//  Created by Sam Davies on 27/11/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "CMMotionManager+DataInject.h"
#import <objc/runtime.h>
static char *accelHandlerBlockKey;

@implementation CMMotionManager (DataInject)

void MethodSwizzle(Class c, SEL origSEL, SEL overrideSEL)
{
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method overrideMethod = class_getInstanceMethod(c, overrideSEL);
    
    if(class_addMethod(c, origSEL, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod)))
    {
        class_replaceMethod(c, overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else
    {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}

- (void)override_startAccelerometerUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMAccelerometerHandler)handler
{
    self.accelHandlerBlock = handler;
}

- (void)postNewAccelerometerData:(CMAccelerometerData *)data
{
    if(self.accelHandlerBlock) {
        self.accelHandlerBlock(data, NULL);
    }
}

- (CMAccelerometerHandler)accelHandlerBlock
{
    return objc_getAssociatedObject(self, &accelHandlerBlockKey);
}

- (void)setAccelHandlerBlock:(CMAccelerometerHandler)handler
{
    objc_setAssociatedObject(self, &accelHandlerBlockKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void)enableInjection:(BOOL)enabled
{
    if(enabled) {
        MethodSwizzle(self, @selector(startAccelerometerUpdatesToQueue:withHandler:), @selector(override_startAccelerometerUpdatesToQueue:withHandler:));
    }
}

@end
