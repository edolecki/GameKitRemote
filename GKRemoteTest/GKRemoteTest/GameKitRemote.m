//
//  GameKitRemote.m
//  VoiceWave
//
//  Created by Eric Dolecki on 2/15/13.
//  Copyright (c) 2013 Eric Dolecki. All rights reserved.
//

#import "GameKitRemote.h"

@implementation GameKitRemote

@synthesize currentSession;
@synthesize _sessionID;
@synthesize _displayName;

GKPeerPickerController *picker;

- ( id )initWithSession:(NSString *)sessionID displayName:(NSString *)displayName {
    self = [super init];
    if( self ){
        if( [sessionID length] != 0 ){
            self._sessionID = sessionID;
        } else {
            self._sessionID = @"foo";
        }
        if( [displayName length] != 0 ){
            self._displayName = displayName;
        } else {
            self._displayName = @"Application";
        }
    }
    _connected = NO;
    return self;
}

- ( NSString* )displayName {
    return _displayName;
}

- ( NSString* )sessionID {
    return _sessionID;
}

- (BOOL)connected {
    return _connected;
}

#pragma mark - Connection

- ( void )connect {
    picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [picker show];
}

#pragma mark - Send Data To Peers

- (void) sendDataToPeers:( NSData * )data
{
    if( currentSession ){
        [self.currentSession sendDataToAllPeers:data
                                   withDataMode:GKSendDataReliable
                                          error:nil];
    }
}

- ( void )sendStringDataToPeers:( NSString * )string {
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
    [self sendDataToPeers:data];
}

#pragma mark - GameKit Delegates

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    NSString *dataReceived = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:dataReceived forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataReceived" object:nil userInfo:dict];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type {
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    self.currentSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
    picker.delegate = nil;
    [picker dismiss];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
    picker.delegate = nil;
    NSLog( @"Cancelled" );
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    NSLog( @"Peer request from: %@", peerID );
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch (state)
    {
        case GKPeerStateConnected:
            NSLog( @"Connected" );
            _connected = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Connected" object:nil userInfo:nil];
            break;
        case GKPeerStateDisconnected:
            _connected = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Disconnected" object:nil userInfo:nil];
            NSLog( @"Disconnected" );
            break;
        case GKPeerStateAvailable:
        case GKPeerStateConnecting:
        case GKPeerStateUnavailable:
            break;
        default:
            break;
    }
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    NSLog( @"Error: %@", error );
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
    if(currentSession == nil){
        currentSession = [[GKSession alloc] initWithSessionID:_sessionID
                                                  displayName:_displayName
                                                  sessionMode:GKSessionModePeer];
        currentSession.delegate = self;
    }
    return currentSession;
}

@end
