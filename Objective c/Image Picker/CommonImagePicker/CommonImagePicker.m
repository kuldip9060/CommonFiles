//
//  CommonImagePicker.m
//  CommonImagePicker
//
//  Created by Kuldip on 22/02/17.
//  Copyright © Kuldip. All rights reserved.
//

/** HOW TO USE
 //below code write where u wan to use
 
 objImagePicker = [[CommonImagePicker alloc] init];
 objImagePicker.delegate = self;
 objImagePicker.definesPresentationContext = YES;
 [objImagePicker setModalPresentationStyle:UIModalPresentationOverCurrentContext];
 [self.navigationController presentViewController:objImagePicker animated:YES completion:nil];
 */

#import "CommonImagePicker.h"

@interface CommonImagePicker ()

@end

@implementation CommonImagePicker


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    aImagePicker = [[UIImagePickerController alloc]init];
    aImagePicker.delegate = self;
    aImagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
    aImagePicker.allowsEditing = YES;
    
    [self openImagePickerOptions];
}

-(void)openImagePickerOptions{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Add Photo" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertActionCamera = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                        {
                                            [alertController dismissViewControllerAnimated:YES completion:nil];
                                            
                                            if ([UIImagePickerController isSourceTypeAvailable:
                                                 UIImagePickerControllerSourceTypeCamera])
                                            {
                                                aImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                
                                                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                                                if(authStatus == AVAuthorizationStatusAuthorized)
                                                {
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                        [self presentViewController:aImagePicker animated:YES completion:nil];
                                                    }];
                                                }
                                                else if(authStatus == AVAuthorizationStatusNotDetermined)
                                                {
                                                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
                                                     {
                                                         if(granted)
                                                         {
                                                             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                 [self presentViewController:aImagePicker animated:YES completion:nil];
                                                             }];
                                                         }
                                                         else
                                                         {
                                                             [[VIEWDSingleton sharedSingleton] showSimpleAlert:@"The client is not authorized to access camera."];
                                                             
                                                             return;
                                                         }
                                                     }];
                                                }
                                                else if (authStatus == AVAuthorizationStatusRestricted)
                                                {
                                                    [[VIEWDSingleton sharedSingleton] showSimpleAlert:@"The client is not authorized to access camera."];
                                                    return;
                                                }
                                                else
                                                {
                                                    [[VIEWDSingleton sharedSingleton] showSimpleAlert:@"The client is not authorized to access camera."];
                                                    return;
                                                }
                                            }
                                            else
                                            {
                                                aImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                
                                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                    [self presentViewController:aImagePicker animated:YES completion:nil];
                                                }];
                                            }
                                        }];
    
    UIAlertAction *alertActionGallery = [UIAlertAction actionWithTitle:@"Choose from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         {
                                             [alertController dismissViewControllerAnimated:YES completion:nil];
                                             
                                             aImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                             
                                             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                 [self presentViewController:aImagePicker animated:YES completion:nil];
                                             }];
                                         }];
    
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
                                        {
                                            [alertController dismissViewControllerAnimated:YES completion:nil];
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        }];
    
    [alertController addAction:alertActionCamera];
    [alertController addAction:alertActionGallery];
    [alertController addAction:alertActionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
   
    [picker dismissViewControllerAnimated:YES completion:^{
        [_delegate didFinishPickImage:info[@"UIImagePickerControllerEditedImage"]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
   

    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
