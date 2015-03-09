//
//  PEViewController.m
//  PhotoEditor
//
//  Created by Peng Fuyuzhen on 2/5/14.
//  Copyright (c) 2014 Peng Fuyuzhen. All rights reserved.
//

#import "PEViewController.h"
#import "PETableViewCell.h"
#import "PEEditingViewController.h"
#import <MessageUI/MessageUI.h>

@interface PEViewController ()<PEEditingViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *galleryTableView;
@property (strong, nonatomic) UIImage*selectedCellImage;
@property (strong, nonatomic) NSIndexPath *selectedCellIndexPath;
@property (strong, nonatomic) NSMutableArray *galleryImageArray;
@property (nonatomic, strong) MFMailComposeViewController *mailComposeViewController;

@end

@implementation PEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Fix the issue that the tableview has blank space on top
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Set up navigation bar with a title and an Add button
    self.navigationItem.title = @"My Gallery";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonPressed)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
    // Set up array for the tableview to display all photos
    // I put two placeholder images
    self.galleryImageArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"sample"],
                                                                    [UIImage imageNamed:@"sample2"],
                                                                    nil];
    
    //adapt the content if the screen is 3.5-inch instead of 4-inch
    CGRect ScreenBounds = [[UIScreen mainScreen]bounds];
    CGSize screenSize = ScreenBounds.size;
    if (screenSize.height<568) {
        //height of the tableview should be the height of the screen minus
        //the height of the navigation bar
        self.galleryTableView.frame = CGRectMake(0, 64, screenSize.width, screenSize.height - 64.0);
    }
}

- (void) presentEditingViewController{
    
    PEEditingViewController *controller = [[PEEditingViewController alloc]init];
    controller.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:^{
    }];
}

- (void) addButtonPressed{
    
    //this method gets called when the Add button is pressed
    self.selectedCellImage = nil;
    self.selectedCellIndexPath = nil;
    [self presentEditingViewController];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PETableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"PETableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PETableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.coverImageView.image = self.galleryImageArray[indexPath.row];
    
    //init the email button
    [cell.emailButton addTarget:self action:@selector(sendPhoto:) forControlEvents:UIControlEventTouchUpInside];
    cell.emailButton.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedCellIndexPath = indexPath;
    self.selectedCellImage = self.galleryImageArray[indexPath.row];
    
    // fix the issue that calling "presentEditingViewController" has long delay
    [self performSelectorOnMainThread:@selector(presentEditingViewController) withObject:nil waitUntilDone:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.galleryImageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //eable user to delete a cell
    [self.galleryImageArray removeObjectAtIndex:indexPath.row];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

- (UIImage *) getDefaultImage{
    //delegate method for PEEditingViewController
    return self.selectedCellImage;
}

- (NSIndexPath *)getCellIndexPath{
    //delegate method for PEEditingViewController
    return self.selectedCellIndexPath;
}

- (void) updateGalleryWithImage:(UIImage*)image forIndexPath:(NSIndexPath*)indexPath{
    
    //delegate method for PEEditingViewController
    if (indexPath == nil) {
        [self.galleryImageArray insertObject:image atIndex:0];
    }else{
        [self.galleryImageArray replaceObjectAtIndex:indexPath.row withObject:image];
    }
    [self.galleryTableView reloadData];
}

- (void) sendPhoto: (UIButton *)sender{
    
    UIImage* photo = self.galleryImageArray[sender.tag];
    self.mailComposeViewController = [[MFMailComposeViewController alloc] init];
    self.mailComposeViewController.mailComposeDelegate = self;
    if ([MFMailComposeViewController canSendMail]) {
        [self.mailComposeViewController setSubject:@"Check out my work"];
        NSData *imageData = UIImagePNGRepresentation(photo);
        [self.mailComposeViewController addAttachmentData:imageData mimeType:@"image/png" fileName:@"My work"];
        [self presentViewController:self.mailComposeViewController animated:YES completion:nil];
    }else{
        return;
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
