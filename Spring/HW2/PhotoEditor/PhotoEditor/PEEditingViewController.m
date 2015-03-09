//
//  PEEditingViewController.m
//  PhotoEditor
//
//  Created by Peng Fuyuzhen on 2/5/14.
//  Copyright (c) 2014 Peng Fuyuzhen. All rights reserved.
//

#import "PEEditingViewController.h"
#import "PEViewController.h"
#import <CoreImage/CoreImage.h>

@interface PEEditingViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *editingImageView;
@property (strong, nonatomic) UIImage* originalImage;
@property (strong, nonatomic) UIImage* tempImage;
@property (strong, nonatomic) IBOutlet UITabBar *segmentedTabBar;
@property (strong, nonatomic) IBOutlet UIButton *styleButton1;
@property (strong, nonatomic) IBOutlet UIButton *styleButton2;
@property (strong, nonatomic) IBOutlet UIButton *styleButton3;
@property (strong, nonatomic) IBOutlet UIButton *styleButton4;
@property (strong, nonatomic) IBOutlet UITabBarItem *tabBarFilterTab;
@property (strong, nonatomic) IBOutlet UITabBarItem *tabBarDrawTab;
@property (assign, nonatomic) int selectedTabIndex;
@property (strong, nonatomic) IBOutlet UIButton *photoRollButton;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;


@end

@implementation PEEditingViewController{
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set default brush color to black
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 6.0;
    opacity = 1.0;
    
    //customize the navigation bar with a title and two buttons
    self.navigationItem.title = @"Editing";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
    //set up the tab bar
    [self.segmentedTabBar setSelectedItem:self.tabBarFilterTab];
    [self setStyleButtonImageWithIndex:0];
    
    //import the image from PEViewController
    self.originalImage =  [self.delegate getDefaultImage];
    
    //if no image to import - user is adding a new image
    if (self.originalImage == nil) {
        self.originalImage = [UIImage imageNamed:@"bg"];
    }
    self.editingImageView.image = self.originalImage;
    //create a temp image for filters
    self.tempImage = self.originalImage;
    
    //adapt the content if the screen is 3.5-inch instead of 4
    CGRect ScreenBounds = [[UIScreen mainScreen]bounds];
    CGSize screenSize = ScreenBounds.size;
    if (screenSize.height<568) {
        //resize the image view
        self.editingImageView.frame = CGRectMake(35, 74, 250, 250);
        [self.view addSubview:self.editingImageView];
        //reposition the buttons
        self.photoRollButton.frame = CGRectMake(66, 330, 34, 34);
        self.cameraButton.frame = CGRectMake(143, 330, 34, 34);
        self.resetButton.frame = CGRectMake(220, 330, 34, 34);
        self.styleButton1.frame = CGRectMake(20, 368, 50, 50);
        self.styleButton2.frame = CGRectMake(97, 368, 50, 50);
        self.styleButton3.frame = CGRectMake(173, 368, 50, 50);
        self.styleButton4.frame = CGRectMake(250, 368, 50, 50);
    }
}

- (void) cancelButtonPressed{
    [self dismissViewControllerAnimated:YES completion:^{
        self.tempImage = nil;
        self.originalImage = nil;
    }];
}

- (void) saveButtonPressed{
    [self drawImageIntoImageView];
    [self.delegate updateGalleryWithImage:self.editingImageView.image forIndexPath:[self.delegate getCellIndexPath]];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.editingImageView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.editingImageView];
    
    if (self.selectedTabIndex==1) {
        UIGraphicsBeginImageContext(self.editingImageView.frame.size);
        [self.editingImageView.image drawInRect:CGRectMake(0, 0, self.editingImageView.frame.size.width, self.editingImageView.frame.size.height)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.editingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        self.tempImage = self.editingImageView.image;
        [self.editingImageView setAlpha:opacity];
        UIGraphicsEndImageContext();
        lastPoint = currentPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.selectedTabIndex==1) {
        if(!mouseSwiped) {
            UIGraphicsBeginImageContext(self.editingImageView.frame.size);
            [self.editingImageView.image drawInRect:CGRectMake(0, 0, self.editingImageView.frame.size.width, self.editingImageView.frame.size.height)];
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            CGContextFlush(UIGraphicsGetCurrentContext());
            self.editingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
            self.tempImage = self.editingImageView.image;
            UIGraphicsEndImageContext();
        }
        [self drawImageIntoImageView];
    }
}

