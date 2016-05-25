//
//  UberTicketVc.h
//  hnatravel
//
//  Created by  汤冉阳 on 16/5/24.
//  Copyright © 2016年 hna. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UberTicketVc;
@protocol UberTicketVcDelegate <NSObject>

-(void)uberTicketVc:(UberTicketVc*)webVc loadFaleError:(NSError *)error;

@end

@interface UberTicketVc : UIViewController<UIWebViewDelegate>
/**webView 链接地址*/
@property(nonatomic,copy)NSString *webUrl ;

/**代理*/
@property(nonatomic,weak)id<UberTicketVcDelegate> webDelegate;

@end
