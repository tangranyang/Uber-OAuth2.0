//
//  UberAPI.m
//  UberOAuth2
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.
//

//
//  UberAPI.m
//  UberOAuth2
//
//  Created by coderyi on 16/1/19.
//  Copyright © 2016年 coderyi. All rights reserved.
//

#import "UberAPI.h"
#import "UberActivity.h"
#import "UberProduct.h"
#import "UberPrice.h"
#import "UberTime.h"
#import "UberPromotion.h"
#import "UberProfile.h"
#import "AFNetworking.h"




@implementation UberAPI
+ (void)requestAccessTokenWithAuthorationCode:(NSString *)code result:(RequestResult)requestResult{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@/oauth/v2/token",@"https://login.uber.com.cn"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *postBodyString=[NSString stringWithFormat:@"client_secret=%@&client_id=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",ClientSecret,ClientId,RedirectUrl,code];
    
    NSData *bodyData = [postBodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (requestResult) {
            
            requestResult(responseObject,response,error);
        }
        
    }];
    
    [task resume];
    
    
}


+ (void)requestUserProfileWithResult:(RequestResult)requestResult{
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat: @"%@/v1/me",BaseURLs]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:kUberAccess_token];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (requestResult) {
            UberProfile *profile = [[UberProfile alloc] initWithDictionary:responseObject];
            requestResult(profile,response,error);
        }
        
    }];
    [task resume];
    
    
}

+ (void) sendUserPromotionToApply:(NSString *)code Result:(RequestResult)requestResult
{
    NSString *accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:kUberAccess_token];
    NSString *scope=[[NSUserDefaults standardUserDefaults]objectForKey:@"Uber_scope"];
    NSString *urlStr=[NSString stringWithFormat: @"%@/v1/me",BaseURLs];
    
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: urlStr]];
    //    [request setHTTPMethod:@"PATCH"];
    //    [request setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
    //    [request setValue:@"application/json" forHTTPHeaderField :@"Content-Type"];
    //    NSString *postBodyString= [NSString stringWithFormat:@"applied_promotion_codes:%@",code];
    //    NSData *bodyData = [postBodyString dataUsingEncoding:NSUTF8StringEncoding];
    //    [request setHTTPBody:bodyData];
    //
    //    AFHTTPRequestOperation*operation=[[UberAPI managerAFN]HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //    }];
    //    NSOperationQueue *queue=[[NSOperationQueue alloc]init];
    //    [queue addOperation:operation];
    
    AFHTTPSessionManager *client = [AFHTTPSessionManager manager];
    client.requestSerializer = [AFJSONRequestSerializer serializer];
    [client.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
    
    [client PATCH:urlStr parameters:@{@"applied_promotion_codes":code} success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}


+ (void) getUserActivityWithCompletionHandler:(CompletionHandler)completion
{
    //GET /v1.2/history
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:kUberAccess_token];
    NSString *url = [NSString stringWithFormat:@"%@/v1.2/history?access_token=%@",BaseURLs, token];
    [UberAPI requestProductMessageWithURL:url completionHandler:^(NSDictionary *activity, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             int offset = [[activity objectForKey:@"offset"] intValue];
             int limit = [[activity objectForKey:@"limit"] intValue];
             int count = [[activity objectForKey:@"count"] intValue];
             NSArray *history = [activity objectForKey:@"history"];
             NSMutableArray *availableActivity = [[NSMutableArray alloc] init];
             for(int i=0; i<history.count; i++)
             {
                 UberActivity *activity = [[UberActivity alloc] initWithDictionary:[history objectAtIndex:i]];
                 [activity setLimit:limit];
                 [activity setOffset:offset];
                 [activity setCount:count];
                 [availableActivity addObject:activity];
             }
             completion(availableActivity, response, error);
         }
         else
         {
             completion(nil, response, error);
         }
     }];
}


