//
//  ViewController.m
//  demoVideoEditing
//
//  Created by Kuldip on 13/11/16.
//  Copyright © 2016 kuldip. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ViewController (){
    
    AVAudioPlayer *audioPlayer;
    NSData *audioData;
    NSURL *audioURL;
    
    NSURL *videoURL;
    
    
    AVAssetExportSession *assetExport;
    
    UIView *viewPlayer;
    UITextField *txtSnap;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark : - Button Action
- (IBAction)btnGalleryPressed:(id)sender {
    
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = self;
    //videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    //videoPicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    [self presentViewController:videoPicker animated:YES completion:nil];
}

- (IBAction)btnPlayPressed:(id)sender {
    
    /* // REMOVE COMMENT FOR VIDEO WITH SNAP TEXT EDITING
        [self videoOutput];
     */
    
    /* // REMOVE COMMENT FOR VIDEO WITH AUDIO EDITING
    if(videoURL && audioURL)
        [self mergeVideo:videoURL withAudio:audioURL];
     */
}

- (IBAction)btnAddTextfieldPressed:(id)sender {
    
    //CGRect rect = AVMakeRectWithAspectRatioInsideRect(_imgThumbnail.image.size, _imgThumbnail.bounds);
    //NSLog(@"%@",NSStringFromCGRect(rect));
    
    CGSize videoSize = [self CGSizeAspectFit:_imgThumbnail.image.size withBounding:_imgThumbnail.frame.size]; // Aspect Fit
    
    txtSnap = [[UITextField alloc] init];
    txtSnap.placeholder = @"Add snap text here...";
    txtSnap.font = [UIFont systemFontOfSize:14];
    txtSnap.textColor = [UIColor whiteColor];
    txtSnap.textAlignment = NSTextAlignmentCenter;
    txtSnap.autocorrectionType = UITextAutocorrectionTypeNo;
    txtSnap.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    
    CGRect fram = txtSnap.frame;
    fram.size.width = viewPlayer.frame.size.width;
    fram.size.height = 30;
    fram.origin.y = (videoSize.height-fram.size.height)/2;
    [txtSnap setFrame:fram];
    [viewPlayer addSubview:txtSnap];
   
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesturePan:)];
    [txtSnap addGestureRecognizer:panGesture];
    
    
    
//    txtSnap.hidden = NO;
}

- (IBAction)btnSelectAudioPressed:(id)sender {
    
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"]) {
        //device is simulator
        UIAlertView *alert1;
        alert1 = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There is no Audio file in the Device" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
        alert1.tag=2;
        [alert1 show];
        //[alert1 release],alert1=nil;
    }else{
        
        MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
        mediaPicker.delegate = self;
        mediaPicker.allowsPickingMultipleItems = NO;
        [self presentViewController:mediaPicker animated:YES completion:nil];
        
    }
}

- (IBAction)btnAudioPlayStopPressed:(id)sender {
    
    if([sender isSelected]){
        [audioPlayer stop];
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
        audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData  error:NULL];
        audioPlayer.delegate = self;
        [audioPlayer play];
    }
    
}

#pragma mark Media picker delegate methods

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    
    // We need to dismiss the picker
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Assign the selected item(s) to the music player and start playback.
    if ([mediaItemCollection count] < 1) {
        return;
    }
    MPMediaItem *song = [[mediaItemCollection items] objectAtIndex:0];
    NSLog(@"%@",song);
    
    if (song) {
        audioURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
//        [self handleAudioExportTapped:song];
        NSLog(@"%@",[song valueForProperty:MPMediaItemPropertyPodcastTitle]);
        _btnAudioPlay.hidden = NO;
    }
    
    
    
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    
    // User did not select anything
    // We need to dismiss the picker
    
    [self dismissViewControllerAnimated:YES completion:nil ];
}

