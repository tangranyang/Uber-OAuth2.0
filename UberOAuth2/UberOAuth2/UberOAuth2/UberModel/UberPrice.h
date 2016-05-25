//
//  UberPrice.h
//  UberKit
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.

//

#import <Foundation/Foundation.h>

@interface UberPrice : NSObject

@property (nonatomic) NSString *productID;
@property (nonatomic) NSString *currencyCode;
@property (nonatomic) NSString *displayName;
@property (nonatomic) NSString *estimate;
@property (nonatomic) int lowEstimate;
@property (nonatomic) int highEstimate;
@property (nonatomic) float surgeMultiplier;
@property (nonatomic) int duration;
@property (nonatomic) float distance;

- (instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end
