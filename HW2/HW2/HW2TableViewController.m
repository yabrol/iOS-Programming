//
//  HW2TableViewController.m
//  HW2
//
//  Created by Yukti Abrol on 9/17/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "HW2TableViewController.h"

@interface HW2TableViewController ()

@end

@implementation HW2TableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.toDoDict = [[NSMutableDictionary alloc] init];
    self.toBuyDict = [[NSMutableDictionary alloc] init];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ((section == 0) ? self.toBuyDict.count : self.toDoDict.count);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    //to buy
    if(indexPath.section == 0){
        NSArray *keys = [self.toBuyDict allKeys];
        cell.textLabel.text = [keys objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.toBuyDict objectForKey:[keys objectAtIndex:indexPath.row]];
    }
    //to do
    else if (indexPath.section == 1) {
        NSArray *keys = [self.toDoDict allKeys];
        cell.textLabel.text = [keys objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.toDoDict objectForKey:[keys objectAtIndex:indexPath.row]];
    }
    
    cell.backgroundColor = [UIColor cyanColor];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell tapped");
    
    NSString *msg = [NSString stringWithFormat:@"Item: %@, Detail: %@", self.toBuyDict, self.toBuyDict];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Selection" message:msg delegate:self cancelButtonTitle: @"Okay" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    
}

- (void) addToBuyDictKey:(NSString *)key andObject:(NSString *) obj{
    [self.toBuyDict setObject:obj forKey:key];
}
- (void) addToDoDictKey:(NSString *)key andObject:(NSString *) obj{
    [self.toDoDict setObject:obj forKey:key];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