-(void)handleAudioExportTapped:(MPMediaItem*)song{
    
    // get the special URL
    if (! song) {
        return;
    }
    
    //[self startLoaderWithLabel:@"Preparing for upload..."];
    
    NSURL *assetURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
//    NSLog (@"Core Audio %@ directly open library URL %@",
//           coreAudioCanOpenURL (assetURL) ? @"can" : @"cannot",
//           assetURL);
    
    NSLog (@"compatible presets for songAsset: %@",
           [AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset]);
    
    
    /* approach 1: export just the song itself
     */
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      initWithAsset: songAsset
                                      presetName: AVAssetExportPresetAppleM4A];
    NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
    exporter.outputFileType = @"com.apple.m4a-audio";
    NSString *exportFile = [[self myDocumentsDirectory] stringByAppendingPathComponent: @"exported.m4a"];
    // end of approach 1
    NSLog(@"AudioURL:%@",exportFile);
    
    // set up export (hang on to exportURL so convert to PCM can find it)
    [self myDeleteFile:exportFile];
    //[exportURL release];
    NSURL *exportURL = [NSURL fileURLWithPath:exportFile];
    exporter.outputURL = exportURL;
    
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exporter.status;
        switch (exporter.status) {
            case AVAssetExportSessionStatusFailed: {
                // log error to text view
                NSError *exportError = exporter.error;
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                //errorView.text = exportError ? [exportError description] : @"Unknown failure";
                //errorView.hidden = NO;
                //[self stopLoader];
                //[self showAlertWithMessage:@"There ia an error!"];
                break;
            }
            case AVAssetExportSessionStatusCompleted: {
                NSLog (@"AVAssetExportSessionStatusCompleted");
                //fileNameLabel.text = [exporter.outputURL lastPathComponent];
                // set up AVPlayer
                //[self setUpAVPlayerForURL: exporter.outputURL];
                ///////////////// get audio data from url
                
                //[self stopLoader];
                //[self showAlertWithMessage:@"There ia an error!"];
                
                NSURL *audioUrl = exportURL;
                NSLog(@"Audio Url=%@",audioUrl);
                audioData = [NSData dataWithContentsOfURL:audioUrl];
                
                break;
            }
            case AVAssetExportSessionStatusUnknown: {
                NSLog (@"AVAssetExportSessionStatusUnknown");
                //[self stopLoader];
                //[self showAlertWithMessage:@"There ia an error!"];
                break;
            }
            case AVAssetExportSessionStatusExporting: {
                NSLog (@"AVAssetExportSessionStatusExporting");
                //[self stopLoader];
                //[self showAlertWithMessage:@"There ia an error!"];
                break;
            }
            case AVAssetExportSessionStatusCancelled: {
                NSLog (@"AVAssetExportSessionStatusCancelled");
                //[self stopLoader];
                //[self showAlertWithMessage:@"There ia an error!"];
                break;
            }
            case AVAssetExportSessionStatusWaiting: {
                NSLog (@"AVAssetExportSessionStatusWaiting");
                //[self stopLoader];
                //[self showAlertWithMessage:@"There ia an error!"];
                break;
            }
            default: {
                NSLog (@"didn't get export status");
                //[self stopLoader];
                //[self showAlertWithMessage:@"There ia an error!"];
                break;
            }
        }
    }];
    
    
    
}

#pragma mark: - Audio Player Delegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [audioPlayer stop];
    NSLog(@"Finished Playing");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Error occured");
}


#pragma mark : - Gesture Action
- (IBAction)handleGesturePan:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:viewPlayer];
    
    if( CGRectContainsPoint(viewPlayer.bounds, CGPointMake(sender.view.center.x,
                                                           sender.view.center.y + translation.y))){
        sender.view.center = CGPointMake(sender.view.center.x,
                                         sender.view.center.y + translation.y);
    }
    
    
   
    
