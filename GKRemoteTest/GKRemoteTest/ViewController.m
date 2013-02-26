//
//  ViewController.m
//  GKRemoteTest
//
//  Created by Eric Dolecki on 2/26/13.
//  Copyright (c) 2013 Eric Dolecki. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize remote;

#pragma mark - Send a message

- (void)sendMessageToPeers:(NSString *)message {
    if ( remote.connected == YES ) {
        [remote sendStringDataToPeers:message];
    }
}

#pragma mark - Notifications

- (void)connected {
    NSLog(@"connected");
}

- (void)disconnected {
    NSLog(@"disconnected");
}

- (void)dataReceived:(NSNotification *)notification {
    NSDictionary *tmp = notification.userInfo;
    NSString *stringData = [tmp objectForKey:@"data"];
    NSLog( @"Received: %@", stringData );
}

#pragma mark - Typicals

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForNotifications];
    remote = [[GameKitRemote alloc] initWithSession:@"abc123" displayName:@"Steel Panther"];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connected)
                                                 name:@"Connected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnected)
                                                 name:@"Disconnected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataReceived:)
                                                 name:@"DataReceived"
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [remote connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
