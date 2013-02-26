//
//  GameKitRemote.h
//  VoiceWave
//
//  Created by Eric Dolecki on 2/15/13.
//  Copyright (c) 2013 Eric Dolecki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameKitRemote : NSObject <GKSessionDelegate, GKPeerPickerControllerDelegate>{
    GKSession *currentSession;
    NSString *_sessionID;
    NSString *_displayName;
    BOOL _connected;
}

@property( nonatomic, retain ) GKSession *currentSession;
@property( nonatomic, retain ) NSString *_sessionID;
@property( nonatomic, retain ) NSString *_displayName;

- ( id )initWithSession:(NSString *)sessionID displayName:(NSString *)displayName;
- ( void )connect;
- ( void )sendStringDataToPeers:( NSString * )string;
- ( NSString* )displayName;
- ( NSString* )sessionID;
- ( BOOL) connected;

@end
