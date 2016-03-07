//
//  RequestAction.m
//  Key4Lead
//
//  Created by Paul Antonelli on 06/08/2015.
//  Copyright (c) 2015 NYX INFO. All rights reserved.
//

#import "RequestAction.h"

#import "AppModel.h"
#import "AppController.h"

@interface RequestAction ()

@end

@implementation RequestAction

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self.httpHeaderFields setObject:@"application/json" forKey:kContentTypeKey];
//        [self.httpHeaderFields setObject:kAPIToken forKey:kAuthKey];
        
        DDLogInfo(@"HTTP HEADER FIELDS : %@", self.httpHeaderFields);
    }
    return self;
}


- (void)prepareOperation
{
    [super prepareOperation];
    
//    NSMutableSet *set = [[NSMutableSet alloc] initWithSet:self.operation.responseSerializer.acceptableContentTypes];
////    [set addObject:@"text/plain"];
////    [set addObject:@"text/html"];    
//    self.operation.responseSerializer.acceptableContentTypes = set;
}

- (NSMutableURLRequest *)buildRequest
{
    NSMutableURLRequest *request = [super buildRequest];
    request.cachePolicy =  NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    request.timeoutInterval = kRequestTimeoutDuration;
    return request;
}

//- (void)handleOperationDidFailWithError:(NSError *)error data:(id)data
//{
//    DDLogError(@"error : %@, data : %@", error, data);
//    [super handleOperationDidFailWithError:error data:data];
//}


@end
