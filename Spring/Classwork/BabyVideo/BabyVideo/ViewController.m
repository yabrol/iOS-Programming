//
//  ViewController.m
//  BabyVideo
//
//  Created by Yukti on 2/9/15.
//  Copyright (c) 2015 Yukti. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *pickerController;
@property (strong, nonatomic) MPMoviePlayerViewController *playerViewController;
@property (strong, nonatomic) NSURL *movieFileURL;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"info:%@",info);
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        //show image in imageview
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        imageView.frame = CGRectMake(0, 0, 320, 320);
        [self.view addSubview:imageView];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            //show movie player
            self.movieFileURL = [info objectForKey:UIImagePickerControllerMediaURL];
            self.playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.movieFileURL];
            [self presentViewController:self.playerViewController animated:YES completion:nil];
        }];
    }
    
}

- (IBAction)getMediaButtonPressed:(id)sender {
    self.pickerController = [[UIImagePickerController alloc]init];
    self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;//take pics
    self.pickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//allow for video or still
    self.pickerController.delegate = self;//need to implement uiimagepickercontrollerdelegate and uinavigationcontrollerdelegate
    [self presentViewController:self.pickerController animated:YES completion:^{
        NSLog(@"image picker completed presenting");
    }];
    
    
}
- (IBAction)playVideoButtonPressed:(id)sender {
    
    self.playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.movieFileURL];
    [self presentViewController:self.playerViewController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