//    if (sender.state == UIGestureRecognizerStateEnded) {
//        
//        // Check here for the position of the view when the user stops touching the screen
//        
//        // Set "CGFloat finalX" and "CGFloat finalY", depending on the last position of the touch
//        
//        // Use this to animate the position of your view to where you want
//        [UIView animateWithDuration: 0.3
//                              delay: 0
//                            options: UIViewAnimationOptionCurveEaseOut
//                         animations:^{
//                             CGPoint finalPoint = CGPointMake(0, 0);
//                             sender.view.center = finalPoint; }
//                         completion:nil];
//    }
    
    
    [sender setTranslation:CGPointMake(0, 0) inView:viewPlayer];
    
}

#pragma mark: -merge Video with Audio

-(void)mergeVideo:(NSURL*)vidURL withAudio:(NSURL*)audURL{
    
//    __block CameraSource* bThis = this;
    
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    
    NSArray *aDocumentpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = aDocumentpaths.firstObject;
//
//    NSString *aStrFilePath = [basePath stringByAppendingString:[NSString stringWithFormat:@"/%@.mp4",strCurrentVideo]];
    NSURL    *video_inputFileUrl = vidURL;
    
//    NSString *aStrFileAudioPath = [basePath stringByAppendingString:[NSString stringWithFormat:@"/%@.m4a",strCurrentVideo]];
    
//    NSURL *audioPathURL = [NSURL fileURLWithPath:aStrFileAudioPath];
    NSURL    *audio_inputFileUrl = audURL;
    
    //NSString* path = [NSString stringWithFormat:@"%@/Output.mp4",basePath];
    NSString *aVideoName = [[video_inputFileUrl lastPathComponent] stringByDeletingPathExtension];
    NSString *aAudioName = [[audio_inputFileUrl lastPathComponent] stringByDeletingPathExtension];
    NSString* path = [NSString stringWithFormat:@"%@/%@_%@.mp4",basePath,aVideoName,aAudioName];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    CMTime nextClipStartTime = kCMTimeZero;
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:video_inputFileUrl options:nil];
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
    
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audio_inputFileUrl options:nil];
    CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
    NSError* error;
    
    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:nextClipStartTime error:&error];
    
    
    AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [b_compositionAudioTrack insertTimeRange:video_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:nextClipStartTime error:&error];

    
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:mixComposition presetName:AVAssetExportPresetPassthrough];
    
    exporter.outputURL=[NSURL fileURLWithPath:path];
//    assetExport.outputFileType = @"public.mpeg-4";
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
//    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveVideo:exporter withDesinationPath:path];
        });
    }];
    
}

#pragma mark: -merge Video with Image OR Text

- (void) videoOutput
{
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
    
    //1 - Early exit if there's no video file selected
    if (!videoAsset) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Load a Video Asset First"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 2 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // 3 - Video track
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    CGFloat diffPointY = viewPlayer.frame.size.height - (txtSnap.center.y - viewPlayer.layer.anchorPoint.y);
    
    //    text laye
    CGSize videoSize = self.imgThumbnail.image.size;
    
    float aScale = self.imgThumbnail.image.size.height/viewPlayer.frame.size.height;
    
    
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7].CGColor;
    backgroundLayer.frame = CGRectMake(0, (diffPointY-15) * aScale, videoSize.width, 30 * aScale);
 
    CATextLayer *titleLayer = [CATextLayer layer];
    titleLayer.string = txtSnap.text;
    titleLayer.fontSize = 14*aScale;
//    titleLayer.foregroundColor = [UIColor blackColor].CGColor;
//    titleLayer.foregroundColor = _txtSnap.textColor.CGColor;
//    titleLayer.shadowOpacity = 0.5;
    titleLayer.alignmentMode = kCAAlignmentCenter;
    titleLayer.frame = CGRectMake(0, -(4*aScale), backgroundLayer.frame.size.width, backgroundLayer.frame.size.height);
    
     [backgroundLayer addSublayer:titleLayer];
    
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    //    [parentLayer addSublayer:aLayer];
    [parentLayer addSublayer:backgroundLayer];
