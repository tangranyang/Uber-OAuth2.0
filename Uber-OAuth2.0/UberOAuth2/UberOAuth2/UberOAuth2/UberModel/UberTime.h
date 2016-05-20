//
//  UberTime.h
//  UberKit
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UberTime : NSObject

@property (nonatomic) NSString *productID;
@property (nonatomic) NSString *displayName;
@property (nonatomic) float estimate;

- (instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end
