//
//  UberProfile.m
//  UberKitDemo
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.
//

#import "UberProfile.h"

@implementation UberProfile

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        _first_name = [dictionary objectForKey:@"first_name"];
        _last_name = [dictionary objectForKey: @"last_name"];
        _email = [dictionary objectForKey:@"email"];
        _picture = [dictionary objectForKey:@"picture"];
        _promo_code = [dictionary objectForKey:@"promo_code"];
        _uuid = [dictionary objectForKey:@"uuid"];
    }
    return self;
}

@end
