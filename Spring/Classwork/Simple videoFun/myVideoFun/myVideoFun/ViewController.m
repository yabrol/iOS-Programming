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
    AVCaptureDeviceInput *frontCamInput = [[AVCaptureDeviceInput alloc] initWithDevice:frontCamera error:nil];
    [self.captureSession addInput:frontCamInput];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc]init];
    [self.captureSession addOutput:self.movieFileOutput];
    
    
    [self.captureSession startRunning]; //show preview of what camera sees
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)recordButtonPressed:(id)sender {
    NSLog(@"record");
    
    self.fileURL = [[NSURL alloc] initFileURLWithPath:[NSString pathWithComponents:@[NSTemporaryDirectory(), @"myFilename.mp4"]]];
    //this wont overwrite previous file so have to manually delete
    if([[NSFileManager defaultManager] fileExistsAtPath:self.fileURL.path]){
        [[NSFileManager defaultManager] removeItemAtURL:self.fileURL error:nil];
    }
    
    [self.movieFileOutput startRecordingToOutputFileURL:self.fileURL recordingDelegate:self];
    
}
- (IBAction)stopButtonPressed:(id)sender {
    NSLog(@"stop");
    [self.movieFileOutput stopRecording];
}
- (IBAction)playButtonPressed:(id)sender {
    NSLog(@"play");
    
    MPMoviePlayerViewController *moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:self.fileURL];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerVC];
}

- (void) captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
}

@end
