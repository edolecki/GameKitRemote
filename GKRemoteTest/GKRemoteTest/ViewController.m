//
//  ViewController.m
//  GKRemoteTest
//
//  Created by Eric Dolecki on 2/26/13.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize remote;
@synthesize connectionLabel;
@synthesize connectButton;
@synthesize dataStringText;

#pragma mark - Send a message

- ( void )sendMessageToPeers:( NSString * )message {
    if ( remote.connected == YES ) {
        [remote sendStringDataToPeers:message];
    }
}

#pragma mark - Notifications

- ( void )connected {
    NSLog( @"connected" );
    connectionLabel.text = @"connected";
    connectButton.titleLabel.text = @"disconnect";
    [self sendMessageToPeers:@"I'm connected and I am here!"];
    dataStringText.text = @"data receieved";
}

- ( void )disconnected {
    NSLog( @"disconnected" );
    connectionLabel.text = @"disconnected";
    connectButton.titleLabel.text = @"connect";
    dataStringText.text = @"";
}

- ( void )cancelled {
    NSLog( @"cancelled connection" );
    if( remote.connected == NO ){
        connectButton.titleLabel.text = @"connect";
    } else {
        connectButton.titleLabel.text = @"disconnect";
    }
}

- ( void )dataReceived:( NSNotification * )notification {
    NSDictionary *tmp = notification.userInfo;
    NSString *stringData = [tmp objectForKey:@"data"];
    NSLog( @"Received: %@", stringData );
    dataStringText.text = stringData;
}

#pragma mark - Typicals

- ( void )viewDidLoad {
    [super viewDidLoad];
    [self registerForNotifications];
    remote = [[GameKitRemote alloc] initWithSession:@"abc123ZYX" displayName:@"Steel Panther"];
}

- ( void )registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connected)
                                                 name:@"Connected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnected)
                                                 name:@"Disconnected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelled)
                                                 name:@"Cancelled"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataReceived:)
                                                 name:@"DataReceived"
                                               object:nil];
}

- ( IBAction )connectAction:( id )sender {
    if( remote.connected == NO ){
        [remote connect];
    } else {
        [remote disconnect];
    }
}

- ( void )didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
