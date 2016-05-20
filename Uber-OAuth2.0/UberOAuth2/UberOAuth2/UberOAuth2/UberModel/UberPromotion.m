//
//  UberPromotion.m
//  UberKitDemo
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.
//

#import "UberPromotion.h"

@implementation UberPromotion

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        _text = [dictionary objectForKey:@"display_text"];
        _localized_value = [dictionary objectForKey:@"localized_value"];
        _type = [dictionary objectForKey:@"type"];
    }
    return self;
}

@end
