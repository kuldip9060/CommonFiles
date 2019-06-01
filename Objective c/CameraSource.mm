/*
 
 Video Core
 Copyright (c) 2014 James G. Hurley
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#include <videocore/sources/iOS/CameraSource.h>
#include <videocore/mixers/IVideoMixer.hpp>
#include <videocore/system/pixelBuffer/Apple/PixelBuffer.h>

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#import <AVFoundation/AVFoundation.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION  ([[[UIDevice currentDevice] systemVersion])


@interface sbCallback: NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    std::weak_ptr<videocore::iOS::CameraSource> m_source;
}
- (void) setSource:(std::weak_ptr<videocore::iOS::CameraSource>) source;
+ (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image;

@end

@implementation sbCallback
-(void) setSource:(std::weak_ptr<videocore::iOS::CameraSource>)source
{
    m_source = source;
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    auto source = m_source.lock();
    
    CVPixelBufferRef pixelBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    float aWidth = CVPixelBufferGetWidth(pixelBufferRef);
    float aHeight = CVPixelBufferGetHeight(pixelBufferRef);
    
    CGSize aSize = [[UIScreen mainScreen]bounds].size;
    
    
    
    UIImage *aImage;
   /* if (aSize.width<aSize.height && aWidth>aHeight) {
        aImage = [self imageFromSampleBuffer:sampleBuffer];
        
        UIImage *aNewImage = [self imageScaledToFitToSize:CGSizeMake(aSize.width, aSize.height) withUIImage:aImage];
        CVPixelBufferRef aBufferRef = [self pixelBufferFromCGImage:aNewImage.CGImage];
        if(source) {
            source->bufferCaptured(aBufferRef,aImage);
        }

    }
    else if (aSize.width>aSize.height && aWidth<aHeight) {
        aImage = [self imageFromSampleBuffer:sampleBuffer];
        
        UIImage *aNewImage = [self imageScaledToFitToSize:CGSizeMake(aSize.width, aSize.height) withUIImage:aImage];
        CVPixelBufferRef aBufferRef = [self pixelBufferFromCGImage:aNewImage.CGImage];
        if(source) {
            source->bufferCaptured(aBufferRef,aImage);
        }
    }
    else
    {*/
        if(source) {
            source->bufferCaptured(pixelBufferRef,aImage);
        }

  //  }
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image
{
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image),
                                  CGImageGetHeight(image));
    NSDictionary *options =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithBool:YES],
     kCVPixelBufferCGImageCompatibilityKey,
     [NSNumber numberWithBool:YES],
     kCVPixelBufferCGBitmapContextCompatibilityKey,
     nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status =
    CVPixelBufferCreate(
                        kCFAllocatorDefault, frameSize.width, frameSize.height,
                        kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef)options,
                        &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(
                                                 pxdata, frameSize.width, frameSize.height,
                                                 8, CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGBitmapByteOrder32Little |
                                                 kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (UIImage *)imageScaledToFitToSize:(CGSize)size withUIImage:(UIImage *)aImage
{
    CGRect scaledRect = AVMakeRectWithAspectRatioInsideRect(aImage.size, CGRectMake(0, 0, size.width, size.height));
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen]scale]);
    [aImage drawInRect:scaledRect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}



- (void) captureOutput:(AVCaptureOutput *)captureOutput
   didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer
        fromConnection:(AVCaptureConnection *)connection
{
}
- (void) orientationChanged: (NSNotification*) notification
{
    auto source = m_source.lock();
    if(source && !source->orientationLocked()) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            source->reorientCamera();
        });
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    auto source = m_source.lock();
    
    if ([keyPath isEqualToString:@"status"] && [source->playerVideo isEqual:object]) {
        source->startAudioRecording();
    }
}

@end
namespace videocore { namespace iOS {
    

    
    CameraSource::CameraSource()
    :
    m_captureDevice(nullptr),
    m_callbackSession(nullptr),
    m_previewLayer(nullptr),
    m_matrix(glm::mat4(1.f)),
    m_orientationLocked(false),
    m_torchOn(false),
    m_useInterfaceOrientation(false),
    m_captureSession(nullptr)
    {}
    
