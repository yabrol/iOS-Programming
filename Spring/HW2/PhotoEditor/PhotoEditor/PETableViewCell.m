//
//  PETableViewCell.m
//  PhotoEditor
//
//  Created by Peng Fuyuzhen on 2/5/14.
//  Copyright (c) 2014 Peng Fuyuzhen. All rights reserved.
//

#import "PETableViewCell.h"

@implementation PETableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)savePhotoButtonPressed:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.coverImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)               image: (UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo{
    //this method is being called once saving to the photoroll is complete.
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Done"
                                                          message:@"Saved to camera roll"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
    [myAlertView show];
}


@end
