//
//  ViewController.m
//  UberOAuth2
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.
//

#import "ViewController.h"
#import "UberLoginWebViewController.h"
#import "UberAPI.h"
#import "UberProfile.h"
#import "UberTicketVc.h"
#import "UbeCouponVc.h"


@interface ViewController()<UberTicketVcDelegate,UIWebViewDelegate>
/**授权按钮 */
@property(nonatomic,weak)UIButton *accessBtn;
/**登录*/
@property(nonatomic,weak)UIButton *logionBtn;
/**打车*/
@property(nonatomic,weak)UIButton *takeAtaxiBtn;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"打车";
    [self addBtnView];
    
    NSString *accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:kUberAccess_token];
    if (!accessToken||accessToken.length<1) {
        self.accessBtn.hidden=NO;
        self.logionBtn.hidden=YES;
        self.takeAtaxiBtn.hidden=YES;
    }
    else
    {
        //        [self startLocation];
        [self userProfileRequest];
        self.accessBtn.hidden=YES;
        self.logionBtn.hidden=NO;
        self.takeAtaxiBtn.hidden=NO;
    }
}


-(void)addBtnView
{
    UIButton *accessBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:accessBut];
    accessBut.frame=CGRectMake(([[UIScreen mainScreen] bounds].size.width-200)/2, ([UIScreen mainScreen].bounds.size.height-64-50)*0.5, 200, 50);
    accessBut.backgroundColor=[UIColor colorWithRed:0.04f green:0.03f blue:0.11f alpha:1.00f];
    [accessBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [accessBut addTarget:self action:@selector(accessBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [accessBut setTitle:@"Uber OAuth2 Login" forState:UIControlStateNormal];
    self.accessBtn=accessBut;
    
    UIButton *logainBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:logainBut];
    logainBut.frame=CGRectMake(([[UIScreen mainScreen] bounds].size.width-200)/2, ([UIScreen mainScreen].bounds.size.height-64-50)*0.5-80, 200, 50);
    logainBut.backgroundColor=[UIColor colorWithRed:0.04f green:0.03f blue:0.11f alpha:1.00f];
    [logainBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logainBut addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [logainBut setTitle:@"登录查看兑换优惠券" forState:UIControlStateNormal];
    self.logionBtn=logainBut;
    
    UIButton *takeAtextBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:takeAtextBut];
    takeAtextBut.frame=CGRectMake(([[UIScreen mainScreen] bounds].size.width-200)/2, ([UIScreen mainScreen].bounds.size.height-64-50)*0.5+80, 200, 50);
    takeAtextBut.backgroundColor=[UIColor colorWithRed:0.04f green:0.03f blue:0.11f alpha:1.00f];
    [takeAtextBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [takeAtextBut addTarget:self action:@selector(takeAtextAction:) forControlEvents:UIControlEventTouchUpInside];
    [takeAtextBut setTitle:@"去打车" forState:UIControlStateNormal];
    self.takeAtaxiBtn=takeAtextBut;
}


#pragma mark-
#pragma mark 授权
- (void)accessBtnAction:(UIButton*)button{
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
    webViewController.resultCallBack=^(id  accessTokenDic, NSURLResponse *response, NSError *error){
        if (error) {
            if ([error.domain isEqualToString:@"error2"]) {
                UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"" message:@"login fail" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil, nil];
                [alerView show];
            }
        }else{
            NSString *accessToken=[accessTokenDic objectForKey:@"access_token"];
            NSString *scope=[accessTokenDic objectForKey:@"scope"];
            if (!accessToken || accessToken.length<1) {
                UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"" message:@"please login first" delegate:self cancelButtonTitle:@"sure" otherButtonTitles:@"cancel", nil];
                [alerView show];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kUberAccess_token];
                [[NSUserDefaults standardUserDefaults] setObject:scope forKey:@"Uber_scope"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"授权成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.accessBtn.hidden=YES;
                    self.logionBtn.hidden=NO;
                    self.takeAtaxiBtn.hidden=NO;
                });
            }
        }
    };
    UINavigationController *navCon=[[UINavigationController alloc]initWithRootViewController:webViewController];
    webViewController.title=@"授权登录";
    [self presentViewController:navCon animated:YES completion:nil];
}
#pragma mark 登录优惠券列表
-(void)loginAction:(UIButton*)button
{
    UbeCouponVc* couponVc=[[UbeCouponVc alloc]init];
    [self.navigationController pushViewController:couponVc animated:YES];
}
#pragma mark 授权成功打车
-(void)takeAtextAction:(UIButton*)button
{
    NSString* accessToken=   [[NSUserDefaults standardUserDefaults] objectForKey:kUberAccess_token];
    NSString *scope=   [[NSUserDefaults standardUserDefaults] objectForKey:@"Uber_scope"];
    NSString *url=[NSString stringWithFormat:@"%@/rides/?access_token=%@&scope=%@",BaseURLs,accessToken,scope];
    NSLog(@"--access_token:%@",url);
    UberTicketVc *webVc=[[UberTicketVc alloc]init];
    webVc.webUrl=url;
    webVc.webDelegate=self;
    [self.navigationController pushViewController:webVc animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self accessBtnAction:self.accessBtn];
    }
}

-(void)uberTicketVc:(UberTicketVc *)webVc loadFaleError:(NSError *)error
{
    NSLog(@"打车界面加载失败，重新授权到带车界面");
    self.accessBtn.hidden=NO;
    self.logionBtn.hidden=YES;
    self.takeAtaxiBtn.hidden=YES;
}


#pragma mark-
#pragma mark 获取当前产品
-(void)requeseProductListWith:(CLLocation *)convertedLoc
{
    [UberAPI getProductsForLocation:(CLLocation *)convertedLoc withCompletionHandler:^(NSArray *resultsArray, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
        NSLog(@"刷新表格显示产品： %@",resultsArray);
    }];
}
#pragma mark 获取当前用户信息
- (void)userProfileRequest{
    [UberAPI requestUserProfileWithResult:^(UberProfile* profile, NSURLResponse *response, NSError *error){
        if (profile) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"User's 全名称 %@ %@", profile.first_name, profile.last_name);
            });
        }
    }];
}

@end
