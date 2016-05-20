//
//  UberPrice.m
//  UberKit
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.

#import "UberPrice.h"

@implementation UberPrice

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        _productID = [dictionary objectForKey:@"product_id"];
        _currencyCode = [dictionary objectForKey:@"currency_code"];
        _displayName = [dictionary objectForKey:@"display_name"];
        _estimate = [dictionary objectForKey:@"estimate"];
        _lowEstimate = -1;
        _highEstimate = -1;
        NSString *lowE = [dictionary objectForKey:@"low_estimate"];
        NSString *highE = [dictionary objectForKey:@"high_estimate"];
        if ( ![lowE isKindOfClass:[NSNull class]] )
            _lowEstimate = [lowE intValue];
        if ( ![highE isKindOfClass:[NSNull class]] )
            _highEstimate = [highE intValue];
        _surgeMultiplier = [[dictionary objectForKey:@"surge_multiplier"] floatValue];
        _duration = [[dictionary objectForKey:@"duration" ] intValue];
        _distance = [[dictionary objectForKey:@"distance"] floatValue];
    }
    
    return self;
}

@end