    CameraSource::~CameraSource()
    {
        
        if(m_captureSession) {
            [((AVCaptureSession*)m_captureSession) stopRunning];
            [((AVCaptureSession*)m_captureSession) release];
        }
        if(m_callbackSession) {
            [[NSNotificationCenter defaultCenter] removeObserver:(id)m_callbackSession];
            [((sbCallback*)m_callbackSession) release];
        }
        if(m_previewLayer) {
            [(id)m_previewLayer release];
        }
    }
    
    void
    CameraSource::setupCamera(int fps, bool useFront, bool useInterfaceOrientation, NSString* sessionPreset, void (^callbackBlock)(void))
    {
        m_fps = fps;
        m_useInterfaceOrientation = useInterfaceOrientation;
        boolISVideoStarted = NO;
        __block CameraSource* bThis = this;
        
        void (^permissions)(BOOL) = ^(BOOL granted) {
            @autoreleasepool {
                if(granted) {
                    
                    int position = useFront ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
                    
                    AVCaptureDevicePosition cameraposition = (AVCaptureDevicePosition)position;

                    NSArray* devices ;
                    float aDeviceVersion =  [[[UIDevice currentDevice] systemVersion]floatValue];
                    if (aDeviceVersion>=10.0) {
                        AVCaptureDeviceDiscoverySession *aSession =  [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:cameraposition];
                        devices = aSession.devices;
                    }
                    else
                    {
                        devices = [AVCaptureDevice devices];
                    }

                    
                    for(AVCaptureDevice* d in devices) {
                        if([d hasMediaType:AVMediaTypeVideo] && [d position] == position)
                        {
                            bThis->m_captureDevice = d;
                            NSError* error;
                            [d lockForConfiguration:&error];
                            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                                [d setActiveVideoMinFrameDuration:CMTimeMake(1, fps)];
                                [d setActiveVideoMaxFrameDuration:CMTimeMake(1, fps)];
                            }
                            [d unlockForConfiguration];
                        }
                    }
                    
                    AVCaptureSession* session = [[AVCaptureSession alloc] init];
                    
                    
                    session.sessionPreset = boolIsGoodSpeedAvailable?AVCaptureSessionPresetiFrame1280x720:AVCaptureSessionPresetiFrame960x540;
                    
                   // [session setSessionPreset:AVCaptureSessionPresetiFrame1280x720];
                    AVCaptureDeviceInput* input;
                    AVCaptureVideoDataOutput* output;
                    if(sessionPreset) {
                        session.sessionPreset = (NSString*)sessionPreset;
                    }
                    bThis->m_captureSession = session;
                    
                    input = [AVCaptureDeviceInput deviceInputWithDevice:((AVCaptureDevice*)m_captureDevice) error:nil];
                    
                    output = [[AVCaptureVideoDataOutput alloc] init] ;
                    
                    output.videoSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA) };
                    
                    if(!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                        AVCaptureConnection* conn = [output connectionWithMediaType:AVMediaTypeVideo];
                        if([conn isVideoMinFrameDurationSupported]) {
                            [conn setVideoMinFrameDuration:CMTimeMake(1, fps)];
                        }
                        if([conn isVideoMaxFrameDurationSupported]) {
                            [conn setVideoMaxFrameDuration:CMTimeMake(1, fps)];
                        }
                    }
                    if(!bThis->m_callbackSession) {
                        bThis->m_callbackSession = [[sbCallback alloc] init];
                        [((sbCallback*)bThis->m_callbackSession) setSource:shared_from_this()];
                    }
                    dispatch_queue_t camQueue = dispatch_queue_create("com.videocore.camera", 0);
                    
                    [output setSampleBufferDelegate:((sbCallback*)bThis->m_callbackSession) queue:camQueue];
                    
                    dispatch_release(camQueue);
                    
                    if([session canAddInput:input]) {
                        [session addInput:input];
                    }
                    if([session canAddOutput:output]) {
                        [session addOutput:output];
                        
                    }
                    
                    reorientCamera();
                    videoSessionStartDate = [[NSDate date]retain];
                    
                    //Video Recording started
                 
                    
                    //Video recording ended
                    [session startRunning];
                    
                    if(!bThis->m_orientationLocked) {
                        if(bThis->m_useInterfaceOrientation) {
                            [[NSNotificationCenter defaultCenter] addObserver:((id)bThis->m_callbackSession) selector:@selector(orientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
                        } else {
                            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
                            [[NSNotificationCenter defaultCenter] addObserver:((id)bThis->m_callbackSession) selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
                        }
                    }
                    [output release];
                }
                if (callbackBlock) {
                    callbackBlock();
                }
            }
        };
        @autoreleasepool {
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                AVAuthorizationStatus auth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                
                if(auth == AVAuthorizationStatusAuthorized || !SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                    permissions(true);
                }
                else if(auth == AVAuthorizationStatusNotDetermined) {
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:permissions];
                }
            } else {
                permissions(true);
            }
            
        }
    }

    void
    CameraSource::getPreviewLayer(void** outAVCaptureVideoPreviewLayer)
    {
        if(!m_previewLayer) {
            @autoreleasepool {
                AVCaptureSession* session = (AVCaptureSession*)m_captureSession;
                AVCaptureVideoPreviewLayer* previewLayer;
                previewLayer = [[AVCaptureVideoPreviewLayer layerWithSession:session] retain];
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                m_previewLayer = previewLayer;
            }
        }
        if(outAVCaptureVideoPreviewLayer) {
            *outAVCaptureVideoPreviewLayer = m_previewLayer;
        }
    }
    void*
    CameraSource::cameraWithPosition(int pos)
    {
        AVCaptureDevicePosition position = (AVCaptureDevicePosition)pos;
        
        float aDeviceVersion =  [[[UIDevice currentDevice] systemVersion]floatValue];
        if (aDeviceVersion>=10.0) {
            AVCaptureDeviceDiscoverySession *aSession =  [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
            for (AVCaptureDevice *device in aSession.devices)
            {
                if ([device position] == position) return device;
            }
        }
        else
        {
            NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
            for (AVCaptureDevice *device in devices)
            {
                if ([device position] == position) return device;
            }
        }
        
        
        
       
        return nil;
        
    }
    bool
    CameraSource::orientationLocked()
    {
        return m_orientationLocked;
    }
    void
    CameraSource::setOrientationLocked(bool orientationLocked)
    {
        m_orientationLocked = orientationLocked;
    }
    bool
    CameraSource::setTorch(bool torchOn)
    {
        bool ret = false;
        if(!m_captureSession) return ret;
        
        AVCaptureSession* session = (AVCaptureSession*)m_captureSession;
        
        [session beginConfiguration];
        AVCaptureDeviceInput* currentCameraInput = [session.inputs objectAtIndex:0];
        
        if(currentCameraInput.device.torchAvailable) {
            NSError* err = nil;
            if([currentCameraInput.device lockForConfiguration:&err]) {
                [currentCameraInput.device setTorchMode:( torchOn ? AVCaptureTorchModeOn : AVCaptureTorchModeOff ) ];
                [currentCameraInput.device unlockForConfiguration];
                ret = (currentCameraInput.device.torchMode == AVCaptureTorchModeOn);
            } else {
                NSLog(@"Error while locking device for torch: %@", err);
                ret = false;
            }
        } else {
            NSLog(@"Torch not available in current camera input");
        }
        [session commitConfiguration];
        m_torchOn = ret;
        return ret;
    }
    void
    CameraSource::toggleCamera()
    {
        
        if(!m_captureSession) return;
        
        NSError* error;
        AVCaptureSession* session = (AVCaptureSession*)m_captureSession;
        if(session) {
            [session beginConfiguration];
            [(AVCaptureDevice*)m_captureDevice lockForConfiguration: &error];
            
            AVCaptureInput* currentCameraInput = [session.inputs objectAtIndex:0];
            
            [session removeInput:currentCameraInput];
            [(AVCaptureDevice*)m_captureDevice unlockForConfiguration];
            
            AVCaptureDevice *newCamera = nil;
            if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
            {
                newCamera = (AVCaptureDevice*)cameraWithPosition(AVCaptureDevicePositionFront);
            }
            else
            {
                newCamera = (AVCaptureDevice*)cameraWithPosition(AVCaptureDevicePositionBack);
            }
            
            AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:nil];
            [newCamera lockForConfiguration:&error];
            [session addInput:newVideoInput];
            
            m_captureDevice = newCamera;
            [newCamera unlockForConfiguration];
            [session commitConfiguration];
            
            [newVideoInput release];
            
            reorientCamera();
        }
    }
    
    void
    CameraSource::reorientCamera()
    {
        if(!m_captureSession) return;
        
        auto orientation = m_useInterfaceOrientation ? [[UIApplication sharedApplication] statusBarOrientation] : [[UIDevice currentDevice] orientation];
        
        // use interface orientation as fallback if device orientation is facedown, faceup or unknown
        if(orientation==UIDeviceOrientationFaceDown || orientation==UIDeviceOrientationFaceUp || orientation==UIDeviceOrientationUnknown) {
            orientation =[[UIApplication sharedApplication] statusBarOrientation];
        }
        
        //bool reorient = false;
        
        AVCaptureSession* session = (AVCaptureSession*)m_captureSession;
        // [session beginConfiguration];
        
        for (AVCaptureVideoDataOutput* output in session.outputs) {
            for (AVCaptureConnection * av in output.connections) {
                
                NSLog(@"Orientation:%i",orientation);
                
                switch (orientation) {
                        // UIInterfaceOrientationPortraitUpsideDown, UIDeviceOrientationPortraitUpsideDown
                    case UIInterfaceOrientationPortraitUpsideDown:
                        if(av.videoOrientation != AVCaptureVideoOrientationPortraitUpsideDown) {
                            av.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                        //    reorient = true;
                        }
                        break;
                        // UIInterfaceOrientationLandscapeRight, UIDeviceOrientationLandscapeLeft
                    case UIInterfaceOrientationLandscapeRight:
                        if(av.videoOrientation != AVCaptureVideoOrientationLandscapeRight) {
                            av.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                        //    reorient = true;
                        }
                        break;
                        // UIInterfaceOrientationLandscapeLeft, UIDeviceOrientationLandscapeRight
                    case UIInterfaceOrientationLandscapeLeft:
                        if(av.videoOrientation != AVCaptureVideoOrientationLandscapeLeft) {
                            av.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
                         //   reorient = true;
                        }
                        break;
                        // UIInterfaceOrientationPortrait, UIDeviceOrientationPortrait
                    case UIInterfaceOrientationPortrait:
                        if(av.videoOrientation != AVCaptureVideoOrientationPortrait) {
                            av.videoOrientation = AVCaptureVideoOrientationPortrait;
                        //    reorient = true;
                        }
                        break;
                    default:
                        break;
                }
            }
        }

        //[session commitConfiguration];
        if(m_torchOn) {
            setTorch(m_torchOn);
        }
    }
    void
    CameraSource::setOutput(std::shared_ptr<IOutput> output)
    {
        m_output = output;
        //auto mixer = std::static_pointer_cast<IVideoMixer>(output);
    }
    void
    CameraSource::bufferCaptured(CVPixelBufferRef pixelBufferRef, UIImage *aImage)
    {
        __block CameraSource* bThis = this;

        auto output = m_output.lock();
        if(output) {
            
            VideoBufferMetadata md(1.f / float(m_fps));
            
            md.setData(1, m_matrix, false, shared_from_this());
            
            auto pixelBuffer = std::make_shared<Apple::PixelBuffer>(pixelBufferRef, true);
            
            output->pushBuffer((uint8_t*)&pixelBuffer, sizeof(pixelBuffer), md);
            
            AVAssetWriter *aWriter  = (AVAssetWriter *)bThis->m_assetWriter;
            AVAssetWriterInput *aInputWriter  = (AVAssetWriterInput *)bThis->m_assetInputWriter;
            AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor = (AVAssetWriterInputPixelBufferAdaptor *)bThis->m_pixelBuffer;
            
            ///static int64_t frameNumber = 0;
            
            if (boolISVideoStarted) {
                if (aInputWriter.readyForMoreMediaData) {
                    
                    CGSize aSize = [[UIScreen mainScreen]bounds].size;
                    
                    if (aImage!=nil) {
                        
                     //   CVPixelBufferRef aPixelBufferRef = [((sbCallback*)m_callbackSession) pixelBufferFromCGImage:aImage.CGImage];
 
                    }

                    if (pixelBufferAdaptor) {
                        [pixelBufferAdaptor appendPixelBuffer:pixelBufferRef withPresentationTime:CMTimeMake(bufferFrame, 30)];

                    }
                    
                }
               // frameNumber++;
                bufferFrame++;
                
            }
            
        }
    }
    
    
  
    
    void
    CameraSource:: startVideoRecording()
    {
        
        __block CameraSource* bThis = this;

        strCurrentVideo = nil;

        strCurrentVideo = [[NSString alloc]initWithFormat:@"%s",bThis->createTimeStamp().c_str()];

        CGRect aRect = [[UIScreen mainScreen]bounds];
        
        NSDictionary *outputSettings =
        [NSDictionary dictionaryWithObjectsAndKeys:
         
         [NSNumber numberWithInt:aRect.size.width], AVVideoWidthKey,
         [NSNumber numberWithInt:aRect.size.height], AVVideoHeightKey,
         AVVideoCodecH264, AVVideoCodecKey,
         
         nil];
        
        AVAssetWriterInput *assetWriterInput = [[AVAssetWriterInput
                                                 assetWriterInputWithMediaType:AVMediaTypeVideo
                                                 outputSettings:outputSettings]retain];
        
        /* I'm going to push pixel buffers to it, so will need a
         AVAssetWriterPixelBufferAdaptor, to expect the same 32BGRA input as I've
         asked the AVCaptureVideDataOutput to supply */
        AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor =
        [[AVAssetWriterInputPixelBufferAdaptor alloc]
         initWithAssetWriterInput:assetWriterInput
         sourcePixelBufferAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithInt:kCVPixelFormatType_32BGRA],
          kCVPixelBufferPixelFormatTypeKey,
          nil]];
        
        /* that's going to go somewhere, I imagine you've got the URL for that sorted,
         so create a suitable asset writer; we'll put our H.264 within the normal
         MPEG4 container */
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = paths.firstObject;
        NSString *aStrFilePath = [basePath stringByAppendingString:[NSString stringWithFormat:@"/%@.mp4",strCurrentVideo]];
        
        
        AVAssetWriter *assetWriter = [[AVAssetWriter alloc]
                                      initWithURL:[NSURL fileURLWithPath:aStrFilePath]
                                      fileType:AVFileTypeMPEG4
                                      error:nil];
        [assetWriter addInput:assetWriterInput];
        assetWriterInput.expectsMediaDataInRealTime = YES;
        bThis->m_assetWriter = assetWriter;
        bThis->m_assetInputWriter = assetWriterInput;
        
        bThis->m_pixelBuffer = pixelBufferAdaptor;

       /* if (videoStartDate!=nil) {
            [videoStartDate release];
            videoStartDate = nil;
        }*/
        videoStartDate = [[NSDate date]retain];
        NSTimeInterval aVideoInterval = [[NSDate date]timeIntervalSinceDate:videoSessionStartDate];
        
        bufferFrame = 0;
        [m_assetWriter startWriting];
        [m_assetWriter startSessionAtSourceTime:kCMTimeZero];

        AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:aStrFilePath]];
        
        playerVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        [playerVideo addObserver:((id)bThis->m_callbackSession) forKeyPath:@"status" options:0 context:nil];
        [playerVideo play];
        
        boolISVideoStarted = YES;
    }
    
    std::string CameraSource:: createTimeStamp()
    {
      NSString *strTimeStamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
        
        std::string stdTimeStamp  = ([strTimeStamp UTF8String]);
        
        return stdTimeStamp;
    }
   
    
    std::string CameraSource:: stopVideoRecording()
    {
        __block CameraSource* bThis = this;
        NSString *strTimeStamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
        strCurrentOutputVideo = [strTimeStamp retain];
        
        if (boolISVideoStarted) {
            
            
            NSTimeInterval aVideoInterval = [[NSDate date]timeIntervalSinceDate:videoStartDate];
            NSLog(@"TimeDuration : %f",aVideoInterval);

            [m_assetWriter endSessionAtSourceTime:CMTimeMake(aVideoInterval*30,30)];
            boolISVideoStarted = NO;

            [m_assetWriter finishWritingWithCompletionHandler:^{
                
                NSLog(@"Completed");

                AVAssetWriter *aWriter  = (AVAssetWriter *)bThis->m_assetWriter;
                [recorder stop];
                bThis->mergeAudioAndVideo(strCurrentOutputVideo);
                [m_assetWriter release];
                m_assetWriter = nil;
                
                [m_pixelBuffer release];
                m_pixelBuffer = nil;
                boolISVideoStarted = NO;
               
                [m_assetInputWriter release];
                 m_assetInputWriter = nil;
            }];
            
            [playerVideo removeObserver:((id)bThis->m_callbackSession) forKeyPath:@"status"];
            
        }
        
        std::string stdString = [strCurrentOutputVideo UTF8String];
        return stdString;
    }
    
    void
    CameraSource:: startAudioRecording()
    {
        /*NSDictionary *recordSettings = [NSDictionary
                                        dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:AVAudioQualityMin],
                                        AVEncoderAudioQualityKey,
                                        [NSNumber numberWithInt:16],
                                        AVEncoderBitRateKey,
                                        [NSNumber numberWithInt: 2],
                                        AVNumberOfChannelsKey,
                                        [NSNumber numberWithFloat:44100.0],
                                        AVSampleRateKey,
                                        nil];*/
        NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                        [NSNumber numberWithFloat:16000.0], AVSampleRateKey,
                                        [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                        nil];
        NSError* error;
        __block CameraSource* bThis = this;
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = paths.firstObject;
        
        NSString *aStrFilePath = [basePath stringByAppendingString:[NSString stringWithFormat:@"/%@.m4a",strCurrentVideo]];
        
        NSURL *audioPathURL = [NSURL fileURLWithPath:aStrFilePath];
        
        [[NSFileManager defaultManager]removeItemAtURL:audioPathURL error:nil];
        
        recorder = [[AVAudioRecorder alloc] initWithURL:audioPathURL settings:recordSettings error:&error];
        [recorder prepareToRecord];
        [recorder record];
        
        NSLog(@"Recording Started");
        
    }
    
    
    void
    CameraSource:: mergeAudioAndVideo(NSString* aVideoName)
    {
        //  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
        
        
        __block CameraSource* bThis = this;
        
        AVMutableComposition *mixComposition = [AVMutableComposition composition];
        
        NSArray *aDocumentpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = aDocumentpaths.firstObject;
       
        NSString *aStrFilePath = [basePath stringByAppendingString:[NSString stringWithFormat:@"/%@.mp4",strCurrentVideo]];
        NSURL    *video_inputFileUrl = [NSURL fileURLWithPath:aStrFilePath];
        
        NSString *aStrFileAudioPath = [basePath stringByAppendingString:[NSString stringWithFormat:@"/%@.m4a",strCurrentVideo]];

        NSURL *audioPathURL = [NSURL fileURLWithPath:aStrFileAudioPath];
        NSURL    *audio_inputFileUrl = audioPathURL;
        
        //NSString* path = [NSString stringWithFormat:@"%@/Output.mp4",basePath];
        NSString* path = [NSString stringWithFormat:@"%@/%@.mp4",basePath,aVideoName];
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
        [b_compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:nextClipStartTime error:&error];
        
        AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetPassthrough];
        assetExport.outputFileType = @"public.mpeg-4";
        assetExport.outputURL = [NSURL fileURLWithPath:path];
        
        [assetExport exportAsynchronouslyWithCompletionHandler:
         ^(void ) {
             if (assetExport.status == AVAssetExportSessionStatusCompleted) {
                 
                 [[NSFileManager defaultManager]removeItemAtURL:audio_inputFileUrl error:nil];
                 [[NSFileManager defaultManager]removeItemAtURL:video_inputFileUrl error:nil];
                 
                 BOOL aAttributeAdded =  bThis->addSkipBackupAttributeToItemAtPath(path);                 
                 //Write Code Here to Continue
             }
             else {
                 //Write Fail Code here
             }
         }
         ];
        
    }
    
    
    bool
    CameraSource:: addSkipBackupAttributeToItemAtPath(NSString * filePathString)
    {
        NSURL* URL= [NSURL fileURLWithPath: filePathString];
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }
    
    bool
    CameraSource::setContinuousAutofocus(bool wantsContinuous)
    {
        AVCaptureDevice* device = (AVCaptureDevice*)m_captureDevice;
        AVCaptureFocusMode newMode = wantsContinuous ?  AVCaptureFocusModeContinuousAutoFocus : AVCaptureFocusModeAutoFocus;
        bool ret = [device isFocusModeSupported:newMode];

        if(ret) {
            NSError *err = nil;
            if ([device lockForConfiguration:&err]) {
                device.focusMode = newMode;
                [device unlockForConfiguration];
            } else {
                NSLog(@"Error while locking device for autofocus: %@", err);
                ret = false;
            }
        } else {
            NSLog(@"Focus mode not supported: %@", wantsContinuous ? @"AVCaptureFocusModeContinuousAutoFocus" : @"AVCaptureFocusModeAutoFocus");
        }

        return ret;
    }

    bool
    CameraSource::setContinuousExposure(bool wantsContinuous) {
        AVCaptureDevice *device = (AVCaptureDevice *) m_captureDevice;
        AVCaptureExposureMode newMode = wantsContinuous ? AVCaptureExposureModeContinuousAutoExposure : AVCaptureExposureModeAutoExpose;
        bool ret = [device isExposureModeSupported:newMode];

        if(ret) {
            NSError *err = nil;
            if ([device lockForConfiguration:&err]) {
                device.exposureMode = newMode;
                [device unlockForConfiguration];
            } else {
                NSLog(@"Error while locking device for exposure: %@", err);
                ret = false;
            }
        } else {
            NSLog(@"Exposure mode not supported: %@", wantsContinuous ? @"AVCaptureExposureModeContinuousAutoExposure" : @"AVCaptureExposureModeAutoExpose");
        }

        return ret;
    }
    
    bool
    CameraSource::setFocusPointOfInterest(float x, float y)
    {
        AVCaptureDevice* device = (AVCaptureDevice*)m_captureDevice;
        bool ret = device.focusPointOfInterestSupported;
        
        if(ret) {
            NSError* err = nil;
            if([device lockForConfiguration:&err]) {
                [device setFocusPointOfInterest:CGPointMake(x, y)];
                device.focusMode = device.focusMode;
                [device unlockForConfiguration];
            } else {
                NSLog(@"Error while locking device for focus POI: %@", err);
                ret = false;
            }
        } else {
            NSLog(@"Focus POI not supported");
        }
        
        return ret;
    }
    
    bool
    CameraSource::setExposurePointOfInterest(float x, float y)
    {
        AVCaptureDevice* device = (AVCaptureDevice*)m_captureDevice;
        bool ret = device.exposurePointOfInterestSupported;
        
        if(ret) {
            NSError* err = nil;
            if([device lockForConfiguration:&err]) {
                [device setExposurePointOfInterest:CGPointMake(x, y)];
                device.exposureMode = device.exposureMode;
                [device unlockForConfiguration];
            } else {
                NSLog(@"Error while locking device for exposure POI: %@", err);
                ret = false;
            }
        } else {
            NSLog(@"Exposure POI not supported");
        }
        
        return ret;
    }
    
}
}
