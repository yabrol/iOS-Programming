//
//  RemoteWebViewController.m
//  Menagerie
//
//  Created by Yukti Abrol on 9/23/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import "RemoteWebViewController.h"

@interface RemoteWebViewController ()

@end

@implementation RemoteWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = CGRectMake(0, 150, 320, 400);
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.cnn.com"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [webView loadRequest:request];
    
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
