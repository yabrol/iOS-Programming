//
//  ViewController.m
//  AL
//
//  Created by Jordan Whitney on 9/27/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)loadView {
    
    //we create the view to be used by this view controller
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //we create and add all the subviews to place on the view
    
    //create the title label to have its content centered, bold, and 22 pt size
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.text = @"I <3 Cornell University";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //get the image from our bundle. The image must be in the project and added to the target
    //this is done by having "copy files" checked when dragging and dropping
    //and checking the AutoLayout target
    UIImage *cornellLogoImage = [UIImage imageNamed:@"cornell"]; //the .png extension is not required
    
    //use the image in the image view
    UIImageView *imageView = [[UIImageView alloc] initWithImage:cornellLogoImage];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    //create the text label to have left aligned content, and be 12 pt
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.text = @"Cornell University was founded on April 27, 1865, as the result of a New York State (NYS) Senate bill that named the university as the state's land grant institution. Senator Ezra Cornell offered his farm in Ithaca, New York as a site and $500,000 of his personal fortune as an initial endowment. Fellow senator and experienced educator Andrew Dickson White agreed to be the first president. During the next three years, White oversaw the construction of the initial two buildings and traveled around the globe to attract students and faculty.";
    [self.view addSubview:textLabel];
    self.textLabel = textLabel;
    
    //we create dictionaries for metrics and views to use in the visual format syntax for constraints
    NSDictionary *metrics = @{@"topMargin":@30,
                              @"titleMargin":@20,
                              @"contentSideMargin":@20,
                              @"contentMargin": @20,
                              @"imageSize":@100};
    
    NSDictionary *views = NSDictionaryOfVariableBindings(imageView,titleLabel,textLabel);
    //equivalent to NSDictionary *views = @{@"imageView":imageView,@"titleLabel":titleLabel,@"contentLabel":contentLabel};
    
    
    //Add our constraints
    
    //add vertical constraint
    //the title label is topMargin down from the top
    //the imageView is titleMargin down from the title
    //the contentLabel is contentMargin down from the image
    //the image is imageSize wide
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[titleLabel]-titleMargin-[imageView(imageSize)]-contentMargin-[textLabel]" options:0 metrics:metrics views:views]];
    
    //add centering constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    //add horizontal constraints for content label
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-contentSideMargin-[textLabel]-contentSideMargin-|" options:0 metrics:metrics views:views]];
    
    //add equal dimensions constraint for imageView width to height
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