- (void) drawImageIntoImageView{
    UIGraphicsBeginImageContext(self.editingImageView.frame.size);
    [self.editingImageView.image drawInRect:CGRectMake(0, 0, self.editingImageView.frame.size.width, self.editingImageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    self.editingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempImage = self.editingImageView.image;
    UIGraphicsEndImageContext();
}

- (IBAction)photoButtonPressed:(id)sender {
    
    //want to choose photo from photo roll
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)cameraButtonPressed:(id)sender {
    
    // if the device has no camera, stop presenting the imagePickerController
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                              message:@"This device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        return;
    }
    
    //taking a photo using camera
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIGraphicsBeginImageContextWithOptions(self.editingImageView.bounds.size, NO, [UIScreen mainScreen].scale);
    [chosenImage drawInRect:self.editingImageView.bounds];
    self.editingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    self.originalImage = self.editingImageView.image;
    self.tempImage = self.editingImageView.image;
    UIGraphicsEndImageContext();
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)resetButtonPressed:(id)sender {
    self.editingImageView.image = self.originalImage;
    self.tempImage = self.originalImage;
}

- (IBAction)styleButton1Pressed:(id)sender {
    if (self.selectedTabIndex==0) {
        [self applyFilterAtIndex:0];
    }else{//green
        red = 27/255.0;
        green = 179/255.0;
        blue = 27/255.0;
    }
}

- (IBAction)styleButton2Pressed:(id)sender {
    if (self.selectedTabIndex==0) {
        [self applyFilterAtIndex:1];
    }else{//blue
        red = 40/255.0;
        green = 170/255.0;
        blue = 230/255.0;
    }
}

- (IBAction)styleButton3Pressed:(id)sender {
    if (self.selectedTabIndex==0) {
        [self applyFilterAtIndex:2];
    }else{//yellow
        red = 250/255.0;
        green = 170/255.0;
        blue = 30/255.0;
    }
}

- (IBAction)styleButton4Pressed:(id)sender {
    if (self.selectedTabIndex==0) {
        [self applyFilterAtIndex:3];
    }else{//black
        red = 0/255.0;
        green = 0/255.0;
        blue = 0/255.0;
    }
}

- (void) applyFilterAtIndex:(int)index{
    
    CIFilter *filter1 = [CIFilter filterWithName:@"CIPhotoEffectChrome"];
    CIFilter *filter2 = [CIFilter filterWithName:@"CIPhotoEffectMono"];
    CIFilter *filter3 = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
    CIFilter *filter4 = [CIFilter filterWithName:@"CIPhotoEffectFade"];
    
    CIImage*rawImageData;
    rawImageData = [[CIImage alloc]initWithImage:self.tempImage];
    CIImage *filteredImageData;
    
    if (index == 0) { //button 1 is pressed
        [filter1 setDefaults];
        [filter1 setValue:rawImageData forKey:@"inputImage"];
        filteredImageData = [filter1 valueForKey:@"outputImage"];
    }else if (index == 1){ //button 2 is pressed
        [filter2 setDefaults];
        [filter2 setValue:rawImageData forKey:@"inputImage"];
        filteredImageData = [filter2 valueForKey:@"outputImage"];
    }else if (index == 2){ //button 3 is pressed
        [filter3 setDefaults];
        [filter3 setValue:rawImageData forKey:@"inputImage"];
        filteredImageData = [filter3 valueForKey:@"outputImage"];
    }else{ //button 4 is pressed
        [filter4 setDefaults];
        [filter4 setValue:rawImageData forKey:@"inputImage"];
        filteredImageData = filter4.outputImage;
    }
    self.editingImageView.image = [UIImage imageWithCIImage:filteredImageData];
}

- (void) setStyleButtonImageWithIndex:(NSInteger)index{
    
    // change the look of the four style buttons
    if (index == 0) {
        // buttons are used for selecting filters
        [self.styleButton1 setBackgroundImage:[UIImage imageNamed:@"chrome"] forState:UIControlStateNormal];
        [self.styleButton2 setBackgroundImage:[UIImage imageNamed:@"noir"] forState:UIControlStateNormal];
        [self.styleButton3 setBackgroundImage:[UIImage imageNamed:@"transfer"] forState:UIControlStateNormal];
        [self.styleButton4 setBackgroundImage:[UIImage imageNamed:@"fade"] forState:UIControlStateNormal];
    }else{
        //buttons are used for choosing brush colors
        [self.styleButton1 setBackgroundImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
        [self.styleButton2 setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
        [self.styleButton3 setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        [self.styleButton4 setBackgroundImage:[UIImage imageNamed:@"black"] forState:UIControlStateNormal];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    // this method gets called when user taps on the tab bar
    self.selectedTabIndex = item.tag;
    [self setStyleButtonImageWithIndex:item.tag];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
