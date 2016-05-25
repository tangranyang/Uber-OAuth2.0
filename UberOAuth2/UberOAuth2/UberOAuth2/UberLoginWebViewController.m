//
//  UberLoginWebViewController.m
//  UberOAuth2
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.
//

#import "UberLoginWebViewController.h"
#import "UberAPI.h"

@interface UberLoginWebViewController ()<UIWebViewDelegate>

@end

@implementation UberLoginWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"授权登录";
    // Do any additional setup after loading the view.
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    }
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    UIButton *backBt=[UIButton buttonWithType:UIButtonTypeCustom];
    backBt.frame=CGRectMake(10, 27, 35, 30);
    [backBt setTitle:@"Back" forState:UIControlStateNormal];
    backBt.titleLabel.font=[UIFont systemFontOfSize:15];
    [backBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backBt];
    
    UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64)];
    [self.view addSubview:webView];
    webView.delegate=self;
    [webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_urlString]] ];
    
}
- (void)backHome
{
    if (_resultCallBack) {
        NSError *aError = [NSError errorWithDomain:@"error1" code:1 userInfo:nil];
        _resultCallBack(nil,nil,aError);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *requestUrl = webView.request.URL.absoluteString;
    if ([requestUrl containsString:@"code="]) {
        NSRange range=[requestUrl rangeOfString:@"code="];
        [UberAPI requestAccessTokenWithAuthorationCode:[requestUrl substringFromIndex:(range.length+range.location)] result:^(id jsonDict, NSURLResponse *response, NSError *error){
            
            if (_resultCallBack) {
                if (jsonDict) {
                    _resultCallBack(jsonDict,response,nil);
                }else{
                    NSError *aError = [NSError errorWithDomain:@"error2" code:2 userInfo:nil];
                    _resultCallBack(jsonDict,response,aError);
                }
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //    NSLog(@"%@",request.URL.absoluteString);
    return YES;
}

@end