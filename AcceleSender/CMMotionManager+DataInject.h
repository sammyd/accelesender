//
//  CMMotionManager+DataInject.h
//  AcceleSender
//
//  Created by Sam Davies on 27/11/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

@interface CMMotionManager (DataInject)

@property (nonatomic, copy) CMAccelerometerHandler accelHandlerBlock;

- (void)postNewAccelerometerData:(CMAccelerometerData *)data;
+ (void)enableInjection:(BOOL)enabled;

@end
