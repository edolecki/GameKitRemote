//
//  ViewController.h
//  GKRemoteTest
//
//  Created by Eric Dolecki on 2/26/13.
//

#import <UIKit/UIKit.h>
#import "GameKitRemote.h"

@interface ViewController : UIViewController {
    GameKitRemote *remote;
    IBOutlet UILabel *connectionLabel;
    IBOutlet UIButton *connectButton;
    IBOutlet UITextView *dataStringText;
}

@property( nonatomic,retain ) GameKitRemote *remote;
@property( nonatomic, retain) IBOutlet UILabel *connectionLabel;
@property( nonatomic, retain ) IBOutlet UIButton *connectButton;
@property( nonatomic, retain ) IBOutlet UITextView *dataStringText;

- (IBAction)connectAction:(id)sender;

@end
