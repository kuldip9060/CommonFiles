//
//  CommonImagePicker.h
//  CommonImagePicker
//
//  Created by Kuldip on 22/02/17.
//  Copyright © Kuldip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Headers.h"

@protocol CommonImagePickerDelegate <NSObject>

@required
- (void)didFinishPickImage:(UIImage *)img;

@end

@interface CommonImagePicker : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *aImagePicker;
}

@property (nonatomic, weak) id<CommonImagePickerDelegate> delegate;

-(void)openImagePickerOptions;

@end


