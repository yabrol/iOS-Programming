//
//  LocalWebViewController.m
//  Menagerie
//
//  Created by Yukti Abrol on 9/23/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import "LocalWebViewController.h"

@interface LocalWebViewController ()

@end

@implementation LocalWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *webView = [[UIWebView alloc] init];
    
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSLog(@"filename: %@", filename);
    
    NSString *string = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
    
    string = [string stringByReplacingOccurrencesOfString:@"Everyone" withString:@"Batman"];
    
    [webView loadHTMLString:string baseURL:nil];
    webView.frame = self.view.bounds;
    
    [self.view addSubview:webView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