+ (void) getProductsForLocation:(CLLocation *)location withCompletionHandler:(CompletionHandler)completion
{
    // GET/v1/products
    
    NSString *url = [NSString stringWithFormat:@"%@/v1/products?server_token=%@&latitude=%f&longitude=%f", BaseURLs, ServerId, location.coordinate.latitude, location.coordinate.longitude];
    [UberAPI requestProductMessageWithURL:url completionHandler:^(NSDictionary *results, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             NSArray *products = [results objectForKey:@"products"];
             NSMutableArray *availableProducts = [[NSMutableArray alloc] init];
             for(int i=0; i<products.count; i++)
             {
                 UberProduct *product = [[UberProduct alloc] initWithDictionary:[products objectAtIndex:i]];
                 [availableProducts addObject:product];
             }
             completion(availableProducts, response,  error);
         }
         else
         {
             NSLog(@"Error %@", error);
             completion(nil, response, error);
         }
     }];
}


+ (void) getPriceForTripWithStartLocation:(CLLocation *)startLocation endLocation:(CLLocation *)endLocation withCompletionHandler:(CompletionHandler)completion
{
    // GET /v1/estimates/price
    
    NSString *url = [NSString stringWithFormat:@"%@/v1/estimates/price?server_token=%@&start_latitude=%f&start_longitude=%f&end_latitude=%f&end_longitude=%f", BaseURLs, ServerId, startLocation.coordinate.latitude, startLocation.coordinate.longitude, endLocation.coordinate.latitude, endLocation.coordinate.longitude];
    [self requestProductMessageWithURL:url completionHandler:^(NSDictionary *results, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             NSArray *prices = [results objectForKey:@"prices"];
             NSMutableArray *availablePrices = [[NSMutableArray alloc] init];
             for(int i=0; i<prices.count; i++)
             {
                 UberPrice *price = [[UberPrice alloc] initWithDictionary:[prices objectAtIndex:i]];
                 if(price.lowEstimate > -1)
                 {
                     [availablePrices addObject:price];
                 }
             }
             completion(availablePrices, response, error);
         }
         else
         {
             NSLog(@"Error %@", error);
             completion(nil, response, error);
         }
     }];
}


+ (void) getTimeForProductArrivalWithLocation:(CLLocation *)location withCompletionHandler:(CompletionHandler)completion
{
    //GET /v1/estimates/time
    
    NSString *url = [NSString stringWithFormat:@"%@/v1/estimates/time?server_token=%@&start_latitude=%f&start_longitude=%f", BaseURLs, ServerId, location.coordinate.latitude, location.coordinate.longitude];
    [UberAPI requestProductMessageWithURL:url completionHandler:^(NSDictionary *results, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             NSArray *times = [results objectForKey:@"times"];
             NSMutableArray *availableTimes = [[NSMutableArray alloc] init];
             for(int i=0; i<times.count; i++)
             {
                 UberTime *time = [[UberTime alloc] initWithDictionary:[times objectAtIndex:i]];
                 [availableTimes addObject:time];
             }
             completion(availableTimes, response, error);
         }
         else
         {
             NSLog(@"Error %@", error);
             completion(nil, response, error);
         }
     }];
}




+ (void) requestProductMessageWithURL:(NSString *)url completionHandler:(void (^)(NSDictionary *, NSURLResponse *, NSError *))completion
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    [[session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            
            NSError *jsonError = nil;
            NSDictionary *serializedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (jsonError == nil) {
                completion(serializedResults, response, jsonError);
            } else {
                NSHTTPURLResponse *convertedResponse = (NSHTTPURLResponse *)response;
                completion(nil, convertedResponse, jsonError);
            }
        }
        else
        {
            NSHTTPURLResponse *convertedResponse = (NSHTTPURLResponse *)response;
            completion(nil, convertedResponse, error);
        }
    }] resume];
}

+(AFHTTPRequestOperationManager*)managerAFN
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60.0f;
    return manager;
}


@end
