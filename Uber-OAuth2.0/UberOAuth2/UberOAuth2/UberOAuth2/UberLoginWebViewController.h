//
//  UberLoginWebViewController.h
//  UberOAuth2
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UberLoginWebViewController : UIViewController
@property(nonatomic,strong) NSString *urlString;//LoginWebViewController 's url
@property(nonatomic,copy) void (^resultCallBack) (NSString* accessTokenStr, NSURLResponse *response, NSError *error);// login callback

@end
