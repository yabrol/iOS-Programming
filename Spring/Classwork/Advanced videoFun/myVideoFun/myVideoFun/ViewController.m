//
//  ViewController.m
//  myVideoFun
//
//  Created by Yukti on 2/23/15.
//  Copyright (c) 2015 Yukti. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

typedef enum{
    VFRecordingStateUnknown,
    VFRecordingStateRecording,
    VFRecordingStateFinished
} VFRecordingState;

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
    
    self.fileURL = [[NSURL alloc] initFileURLWithPath:[NSString pathWithComponents:@[NSTemporaryDirectory(), @"myFilename.mp4"]]];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *frontCamera;
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionFront) {
            frontCamera = device;
        }
    }
    AVCaptureDeviceInput *frontCamInput = [[AVCaptureDeviceInput alloc] initWithDevice:frontCamera error:nil];
    [self.captureSession addInput:frontCamInput];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
//    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc]init];
//    [self.captureSession addOutput:self.movieFileOutput];
    
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    [videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    
    dispatch_queue_t videoDataDispatchQueue = dispatch_queue_create("edu.CS2049.videoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    
    [videoOutput setSampleBufferDelegate:self queue:videoDataDispatchQueue];
    
    [self.captureSession addOutput:videoOutput];
    
    self.assetWriter = [[AVAssetWriter alloc] initWithURL:self.fileURL fileType:AVFileTypeQuickTimeMovie error:nil];
    self.assetWritingQueue = dispatch_queue_create("edu.CS2049.assetWritingQueue", DISPATCH_QUEUE_SERIAL);
    
    for( AVCaptureConnection *connection in videoOutput.connections){
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            }
        }
    }
    
    [self.captureSession startRunning]; //show preview of what camera sees
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)recordButtonPressed:(id)sender {
    NSLog(@"record");
    
    //this wont overwrite previous file so have to manually delete
    if([[NSFileManager defaultManager] fileExistsAtPath:self.fileURL.path]){
        [[NSFileManager defaultManager] removeItemAtURL:self.fileURL error:nil];
    }
    
    //[self.movieFileOutput startRecordingToOutputFileURL:self.fileURL recordingDelegate:self];
    self.recordingState = VFRecordingStateRecording;
    
}
- (IBAction)stopButtonPressed:(id)sender {
    NSLog(@"stop");
    //[self.movieFileOutput stopRecording];
    self.recordingState = VFRecordingStateFinished;
    
    [self.assetWriter finishWritingWithCompletionHandler:^{
        NSLog(@"finished writing");
    }];
    [self.writerInput markAsFinished];
}
- (IBAction)playButtonPressed:(id)sender {
    NSLog(@"play");
    
    MPMoviePlayerViewController *moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:self.fileURL];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerVC];
}

- (void) captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
}

- (void) processPixelBuffer: (CVImageBufferRef) pixelBuffer{
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    int bufferWidth = (int) CVPixelBufferGetWidth(pixelBuffer);
    int bufferHeight = (int) CVPixelBufferGetHeight(pixelBuffer);
    unsigned char *pixel = (unsigned char *) CVPixelBufferGetBaseAddress(pixelBuffer);
    
    int greenValue = 0;
    
    int bytesPerPixel = 4;
    for (int row = 0; row < bufferWidth; row++) {
        for (int col = 0; col < bufferHeight; col++) {
            pixel[1] = greenValue;
            pixel = pixel + bytesPerPixel;
        }
    }
    
}

- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"did recieve sample buffer ref");
    
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    [self processPixelBuffer:pixelBuffer];
    
    if(!self.assetWriterVideoInputReady){
        self.assetWriterVideoInputReady = [self setupVideoInput:CMSampleBufferGetFormatDescription(sampleBuffer)];
    }
    
    if (self.recordingState == VFRecordingStateRecording) {
        NSLog(@"we should write this frame to disk");
        
        if(self.assetWriter){
            CFRetain(sampleBuffer);
            dispatch_async(self.assetWritingQueue, ^{
                if (self.assetWriter.status == AVAssetWriterStatusUnknown) {
                    if ([self.assetWriter startWriting]) {
                        CMTime startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
                        [self.assetWriter startSessionAtSourceTime:startTime];
                    }
                }
                if(self.assetWriter.status == AVAssetWriterStatusWriting){
                    if (self.writerInput.isReadyForMoreMediaData) {
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
    
    //return yes if input has been added to asset writer
    self.assetWriter = [[AVAssetWriter alloc] initWithURL:self.fileURL fileType:AVFileTypeQuickTimeMovie error:nil];
    self.assetWritingQueue = dispatch_queue_create("edu.CS2049.assetWritingQueue", DISPATCH_QUEUE_SERIAL);
    
    CMVideoDimensions videoDimensions = CMVideoFormatDescriptionGetDimensions(formatDescription);
    
    float bitsPerPixel;
    int numPixels = videoDimensions.width * videoDimensions.height;
    int bitsPerSecond;
    
    if (numPixels < (640*480)){
        bitsPerPixel = 4.05; //med/low quality
    }
    else{
        bitsPerPixel = 11.4; //high qual
    }
    
    bitsPerSecond = numPixels * bitsPerPixel;
    
    NSDictionary *outputSettings;
    outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                           AVVideoCodecH264, AVVideoCodecKey,
                           [NSNumber numberWithInteger:videoDimensions.width], AVVideoWidthKey,
                           [NSNumber numberWithInteger:videoDimensions.height], AVVideoHeightKey,
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInteger:bitsPerSecond], AVVideoAverageBitRateKey,
                            [NSNumber numberWithInteger:30], AVVideoMaxKeyFrameIntervalKey, nil], AVVideoCompressionPropertiesKey, nil];
    
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:outputSettings];
    
    if ([self.assetWriter canAddInput:writerInput]) {
        NSLog(@"added input to asset writer");
        [self.assetWriter addInput:writerInput];
        return YES;
    }
    else {
        NSLog(@"could not add input to asset writer");
        return NO;
    }
    
    return NO;
}

@end
