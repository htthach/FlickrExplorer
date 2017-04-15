//
//  FEFlickrXMLParser.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 13/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEXmlParser.h"

@implementation FEXmlParser

/**
 Parse data into object asynchronously
 
 @param data        the input data to parse
 @param targetClass the target class of the result
 @param complete    the completion block to be called after parsing complete.
 */
-(void) parseData:(NSData*) data intoObjectOfClass:(Class) targetClass complete:(void (^)(id resultObject, NSError *parseError)) complete{
    NSAssert(NO, @"Missing implementation in FEXmlParser for XML parser following Flickr format");
}

@end
