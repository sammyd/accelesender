//
//  SDClientViewController.m
//  AcceleSender
//
//  Created by Sam Davies on 27/11/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SDClientViewController.h"
@import MultipeerConnectivity;

@interface SDClientViewController () <MCBrowserViewControllerDelegate> {
    MCPeerID *_peerID;
    MCSession *_session;
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
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}
@end
