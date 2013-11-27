//
//  SDServerViewController.m
//  AcceleSender
//
//  Created by Sam Davies on 27/11/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SDServerViewController.h"
@import MultipeerConnectivity;

@interface SDServerViewController () {
    MCPeerID *_peerID;
    MCSession *_session;
    MCAdvertiserAssistant *_advertiserAssistant;
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
}

- (void)startServer
{
    _peerID = [[MCPeerID alloc] initWithDisplayName:@"accelsender-server"];
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"accelsender"
                                                                discoveryInfo:nil
                                                                      session:_session];
    [_advertiserAssistant start];
}

- (IBAction)handleDismissPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
