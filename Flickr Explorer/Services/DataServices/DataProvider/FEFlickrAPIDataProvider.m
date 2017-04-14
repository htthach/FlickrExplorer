//
//  FEFlickrAPIDataProvider.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 13/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEFlickrAPIDataProvider.h"
#import "FEJsonParser.h"
#import "FEJsonParser.h"
#import "FEConfigurations.h"
#import "FESearchResult.h"
#import "FEHelper.h"

static int const FE_NETWORK_ERROR_CODE_INVALID_PARAM    = 400;
static NSString * const FE_NETWORK_ERROR_DOMAIN         = @"com.flickrexplorer.ios.network";

static NSString * const FE_ENDPOINT_PARAM_API_KEY       = @"api_key";
static NSString * const FE_ENDPOINT_PARAM_FORMAT        = @"format";
static NSString * const FE_ENDPOINT_PARAM_NO_CALLBACK   = @"nojsoncallback";
static NSString * const FE_ENDPOINT_PARAM_METHOD        = @"method";
static NSString * const FE_ENDPOINT_PARAM_TEXT          = @"text";
//flickr api methods
static NSString * const FE_API_SEARCH_METHOD            = @"flickr.photos.search";


@interface FEFlickrAPIDataProvider () <NSURLSessionDelegate>
@property (nonatomic, strong) id<FEDataToObjectParser> parser;
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSURLSession *session;
@end
@implementation FEFlickrAPIDataProvider

/**
 Convenient factory method to return a standard Flickr API data provider.
 
 @return an instance of FEFlickrAPIDataProvider
 */
+(instancetype) defaultProvider{
    static FEFlickrAPIDataProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [FEFlickrAPIDataProvider dataProviderWithDefaultConfig];
    });
    return sharedInstance;
}

-(instancetype)initWithParser:(id<FEDataToObjectParser>) parser
                      baseURL:(NSURL *)url
         sessionConfiguration:(NSURLSessionConfiguration *)configuration
               operationQueue:(NSOperationQueue *) operationQueue
{
    self = [super init];
    if (self) {
        self.parser = parser;
        self.baseURL = url;
        self.session = [NSURLSession sessionWithConfiguration:configuration
                                                     delegate:nil
                                                delegateQueue:operationQueue];
    }
    return self;
}


/**
 A convenient method to create a default data provider with default config

 @return A default data provider with default config
 */
+(instancetype) dataProviderWithDefaultConfig{
    return [[FEFlickrAPIDataProvider alloc] initWithParser:[FEJsonParser new]
                                                   baseURL:[FEFlickrAPIDataProvider flickrBaseURL]
                                      sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                            operationQueue:[[NSOperationQueue alloc] init]];
}


/**
 Return Flickr API base url from config file

 @return Flickr API base url from config file
 */
+(NSURL*) flickrBaseURL{
    NSString *baseUrlString = [FEConfigurations baseURLStringForFlickrAPI];
    return [NSURL URLWithString:baseUrlString];
}

#pragma mark - private helper methods
-(NSURL*) urlForEndPoint:(NSString *) endpoint{
    return [NSURL URLWithString:endpoint relativeToURL:self.baseURL];
}


/**
 Simplified Http get method helper

 @param endpoint url end point (to be combined with base url)
 @param returnType the expected return type of the response
 @param success success call back block
 @param fail fail call back block
 */
-(void) GET:(NSString*) endpoint
 returnType:(Class) returnType
    success:(void (^)(id responseObject)) success
       fail:(void (^)(NSError *error)) fail{

    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL: [self urlForEndPoint:endpoint]
                                                 completionHandler:^(NSData *data,
                                                                     NSURLResponse *response,
                                                                     NSError *error) {
                                         if (error) {
                                             //data task error, abort
                                             if (fail) {
                                                 fail(error);
                                             }
                                             return;
                                         }
                                         //data task completed, proceed to parse data
                                         
                                         [self.parser parseData:data
                                              intoObjectOfClass:returnType
                                                       complete:^(id resultObject,
                                                                  NSError *parseError) {
                                             
                                             //if cannot parse, abort
                                             if (parseError) {
                                                 if (fail) {
                                                     fail(parseError);
                                                 }
                                                 return;
                                             }
                                             
                                             //can parse successfully
                                             if (success) {
                                                 success(resultObject);
                                             }
                                         }];
                                     }];
    
    [dataTask resume];
}


/**
 Constructing the endpoint following Flickr API documentation. Without the base url of course E.g https://api.flickr.com/services/rest/?method=flickr.test.echo&name=value
 
 @param param query param to construct the end point
 @return the endpoint following Flickr API documentation
 */
-(NSString*) endPointForParams:(NSDictionary*) param{
    NSURLComponents *components = [NSURLComponents componentsWithString:@"rest"];
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in param) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:param[key]]];
    }
    //add default params
    [queryItems addObject:[NSURLQueryItem queryItemWithName:FE_ENDPOINT_PARAM_API_KEY value:[FEConfigurations flickrAPIKey]]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:FE_ENDPOINT_PARAM_FORMAT value:@"json"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:FE_ENDPOINT_PARAM_NO_CALLBACK value:@"1"]];

    components.queryItems = queryItems;
    return components.URL.absoluteString;
}


/**
 Construct an error object to describe the "invalid request param" error

 @return an error object to describe the "invalid request param" error
 */
+(NSError*) invalidRequestParamError{
    NSError *error = [[NSError alloc] initWithDomain:FE_NETWORK_ERROR_DOMAIN code:FE_NETWORK_ERROR_CODE_INVALID_PARAM userInfo:[NSDictionary dictionaryWithObject:@"Invalid Request Parameter" forKey:NSLocalizedDescriptionKey]];
    return error;
}
#pragma mark - public request method

/**
 Search Flickr API for photos matching some free text
 
 @param text    the free text to search for
 @param success success callback block
 @param fail    failure callback block
 */
-(void) searchPhotoWithText:(NSString*) text
                    success:(void (^)(FESearchResult *searchResult)) success
                       fail:(void (^)(NSError *error)) fail{
    
    //check if valid parameters
    if ([FEHelper isEmptyString:text]) {
        if (fail) {
            fail ([FEFlickrAPIDataProvider invalidRequestParamError]);
        }
        return;
    }
    
    [self GET:[self endPointForParams:@{FE_ENDPOINT_PARAM_METHOD:FE_API_SEARCH_METHOD,
                                        FE_ENDPOINT_PARAM_TEXT:text}]
   returnType:[FESearchResult class]
      success:success
         fail:fail];
}
@end
