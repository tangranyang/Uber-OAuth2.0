//
//  ViewController.m
//  UberOAuth2
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.
//

#import "ViewController.h"
#import "UberAPI.h"
#import "UberLoginWebViewController.h"
#import "UberProfile.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *loginBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:loginBut];
    loginBut.frame=CGRectMake(([[UIScreen mainScreen] bounds].size.width-200)/2, 100, 200, 50);
    loginBut.backgroundColor=[UIColor colorWithRed:0.04f green:0.03f blue:0.11f alpha:1.00f];
    [loginBut setTitle:@"Uber OAuth2 Login" forState:UIControlStateNormal];
    [loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBut addTarget:self action:@selector(loginButAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *requestUserProfileBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:requestUserProfileBut];
    requestUserProfileBut.frame=CGRectMake(([[UIScreen mainScreen] bounds].size.width-200)/2, 200, 200, 50);
    requestUserProfileBut.backgroundColor=[UIColor colorWithRed:0.04f green:0.03f blue:0.11f alpha:1.00f];
    [requestUserProfileBut setTitle:@"Request User Profile" forState:UIControlStateNormal];
    [requestUserProfileBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [requestUserProfileBut addTarget:self action:@selector(requestUserProfileButAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)loginButAction{
    if (ClientId.length<1 || ClientSecret.length<1 || RedirectUrl.length<1 ) {
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"" message:@"you need clientid & clientsecret & redirecturl \n" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil, nil];
        [alerView show];
        return;
        
    }
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //    缓存  清除
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    UberLoginWebViewController *webViewController=[[UberLoginWebViewController alloc] init];
    NSString *url=[NSString stringWithFormat:@"https://login.uber.com.cn/oauth/v2/authorize?client_id=%@&redirect_url=%@&response_type=code&scope=profile history places history_lite ride_widgets",ClientId,RedirectUrl ];
    NSString *encodedUrlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    webViewController.urlString=encodedUrlString;
    webViewController.resultCallBack=^(NSString* accessTokenStr, NSURLResponse *response, NSError *error){
        NSLog(@"access token %@ ",accessTokenStr);
        
        if (error) {
            if ([error.domain isEqualToString:@"error2"]) {
                UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"" message:@"login fail" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil, nil];
                [alerView show];
            }
        }else{
            [self requestUserProfileButAction];
            
        }
        
    };
    
    [self presentViewController:webViewController animated:YES completion:nil];
}


- (void)requestUserProfileButAction{
    if (ClientId.length<1 || ClientSecret.length<1 || RedirectUrl.length<1 ) {
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"" message:@"you need clientid & clientsecret & redirecturl \n" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil, nil];
        [alerView show];
        return;
        
    }
    
    NSString *accessToken=[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSString *scope=[[NSUserDefaults standardUserDefaults] objectForKey:@"scope"];
    if (!accessToken || accessToken.length<1) {
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"" message:@"please login first" delegate:self cancelButtonTitle:@"sure" otherButtonTitles:@"cancel", nil];
        [alerView show];
    }else{
        [self userProfileRequest];
        NSString *url1=[NSString stringWithFormat:@" https://components.uber.com.cn/rides/?access_token=%@&scope=%@",accessToken,scope];
        [self pushNeedWebView:url1];
        NSLog(@"--access_token:%@",url1);
        
    }
}


-(void)pushNeedWebView:(NSString*)urlStr
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *webViewController=[[UIViewController alloc] init];
        NSString *encodedUrlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *baseURL = [NSURL URLWithString:encodedUrlString];
        
        UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 44, 375,600)];
        webView.scalesPageToFit = YES;
        
        NSURLRequest *request=[[NSURLRequest alloc]initWithURL:baseURL];
        [webView loadRequest:request];
        
        webView.backgroundColor=[UIColor whiteColor];
        [webViewController.view addSubview:webView];
        
        [self.navigationController pushViewController:webViewController animated:YES];
    });
    
}


- (void)userProfileRequest{
    [UberAPI requestUserProfileWithResult:^(UberProfile* profile, NSURLResponse *response, NSError *error){
        if (profile) {
            // 主线程执行：
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"User's 全名称 %@ %@", profile.first_name, profile.last_name);
            });
        }
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self loginButAction];
        
    }
    
}

@end
