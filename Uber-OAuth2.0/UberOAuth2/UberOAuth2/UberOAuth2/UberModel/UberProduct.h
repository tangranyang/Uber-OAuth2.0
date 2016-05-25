//
//  UberProduct.h
//  UberKit
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UberProduct : NSObject

@property (nonatomic) NSString *product_id;
@property (nonatomic) NSString *product_description;
@property (nonatomic) NSString *display_name;
@property (nonatomic) int capacity;
@property (nonatomic) NSString *image;

- (instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end
