//
//  SDServerViewController.m
//  AcceleSender
//
//  Created by Sam Davies on 27/11/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SDServerViewController.h"
@import MultipeerConnectivity;
@import CoreMotion;
#import "CMMotionManager+DataInject.h"

@interface SDServerViewController () <MCSessionDelegate> {
    MCPeerID *_peerID;
    MCSession *_session;
    MCAdvertiserAssistant *_advertiserAssistant;
    CMMotionManager *_motionManager;
}

@end

@implementation SDServerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self startServer];
    [self startLoggingAccelerometer];
}

- (void)startServer
{
    _peerID = [[MCPeerID alloc] initWithDisplayName:@"accelsender-server"];
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
    _advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"accelsender"
                                                                discoveryInfo:nil
                                                                      session:_session];
    [_advertiserAssistant start];
}

- (void)startLoggingAccelerometer
{
    //[CMMotionManager enableInjection:YES];
    if(!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    NSLog(@"Starting accelerometer logging...");
    [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        NSLog(@"From CoreMotion: %@", accelerometerData);
    }];
}

- (IBAction)handleDismissPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - MCSessionDelegate methods
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    CMAccelerometerData *accelerometerData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [_motionManager postNewAccelerometerData:accelerometerData];
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    
}

@end
