//
//  UbeCouponVc.m
//  hnatravel
//
//  Created by  汤冉阳 on 16/5/24.
//  Copyright © 2016年 hna. All rights reserved.
//

#import "UbeCouponVc.h"
#import "UberAPI.h"

@implementation UbeCouponVc

-(void)viewDidLoad
{
    [super viewDidLoad];
    [UberAPI sendUserPromotionToApply:@"pdybewwdub" Result:^(id jsonDict, NSURLResponse *response, NSError *error) {
        if (error==nil) {
            
        }
        else
        {
            NSLog(@"%@", error.userInfo[@"msg"]);
        }
    }];
}
@end
