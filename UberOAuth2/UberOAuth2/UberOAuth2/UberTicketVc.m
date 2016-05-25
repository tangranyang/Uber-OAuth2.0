//
//  UberTicketVc.m
//  hnatravel
//
//  Created by  汤冉阳 on 16/5/24.
//  Copyright © 2016年 hna. All rights reserved.
//

#import "UberTicketVc.h"
#import "UberAPI.h"

@implementation UberTicketVc

-(void)viewDidLoad
{
    [super viewDidLoad];
    NSString *encodedUrlString = [self.webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *baseURL = [NSURL URLWithString:encodedUrlString];
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    webView.scalesPageToFit = YES;
    
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:baseURL];
    [webView loadRequest:request];
    webView.delegate=self;
    webView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:webView];
    self.title=@"Uber 打车";
}




-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kUberAccess_token ];
    if ([self.webDelegate respondsToSelector:@selector(uberTicketVc:loadFaleError:)]) {
        [self.webDelegate uberTicketVc:self loadFaleError:error];
    }
}


@end
