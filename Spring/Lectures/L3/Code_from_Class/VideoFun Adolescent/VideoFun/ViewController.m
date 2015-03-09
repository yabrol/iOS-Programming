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

@interface ViewController () <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;

@property (nonatomic) NSURL *fileURL;

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
    
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    [self.captureSession addOutput:self.movieFileOutput];
    
    [self.captureSession startRunning];
}
- (IBAction)recordButtonPressed:(id)sender {
    NSLog(@"Record button pressed");
    
    //create and clear file url
    self.fileURL = [[NSURL alloc] initFileURLWithPath:[NSString pathWithComponents:@[NSTemporaryDirectory(), @"myFilename.mp4"]]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:self.fileURL.path]){
        [[NSFileManager defaultManager] removeItemAtURL:self.fileURL error:nil];
    }
    
    [self.movieFileOutput startRecordingToOutputFileURL:self.fileURL recordingDelegate:self];
}
- (IBAction)stopButtonPressed:(id)sender {
    NSLog(@"Stop button pressed");
    [self.movieFileOutput stopRecording];
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