//    [parentLayer addSublayer:titleLayer]; //ONLY IF WE ADDED TEXT
    
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        isVideoAssetPortrait_  = NO;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        isVideoAssetPortrait_  = NO;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
//    mainCompositionInst.renderSize = videoSize;
//    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    mainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    mainCompositionInst.renderSize = naturalSize;
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    // 4 - Get path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"FinalVideo-%d.mov",arc4random() % 1000]];
//        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
//                                 [NSString stringWithFormat:@"FinalVideo.mov"]];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveVideo:exporter withDesinationPath:myPathDocs];
        });
    }];
}

-(void)saveVideo:(AVAssetExportSession*)exportSession withDesinationPath:(NSString *)destinationPath{
    
    switch (exportSession.status)
    {
        case AVAssetExportSessionStatusCompleted:
            NSLog(@"Export OK");
//            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationPath)) {
//                UISaveVideoAtPathToSavedPhotosAlbum(destinationPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//            }
//             NSURL *aURL = [NSURL fileURLWithPath:destinationPath];
             [self playVideoFullScreen:[NSURL fileURLWithPath:destinationPath]];
            break;
        case AVAssetExportSessionStatusFailed:
            NSLog (@"AVAssetExportSessionStatusFailed: %@", exportSession.error);
            break;
        case AVAssetExportSessionStatusCancelled:
            NSLog(@"Export Cancelled");
            break;
    }
}

-(void) video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error)
        NSLog(@"Finished saving video with error: %@", error);
    NSURL *aURL = [NSURL fileURLWithPath:videoPath];
    [self playVideoFullScreen:aURL];
}



-(void)playVideoFullScreen:(NSURL*)videoPathURL{
    
    // create an AVPlayer
    AVPlayer *player = [AVPlayer playerWithURL:videoPathURL];
    
    // create a player view controller
    //    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    //    controller.player = player;
    //    [player play];
    //    controller.view.frame = self.viewPlayer.frame;
    //    [self.viewPlayer addSubview:controller.view];
    
    // create a player view controller
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
    controller.player = player;
    [player play];
}

-(void)playVideo:(NSURL*)videoPathURL{
    
    
    // create an AVPlayer
    AVPlayer *player = [AVPlayer playerWithURL:videoPathURL];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    //player.volume = 0.0;
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = _imgThumbnail.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [viewPlayer.layer addSublayer:playerLayer];
    [player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

#pragma mark: - media finish picking delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // This is the NSURL of the video object
    videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
    //    get Thumbnail image from videoURL
    self.imgThumbnail.image = [self generateThumbImage:videoURL];
    
    //set video view Frame
//    if(viewPlayer != nil){
//        [viewPlayer removeFromSuperview];
//    }
//    viewPlayer = [[UIView alloc] init];
//    CGRect frame = viewPlayer.frame;
//    frame.size = [self CGSizeAspectFit:_imgThumbnail.image.size withBounding:_imgThumbnail.frame.size];
//    [viewPlayer setFrame:frame];
//    viewPlayer.center = _imgThumbnail.center;
//    [self.view addSubview:viewPlayer];
    
    
    [self playVideo:videoURL];
    
    NSLog(@"VideoURL = %@", videoURL);
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma Mark: Document Directory all Methods

-(NSString*)myDocumentsDirectory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
    
}

-(void) myDeleteFile:(NSString*) path{
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *deleteErr = nil;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&deleteErr];
        if (deleteErr) {
            NSLog (@"Can't delete %@: %@", path, deleteErr);
        }
    }
    
}

#pragma mark: Class Methods
-(CGSize)videoSizeFromURL:(NSURL*)mediaURL{
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:mediaURL options:nil];
    AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    CGSize dimensions = CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform);
    return dimensions;
}


-(UIImage *)generateThumbImage : (NSURL *)filepath
{
    
    AVAsset *asset = [AVAsset assetWithURL:filepath];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

-(CGSize) CGSizeAspectFit:(CGSize)aspectRatio withBounding:(CGSize)boundingSize
{
    float mW = boundingSize.width / aspectRatio.width;
    float mH = boundingSize.height / aspectRatio.height;
    if( mH < mW )
        boundingSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width;
    else if( mW < mH )
        boundingSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height;
    return boundingSize;
}
@end
