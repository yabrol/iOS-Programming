//
//  SCViewController.h
//  StampChat
//
//  Created by Tim Novikoff on 1/25/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCViewController : UIViewController
{
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}

@end
