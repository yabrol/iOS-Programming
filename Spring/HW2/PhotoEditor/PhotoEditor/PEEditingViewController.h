//
//  PEEditingViewController.h
//  PhotoEditor
//
//  Created by Peng Fuyuzhen on 2/5/14.
//  Copyright (c) 2014 Peng Fuyuzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PEEditingViewControllerDelegate <NSObject>

- (UIImage *) getDefaultImage;
- (NSIndexPath *)getCellIndexPath;
- (void) updateGalleryWithImage:(UIImage*)image forIndexPath:(NSIndexPath*)indexPath;

@end

@interface PEEditingViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) id<PEEditingViewControllerDelegate> delegate;

@end
