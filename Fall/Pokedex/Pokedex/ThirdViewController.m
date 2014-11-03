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
    NSURL *theurl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"themesong" ofType:@"mov"]];
    
    self.moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:theurl];
    [self.moviePlayer.view setFrame:CGRectMake(40, 197, 240, 160)];
    [self.moviePlayer prepareToPlay];
    [self.moviePlayer setShouldAutoplay:NO]; // And other options you can look through the documentation.
    [self.view addSubview:self.moviePlayer.view];
    //5. To control what is to be done after playback:
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    //playBackFinished will be your own method.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
