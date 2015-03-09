//
//  ViewController.m
//  VideoFun
//
//  Created by Tim Novikoff on 2/23/15.
//  Copyright (c) 2015 Tim Novikoff. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

typedef enum{
    VFRecordingStateUnknown,
    VFRecordingStateRecording,
    VFRecordingStateFinished
}VFRecordingState;

@interface ViewController () <AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;

@property (nonatomic) NSURL *fileURL;
@property (nonatomic, assign) VFRecordingState recordingState;

@property (nonatomic, assign) BOOL assetWriterVideoInputReady;

@property (nonatomic) AVAssetWriter *assetWriter;
@property (nonatomic) dispatch_queue_t assetWritingQueue;

@property (nonatomic) AVAssetWriterInput *writerInput;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *frontCamera;
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionFront) {
            frontCamera = device;
        }
    }
    AVCaptureDeviceInput *frontCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:frontCamera error:nil];
    [self.captureSession addInput:frontCameraInput];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
//    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
//    [self.captureSession addOutput:self.movieFileOutput];
    
    //
    self.fileURL = [[NSURL alloc] initFileURLWithPath:[NSString pathWithComponents:@[NSTemporaryDirectory(), @"myFilename.mp4"]]];
    
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];

    [videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    //it is important to set this pixel format type for our particular way of looping through the pixel buffer. the pixel processing method has to go hand in hand with teh pixel format type
    
    dispatch_queue_t videoDataDispatchQueue = dispatch_queue_create("edu.CS2049.videoDataOutputqueue", DISPATCH_QUEUE_SERIAL);
    
    [videoOutput setSampleBufferDelegate:self queue:videoDataDispatchQueue];
    
    [self.captureSession addOutput:videoOutput];
    
    self.assetWriter = [[AVAssetWriter alloc] initWithURL:self.fileURL fileType:AVFileTypeQuickTimeMovie error:nil];
    self.assetWritingQueue = dispatch_queue_create("edu.CS2049.assetWritingQueue", DISPATCH_QUEUE_SERIAL);
    
    
    //set the orientation of the video into the videoDataOutput connection
    for ( AVCaptureConnection *connection in videoOutput.connections ) {
        for ( AVCaptureInputPort *port in [connection inputPorts] ) {
            if ( [[port mediaType] isEqual:AVMediaTypeVideo] ) {
                connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            }
        }
    }
    
    
    [self.captureSession startRunning];
}
- (void) processPixelBuffer: (CVImageBufferRef) pixelBuffer{
    
    CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
    
    int bufferWidth = (int) CVPixelBufferGetWidth(pixelBuffer);
    int bufferHeight = (int) CVPixelBufferGetHeight(pixelBuffer);
    unsigned char *pixel = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
    
    int greenValue = 0;
    
    int bytesPerPixel = 4;
    for( int row = 0; row < bufferWidth; row++ ) {
        for( int column = 0; column < bufferHeight; column++ ) {
            pixel[1] = greenValue; // De-green (second pixel in BGRA is green)
            pixel = pixel + bytesPerPixel;
        }
    }
    
    CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
}
- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{

    NSLog(@"did receive sample buffer reference");
    
    // Synchronously process the pixel buffer to de-green it.
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    [self processPixelBuffer:pixelBuffer];
    
    //set up video input if it isn't ready yet
    if (!self.assetWriterVideoInputReady) {
        self.assetWriterVideoInputReady = [self setupVideoInput:CMSampleBufferGetFormatDescription(sampleBuffer)];
    }
    
    if (self.recordingState == VFRecordingStateRecording) {
        NSLog(@"we should write this frame to disk");
        
        if (self.assetWriter) {
            CFRetain(sampleBuffer);//needs to be retained otherwise it will be released before being written, since dispatch_async returns immediately
            //we do the release at the end of the async block below to make sure we have no memory leak here
            
            dispatch_async(self.assetWritingQueue, ^{
                if(self.assetWriter.status == AVAssetWriterStatusUnknown){//this is the first frame after user taps record
                    
                    if ([self.assetWriter startWriting]) {//if startWriting returns YES (which it won't if it was misconfigured)
                        CMTime startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
                        [self.assetWriter startSessionAtSourceTime:startTime];
                    }
                }
                if (self.assetWriter.status == AVAssetWriterStatusWriting){
                    
                    if(self.writerInput.isReadyForMoreMediaData){
                        NSLog(@"appending sample buffer");
                        [self.writerInput appendSampleBuffer:sampleBuffer];
                    }
                }
                CFRelease(sampleBuffer);
            });
        }
    }
}

- (BOOL) setupVideoInput: (CMFormatDescriptionRef) formatDescription{
    //do a bunch of stuff and return YES if/when the input has been added to the asset writer
    

    CMVideoDimensions videoDimensions = CMVideoFormatDescriptionGetDimensions(formatDescription);
    
    float bitsPerPixel;
    
    int numPixels = videoDimensions.width * videoDimensions.height;
    int bitsPerSecond;
    
    // Assume that lower-than-SD resolutions are intended for streaming, and use a lower bitrate
    if ( numPixels < (640 * 480) )
        bitsPerPixel = 4.05; // This bitrate matches the quality produced by AVCaptureSessionPresetMedium or Low.
    else
        bitsPerPixel = 11.4; // This bitrate matches the quality produced by AVCaptureSessionPresetHigh.
    
    bitsPerSecond = numPixels * bitsPerPixel;
    
    NSDictionary *outputSettings;
    outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                           
                                              AVVideoCodecH264, AVVideoCodecKey,
                           
                                              [NSNumber numberWithInteger:videoDimensions.width], AVVideoWidthKey,
                           
                                              [NSNumber numberWithInteger:videoDimensions.height], AVVideoHeightKey,
                           
                                              [NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSNumber numberWithInteger:bitsPerSecond], AVVideoAverageBitRateKey,
                                               [NSNumber numberWithInteger:30], AVVideoMaxKeyFrameIntervalKey,
                                               nil], AVVideoCompressionPropertiesKey,
                                              nil];
    
    self.writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:outputSettings];
    
    if ([self.assetWriter canAddInput:self.writerInput]) {
        NSLog(@"added input to asset writer");
        [self.assetWriter addInput:self.writerInput];
        return YES;
    }
    else{
        NSLog(@"could not add input to asset writer");
        return NO;
    }
    
    return NO;
}

- (IBAction)recordButtonPressed:(id)sender {
    NSLog(@"Record button pressed");
    
    //clear file url
    if([[NSFileManager defaultManager] fileExistsAtPath:self.fileURL.path]){
        [[NSFileManager defaultManager] removeItemAtURL:self.fileURL error:nil];
    }
    
//    [self.movieFileOutput startRecordingToOutputFileURL:self.fileURL recordingDelegate:self];
    
    self.recordingState = VFRecordingStateRecording;

}
- (IBAction)stopButtonPressed:(id)sender {
    NSLog(@"Stop button pressed");
//    [self.movieFileOutput stopRecording];
    self.recordingState = VFRecordingStateFinished;
    
    [self.assetWriter finishWritingWithCompletionHandler:^{
        NSLog(@"finished writing");
    }];
    [self.writerInput markAsFinished];

}
- (IBAction)playButtonPressed:(id)sender {
    NSLog(@"Play button pressed");
    
    MPMoviePlayerViewController *moviePlayerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:self.fileURL];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerVC];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
