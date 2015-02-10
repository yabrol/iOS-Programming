//
//  ViewController.m
//  CrapChat
//
//  Created by Yukti on 2/2/15.
//  Copyright (c) 2015 Yukti. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *picImageView;
@property (strong, nonatomic) IBOutlet UITableView *textTableView;
@property (strong, nonatomic) NSArray *fontNameArray; //strong reference, stay in memory
@property (strong, nonatomic) NSArray *fontArray;
@property (strong, nonatomic) IBOutlet UITextField *stampTextField;
@property (assign,nonatomic) CGPoint lastTouchPoint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.fontNameArray = [[NSArray alloc] initWithObjects:@"AppleGothic",
                          @"MarkerFelt-Thin",
                          @"Courier",
                          @"Verdana-Bold",
                          nil];
    
    UIFont *font0 = [UIFont fontWithName:@"AppleGothic" size:20];
    UIFont *font1 = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
    UIFont *font2 = [UIFont fontWithName:@"Courier" size:20];
    UIFont *font3 = [UIFont fontWithName:@"Verdana-Bold" size:20];
    
    self.fontArray = @[font0, font1, font2, font3];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userDidPanWithGestureRecognizer:)];
    [self.stampTextField addGestureRecognizer:panGestureRecognizer];
}

- (void)userDidPanWithGestureRecognizer:(UIPanGestureRecognizer *) sender{
    NSLog(@"I'm panning! I pan! I'm a panner!");
    
//    CGPoint point = [sender locationInView:self.view];
//    self.stampTextField.center = point;
    
    //this pans at correct part touched
    CGPoint currentTouchPoint = [sender locationInView:self.view];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            self.lastTouchPoint = currentTouchPoint;
            break;
        }
        case UIGestureRecognizerStateChanged:{
            float dx = currentTouchPoint.x - self.lastTouchPoint.x;
            float dy = currentTouchPoint.y - self.lastTouchPoint.y;
            float newx = self.stampTextField.center.x + dx;
            float newy = self.stampTextField.center.y + dy;
            
            self.stampTextField.center = CGPointMake(newx, newy);
            self.lastTouchPoint = currentTouchPoint;
            break;
        }
        default:
            break;
    }
}

- (IBAction)stampButtonPressed:(id)sender {
    NSLog(@"Stamp button pressed");
    
    UIGraphicsBeginImageContext(CGSizeMake(320,320));
    
    UIImage *preImage = self.picImageView.image;
    [preImage drawInRect:CGRectMake(0, 0, 320, 320)];
    
//    NSString *string = self.stampTextField.text;
//    
//    NSDictionary *attributes = @{NSFontAttributeName: self.stampTextField.font};
//    
//    [string drawInRect:self.stampTextField.frame withAttributes:attributes]; //stamps at left aligned
    
    [self.stampTextField drawTextInRect:self.stampTextField.frame];//stamps middle
    
    self.picImageView.image = UIGraphicsGetImageFromCurrentImageContext();
}

- (IBAction)saveButtonPressed:(id)sender {
    NSLog(@"Save button pressed");
    UIImageWriteToSavedPhotosAlbum(self.picImageView.image, nil, nil, nil);
}

- (IBAction)sendButtonPressed:(id)sender {
    NSLog(@"Send button pressed");
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger) section{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.fontNameArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [self.fontArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (IBAction)returnButtonPressed:(id)sender {
    NSLog(@"return button pressed");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
