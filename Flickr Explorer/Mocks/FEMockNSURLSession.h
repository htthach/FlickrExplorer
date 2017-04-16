//
//  FEMockNSURLSession.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 17/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FEMockNSURLSession : NSURLSession

+(instancetype _Nullable) mockURLSessionWithData:(NSData*_Nullable) data;

//We'll mock this method
//- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

//to return the requested URL from the mocked method
- (NSURL * _Nullable) requestedURL;
@end
