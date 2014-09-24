//
//  MovieViewController.m
//  Menagerie
//
//  Created by Yukti Abrol on 9/23/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import "MovieViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MovieViewController ()

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)foxButtonPressed:(id)sender {
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"fox2" ofType:@"mov"]];
    
    //need to do self.movieplayer else it dereferences it
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [self.view addSubview:self.moviePlayer.view];
    
    //self.moviePlayer.fullscreen = YES;
    [self.moviePlayer setFullscreen:YES animated:YES];
    self.moviePlayer.shouldAutoplay = YES;
    
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
