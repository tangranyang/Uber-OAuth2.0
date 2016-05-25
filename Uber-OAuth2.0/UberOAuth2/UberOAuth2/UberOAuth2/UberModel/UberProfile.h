//
//  UberProfile.h
//  UberKitDemo
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UberProfile : NSObject

@property (nonatomic) NSString *first_name;
@property (nonatomic) NSString *last_name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *picture;
@property (nonatomic) NSString *promo_code;
@property (nonatomic) NSString *uuid;
@property (nonatomic) BOOL mobile_verified;

- (instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end
