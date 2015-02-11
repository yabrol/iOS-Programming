//
//  SCViewController.m
//  StampChat
//
//  Created by Tim Novikoff on 1/25/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import "SCViewController.h"
#import <MessageUI/MessageUI.h>

@interface SCViewController () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *theTextField;
@property (strong, nonatomic) NSArray *fontNameArray;
@property (strong, nonatomic) NSArray *fontArray;
@property (strong, nonatomic) IBOutlet UITableView *fontTableView;
@property (assign, nonatomic) BOOL isAlreadyDragging;
@property (assign, nonatomic) CGPoint oldTouchPoint;
@property (strong, nonatomic) UIImageView *theImageView;

@property (nonatomic, strong) MFMailComposeViewController *mailComposeViewController;

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //initialize an array with the font names (for display in the table view cells)
    self.fontNameArray = [[NSArray alloc] initWithObjects:@"AppleGothic",
                          @"HelveticaNeue-UltraLight",
                          @"MarkerFelt-Thin",
                          @"Georgia",
                          @"Courier",
                          @"Verdana-Bold",
                          nil];
    
    //initiazlize and array of fonts for use in setting the font of the textField
    int fontSize = 20;    UIFont *appleGothic = [UIFont fontWithName:@"AppleGothic" size:fontSize];
    UIFont *ultraLight = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:fontSize];
    UIFont *markerFelt = [UIFont fontWithName:@"MarkerFelt-Thin" size:fontSize];
    UIFont *georgia = [UIFont fontWithName:@"Georgia" size:fontSize];
    UIFont *courier = [UIFont fontWithName:@"Courier" size:fontSize];
    UIFont *verdana = [UIFont fontWithName:@"Verdana-Bold" size:fontSize];
    self.fontArray = [[NSArray alloc]initWithObjects:appleGothic,ultraLight,markerFelt,georgia,courier,verdana, nil];
    
    //add gesture recognizer to the text field
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDidDrag:)];
    [self.theTextField addGestureRecognizer:panGestureRecognizer];
    
    //add an image.
    UIImage *image = [UIImage imageNamed:@"pic"];
    self.theImageView = [[UIImageView alloc] initWithImage:image];
    [self.view insertSubview:self.theImageView atIndex:0];
}

- (UIImage *) burnText: (NSString *) text intoImage: (UIImage *) image{
    
    //boilerplate for beginning an image context
    UIGraphicsBeginImageContextWithOptions(image.size, YES, 0.0);

    //draw the image in the image context
    CGRect aRectangle = CGRectMake(0,0, image.size.width, image.size.height);
    [image drawInRect:aRectangle];
    
    //draw the text in the image context
    NSDictionary *attributes = @{ NSFontAttributeName: self.theTextField.font,
                                  NSForegroundColorAttributeName: [UIColor blackColor]};
    CGSize size = [self.theTextField.text sizeWithAttributes:attributes];//get size of text
    CGPoint center = self.theTextField.center;//get the center
    CGRect rect = CGRectMake(center.x - size.width/2, center.y - size.height/2, size.width, size.height);//create the rect for the text
    [text drawInRect:rect withAttributes:attributes];

    //get the image to be returned before ending the image context
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();

    //boilerplate for ending an image context
    UIGraphicsEndImageContext();

    return theImage;
}



- (void) panGestureDidDrag: (UIPanGestureRecognizer *) sender{

    //get the touch point from the sender
    CGPoint newTouchPoint = [sender locationInView:self.view];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            //initialize oldTouchPoint for this drag
            self.oldTouchPoint = newTouchPoint;
            break;
        }
        case UIGestureRecognizerStateChanged:{
            //calculate the change in position since last call of panGestureDidDrag (for this drag)
            float dx = newTouchPoint.x - self.oldTouchPoint.x;
            float dy = newTouchPoint.y - self.oldTouchPoint.y;
    
            //move the center of the text field by the same amount that the finger moved
            self.theTextField.center = CGPointMake(self.theTextField.center.x + dx, self.theTextField.center.y + dy);

            //set oldTouchPoint
            self.oldTouchPoint = newTouchPoint;
            break;
        }
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //boilerplate for table views
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //add the appropriate font name to the cell
    cell.textLabel.text = [self.fontNameArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MAX(self.fontArray.count, self.fontNameArray.count);//note that this allows for easily adding more fonts. a better way to set things up might have been an array of dictionaries so you don't have to worry about matching the two arrays as you expand to add more fonts.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //change the font of the text field
    self.theTextField.font = [self.fontArray objectAtIndex:indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)stampButtonPressed:(id)sender {

    //get the new image, with the latest text burned into the latest position
    UIImage *image = [self burnText:self.theTextField.text intoImage:self.theImageView.image];
    
    //show the new image
    self.theImageView.image = image;
}
- (IBAction)saveButtonPressed:(id)sender {

    //save the image to the photo roll. note that the middle two parameters could have been left nil if we didn't want to do anything particular upon the save completing.
    UIImageWriteToSavedPhotosAlbum(self.theImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

- (void)               image: (UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo{
    //this method is being called once saving to the photoroll is complete.
    NSLog(@"photo saved!");
    
}

- (IBAction)textFieldDidEndOnExit:(id)sender {
    [sender resignFirstResponder];    //hide the keyboard
}
- (IBAction)emailButtonPressed:(id)sender {
    
    //initialize the mail compose view controller
    self.mailComposeViewController = [[MFMailComposeViewController alloc] init];
    self.mailComposeViewController.mailComposeDelegate = self;//this requires that this viewController declares that it adheres to <MFMailComposeViewControllerDelegate>, and implements a couple of delegate methods which we did not implement in class
    
    //set a subject for the email
    [self.mailComposeViewController setSubject:@"Check out my snapsterpiece"];
    
    // get the image data and add it as an attachment to the email
    NSData *imageData = UIImagePNGRepresentation(self.theImageView.image);
    [self.mailComposeViewController addAttachmentData:imageData mimeType:@"image/png" fileName:@"snapsterpiece"];

    // Show mail compose view controller
    [self presentViewController:self.mailComposeViewController animated:YES completion:nil];
}

//MFMailComposeViewControllerDelegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {//gets called after user sends or cancels
    
    //dismiss the mail compose view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
