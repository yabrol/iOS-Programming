//
//  MVViewController.m
//  MediumVideo
//
//  Created by Tim Novikoff on 2/8/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import "MVViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MVViewController () <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic, strong) NSURL *fileURL;


@end

@implementation MVViewController

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //setup capture session
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    
    //add input
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice;
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {//get the front facing camera
            captureDevice = device;
        }
    }
    AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:nil];
    [self.captureSession addInput:videoInput];
    
    //add previewLayer
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.frame = CGRectMake(0, 0, 320, 480);
    [self.view.layer addSublayer:self.previewLayer];

    //add output
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    [self.captureSession addOutput:self.movieFileOutput];
    
    //start it running
    [self.captureSession startRunning];
}
- (IBAction)playButtonPressed:(id)sender {//this app requires start then stop then play
    //play the movie, if there is one
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.fileURL];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
    [moviePlayerViewController.moviePlayer play];
}
- (IBAction)stopButtonPressed:(id)sender {//this app requires start then stop then play
    
    //note we don't actually have to stopRunning or removeFromSuperlayer
    [self.movieFileOutput stopRecording];
    [self.captureSession stopRunning];
    [self.previewLayer removeFromSuperlayer];
}
- (IBAction)startButtonPressed:(id)sender {//this app requires start then stop then play

    //boilerplate code for generating a filename in our app's directory
    NSString *rootPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [rootPath stringByAppendingPathComponent:@"test.mov"];
    self.fileURL = [[NSURL alloc] initFileURLWithPath:path];

    //we cannot write to a file where a file already exists, so delete one if there exists one
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        if ([fileManager isDeletableFileAtPath:path]) {
            [fileManager removeItemAtPath:path error:nil];
            NSLog(@"deleting file at path: %@", path);
        }
    }
    
    //start the recording
    [self.movieFileOutput startRecordingToOutputFileURL:self.fileURL recordingDelegate:self];
}
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{//a necessary delegate method that we don't actually have to do anything in.
    NSLog(@"recording finished");
}

@end
