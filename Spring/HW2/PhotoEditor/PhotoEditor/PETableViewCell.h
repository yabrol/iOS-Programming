//
//  PETableViewCell.h
//  PhotoEditor
//
//  Created by Peng Fuyuzhen on 2/5/14.
//  Copyright (c) 2014 Peng Fuyuzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface PETableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;

@end
