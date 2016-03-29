//
//  WebViewController.m
//  RottenMangoes
//
//  Created by Monica Mollica on 2016-03-28.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.movie.webURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [self.webView loadRequest:request];
    
}

@end
