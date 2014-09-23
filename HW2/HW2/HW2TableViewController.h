//
//  HW2TableViewController.h
//  HW2
//
//  Created by Yukti Abrol on 9/17/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HW2TableViewController : UITableViewController

@property (strong, nonatomic) NSMutableDictionary *toDoDict;
@property (strong,nonatomic) NSMutableDictionary *toBuyDict;

- (void) addToBuyDictKey:(NSString *)key andObject:(NSString *) obj;
- (void) addToDoDictKey:(NSString *)key andObject:(NSString *) obj;
@end
