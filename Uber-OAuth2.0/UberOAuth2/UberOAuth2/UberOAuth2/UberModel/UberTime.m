//
//  UberTime.m
//  UberKit
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.


#import "UberTime.h"

@implementation UberTime

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        _productID = [dictionary objectForKey:@"product_id"];
        _displayName = [dictionary objectForKey:@"display_name"];
        _estimate = [[dictionary objectForKey:@"estimate"] floatValue];
    }
    
    return self;
}

@end
