//
//  GMViewController.m
//  GrabMedia
//
//  Created by Tim Novikoff on 2/8/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import "GMViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface GMViewController () <UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSURL *fileURL;

@end

@implementation GMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)getMediaButtonPressed:(id)sender {
    
    //instantiate the picker
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;//note that we have declared <UIImagePickerControllerDelegate, UINavigationControllerDelegate> above
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;//pick from camera, not saved photos or photo roll

    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];//allow for video or still
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker{//one of the two required delegate methods
    NSLog(@"canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {//the other of the two required delegate methods
    NSLog(@"picked");
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];//was it photo or video?
    
    if ([mediaType isEqualToString:@"public.image"]) {//if it was photo, add the photo
        
        UIImage *image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //resize the video so it fits on the screen nicely
        float w = image.size.width;
        float h = image.size.height;
        float r = h/w;
        UIGraphicsBeginImageContext( CGSizeMake(320, 320) );
        [image drawInRect:CGRectMake(0,0,320,320*r)];//using r like this ensures aspect ratio stays the same
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.imageView = [[UIImageView alloc] initWithImage:newImage];
        [self.view addSubview:self.imageView];
    }

    if ([mediaType isEqualToString:@"public.movie"]) {

        self.fileURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playVideoButtonPressed:(id)sender {//this app requires you to capture a video before playVideoButtonPressed does anythign useful.
    
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.fileURL];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];//note that this is a special function just for presenting MOVIE player view controllers.
}

@end
