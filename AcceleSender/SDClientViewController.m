//
//  SDClientViewController.m
//  AcceleSender
//
//  Created by Sam Davies on 27/11/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SDClientViewController.h"
@import MultipeerConnectivity;
@import CoreMotion;

@interface SDClientViewController () <MCBrowserViewControllerDelegate> {
    MCPeerID *_peerID;
    MCSession *_session;
    CMMotionManager *_motionManager;
}

@end

@implementation SDClientViewController

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
    [self startClient];
}

- (void)startClient
{
    _peerID = [[MCPeerID alloc] initWithDisplayName:@"accelsender-client"];
    _session = [[MCSession alloc] initWithPeer:_peerID];
}

- (void)startBroadcast
{
    if(!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:accelerometerData];
        NSLog(@"Sending data");
        [_session sendData:dataToSend toPeers:[_session connectedPeers] withMode:MCSessionSendDataUnreliable error:NULL];
    }];
}

- (IBAction)handleDismissPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)handleConnectPressed:(id)sender {
    MCBrowserViewController *browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"accelsender" session:_session];
    browserVC.delegate = self;
    [self presentViewController:browserVC animated:YES completion:NULL];
}

#pragma mark - MCBrowserViewControllerDelegate methods
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:^{
        [self startBroadcast];
    }];
}
@end
