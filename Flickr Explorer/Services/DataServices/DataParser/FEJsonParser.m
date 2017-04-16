//
//  FEJsonParser.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEJsonParser.h"
#import "FEBaseModel.h"

static int const FE_PARSING_ERROR_CODE_UNKNOWN_TARGET_CLASS     = 400;
static NSString * const FE_PARSING_ERROR_DOMAIN                 = @"com.flickrexplorer.ios.jsonparser";

@implementation FEJsonParser

/**
 Parse data into object asynchronously
 
 @param data        the input data to parse
 @param targetClass the target class of the result
 @param complete    the completion block to be called after parsing complete.
 */
-(void) parseData:(NSData*) data intoObjectOfClass:(Class) targetClass complete:(void (^)(id resultObject, NSError *parseError)) complete{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //step 1 nsdata to json
        NSError *parseError = nil;
        id responseJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if(parseError){
            if (complete) {
                complete(nil, parseError);
            }
            return;
        }
        
        //step 2 json to object
        id responseObject = [self parsedObjectFromJsonObject:responseJson basedOnType:targetClass error:&parseError];
        
        if (complete) {
            complete(responseObject, parseError);
        }
        
    });
}

/**
 *  Parse a json object into an object of expected type if possible
 *
 *  @param jsonObject     the json object, usually NSDictionary or NSArray
 *  @param expectedType   the Class of the expected return
 *  @param parseError     the error to return
 *  @return the parsed object of the expected return type
 */
-(id) parsedObjectFromJsonObject:(id) jsonObject basedOnType:(Class) expectedType error:(NSError **)parseError{
    if ([jsonObject isKindOfClass:expectedType]){
        //already of correct object type,
        return jsonObject;
    }
    
    //if caller expect FEBaseModel response and json object is dictionary => we can parse it
    if ([expectedType isSubclassOfClass:[FEBaseModel class]] && [jsonObject isKindOfClass:[NSDictionary class]]) {
        FEBaseModel *parsedObject = [[expectedType alloc] initWithDictionary:jsonObject error:parseError];
        return parsedObject;
    }
    
    //we don't know how to parse
    *parseError = [NSError errorWithDomain:FE_PARSING_ERROR_DOMAIN code:FE_PARSING_ERROR_CODE_UNKNOWN_TARGET_CLASS userInfo:[NSDictionary dictionaryWithObject:@"Unknown target class for parsing" forKey:NSLocalizedDescriptionKey]];
    return nil;
}
@end
