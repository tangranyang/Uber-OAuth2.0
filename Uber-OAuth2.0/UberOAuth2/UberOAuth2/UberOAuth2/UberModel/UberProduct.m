//
//  UberProduct.m
//  UberKit
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.

#import "UberProduct.h"

@implementation UberProduct

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        _product_id = [dictionary objectForKey:@"product_id"];
        _display_name = [dictionary objectForKey:@"display_name"];
        _product_description = [dictionary objectForKey:@"description"];
        _capacity = [[dictionary objectForKey:@"capacity"] intValue];
        _image = [dictionary objectForKey:@"image"];
    }
    
    return self;
}

@end
