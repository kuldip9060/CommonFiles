//
//  ViewController.h
//  demoVideoEditing
//
//  Created by Kuldip on 13/11/16.
//  Copyright © 2016 kuldip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController < UINavigationControllerDelegate,UIImagePickerControllerDelegate,MPMediaPickerControllerDelegate,AVAudioPlayerDelegate>

//@property (weak, nonatomic) IBOutlet UIView *viewPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *imgThumbnail;
//@property (weak, nonatomic) IBOutlet UITextField *txtSnap;
@property (weak, nonatomic) IBOutlet UIButton *btnAudioPlay;

- (IBAction)btnGalleryPressed:(id)sender;
- (IBAction)btnPlayPressed:(id)sender;
- (IBAction)btnAddTextfieldPressed:(id)sender;
- (IBAction)btnSelectAudioPressed:(id)sender;
- (IBAction)btnAudioPlayStopPressed:(id)sender;

@end

