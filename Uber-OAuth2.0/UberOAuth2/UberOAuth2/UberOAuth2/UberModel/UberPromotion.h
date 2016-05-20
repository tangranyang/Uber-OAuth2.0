//
//  UberPromotion.h
//  UberKitDemo
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UberPromotion : NSObject

@property (nonatomic) NSString *text;
@property (nonatomic) NSString *localized_value;
@property (nonatomic) NSString *type;

- (instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end
