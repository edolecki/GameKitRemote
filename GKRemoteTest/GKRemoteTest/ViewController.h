//
//  ViewController.h
//  GKRemoteTest
//
//  Created by Eric Dolecki on 2/26/13.
//  Copyright (c) 2013 Eric Dolecki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameKitRemote.h"

@interface ViewController : UIViewController {
    GameKitRemote *remote;
}

@property(nonatomic,retain) GameKitRemote *remote;

@end
