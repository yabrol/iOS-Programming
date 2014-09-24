//
//  TableViewController.m
//  Menagerie
//
//  Created by Tim Novikoff on 9/23/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import "TableViewController.h"
#import "RemoteWebViewController.h"
#import "LocalWebViewController.h"
#import "MovieViewController.h"

@interface TableViewController ()

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Lecture 3";
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(dismiss)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void) dismiss{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Aaaaaaand...it's gone.");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:{
            return [[self.allItemsDictionary objectForKey:@"needsView"] count];
            break;
        }
        case 1:{
            return [[self.allItemsDictionary objectForKey:@"noViewNeeded"] count];
            break;
        }
        default:
            break;
    }
    
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSDictionary *itemDictionary;
    
    switch (indexPath.section) {
        case 0:{
            NSArray *array = [self.allItemsDictionary objectForKey:@"needsView"];
            itemDictionary = [array objectAtIndex:indexPath.row];
            break;
        }
        case 1:{
            NSArray *array = [self.allItemsDictionary objectForKey:@"noViewNeeded"];
            itemDictionary = [array objectAtIndex:indexPath.row];
            break;
        }
        default:
            break;
    }
    
    NSString *mainText = [itemDictionary objectForKey:@"mainText"];
    NSString *detailText = [itemDictionary objectForKey:@"detailText"];
    
    cell.textLabel.text = mainText;
    cell.detailTextLabel.text = detailText;
    
    // Configure the cell...
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch(indexPath.section){
        case 0:{
            switch(indexPath.row){
                case 0:{
                    RemoteWebViewController *remoteViewController = [[RemoteWebViewController alloc] init];
                    [self.navigationController pushViewController:remoteViewController animated:YES];
                    break;
                }
                case 1:{
                    LocalWebViewController *localViewController = [[LocalWebViewController alloc] init];
                    [self.navigationController pushViewController:localViewController animated:YES];
                    break;
                }
                case 2:{
                    MovieViewController *movieViewController = [[MovieViewController alloc] init];
                    [self.navigationController pushViewController:movieViewController animated:YES];
                    break;
                }
                case 3:{
                    //recursion!
                    TableViewController *tableViewController = [[TableViewController alloc] init];
                    tableViewController.allItemsDictionary = self.allItemsDictionary;
                    [self.navigationController pushViewController:tableViewController animated:YES];
                    break;
                }
                default:
                    break;
                    
            }
        }
        case 1:{
            switch(indexPath.row){
                case 0:{
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
                    break;
                }
                default:
                    break;
            }
        }
        default:
            break;
    }
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) timerDidFire: (NSTimer *) timer{
    NSLog(@"i've been fired");
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
