//
//  ThirdViewController.m
//  Pokedex
//
//  Created by Yukti Abrol on 10/26/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "ThirdViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ThirdViewController ()

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"themesong" ofType:@"mov"]];
    
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


@end
