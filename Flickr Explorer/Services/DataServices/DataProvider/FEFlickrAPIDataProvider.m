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
#import "FEPhotoInfoResult.h"
#import "FEHelper.h"
#import "FEMemoryCache.h"

static int const FE_NETWORK_ERROR_CODE_INVALID_PARAM        = 400;
static NSString * const FE_NETWORK_ERROR_DOMAIN             = @"com.flickrexplorer.ios.network";

//param name
static NSString * const FE_ENDPOINT_PARAM_API_KEY           = @"api_key";
static NSString * const FE_ENDPOINT_PARAM_FORMAT            = @"format";
static NSString * const FE_ENDPOINT_PARAM_NO_CALLBACK       = @"nojsoncallback";
static NSString * const FE_ENDPOINT_PARAM_METHOD            = @"method";
static NSString * const FE_ENDPOINT_PARAM_TEXT              = @"text";
static NSString * const FE_ENDPOINT_PARAM_PAGE              = @"page";
static NSString * const FE_ENDPOINT_PARAM_PER_PAGE          = @"per_page";
static NSString * const FE_ENDPOINT_PARAM_EXTRA             = @"extras";
static NSString * const FE_ENDPOINT_PARAM_PHOTO_ID          = @"photo_id";
static NSString * const FE_ENDPOINT_PARAM_SECRET            = @"secret";
static NSString * const FE_ENDPOINT_PARAM_TAGS              = @"tags";
static NSString * const FE_ENDPOINT_PARAM_LATITUDE          = @"lat";
static NSString * const FE_ENDPOINT_PARAM_LONGITUDE         = @"lon";
//param value

static NSString * const FE_ENDPOINT_VALUE_TAGS              = @"tags";
static NSString * const FE_ENDPOINT_VALUE_PER_PAGE          = @"80"; //fetch 80 result per page


//flick URL template
static NSString * const FE_FLICKR_URL_TEMPLATE              = @"https://farm{farmId}.staticflickr.com/{serverId}/{photoId}_{secret}_{size}.jpg";
static NSString * const FE_FLICKR_URL_TEMPLATE_FARM_KEY     = @"{farmId}";
static NSString * const FE_FLICKR_URL_TEMPLATE_SERVER_KEY   = @"{serverId}";
static NSString * const FE_FLICKR_URL_TEMPLATE_PHOTOID_KEY  = @"{photoId}";
static NSString * const FE_FLICKR_URL_TEMPLATE_SECRET_KEY   = @"{secret}";
static NSString * const FE_FLICKR_URL_TEMPLATE_SIZE_KEY     = @"{size}";

//flickr api methods
static NSString * const FE_API_SEARCH_METHOD                = @"flickr.photos.search";
static NSString * const FE_API_PHOTO_INFO_METHOD            = @"flickr.photos.getInfo";

@interface FEFlickrAPIDataProvider () <NSURLSessionDelegate>
@property (nonatomic, strong) id<FEDataToObjectParser>  parser;
@property (nonatomic, strong) NSURL                     *baseURL;
@property (nonatomic, strong) NSURLSession              *session;
@property (nonatomic, strong) id<FEObjectCache>         apiResponseCache;
@property (nonatomic, strong) id<FEObjectCache>         imageCache;
@end

@implementation FEFlickrAPIDataProvider

/**
 Convenient factory method to return a shared standard Flickr API data provider.
 
 @return an singleton instance of FEFlickrAPIDataProvider
 */
+(instancetype) sharedDefaultProvider{
    static FEFlickrAPIDataProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [FEFlickrAPIDataProvider dataProviderWithDefaultConfig];
    });
    return sharedInstance;
}


/**
 Initialize FEFlickrAPIDataProvider with proper configuration

 @param parser the FEDataToObjectParser parser to use to parse api response NSData to Object
 @param url the base URL to use for all API request
 @param session the session to use for data task
 @param apiResponseCache the api response cache to use. Pass nil if don't want to enable auto API caching.
 @param imageCache the image cache to use. Pass nil if don't want to enable auto image caching.
 @return an instance of FEFlickrAPIDataProvider
 */
-(instancetype)initWithParser:(id<FEDataToObjectParser>) parser
                      baseURL:(NSURL *)url
                      session:(NSURLSession*) session
             apiResponseCache:(id<FEObjectCache>) apiResponseCache
                   imageCache:(id<FEObjectCache>) imageCache{
    self = [super init];
    if (self) {
        self.parser = parser;
        self.baseURL = url;
        self.session = session;
        self.apiResponseCache = apiResponseCache;
        self.imageCache = imageCache;
    }
    return self;
}


/**
 A convenient method to create a default data provider with default config

 @return A default data provider with default config
 */
+(instancetype) dataProviderWithDefaultConfig{
    id<FEObjectCache> imageCache = nil;
    id<FEObjectCache> apiResponseCache = nil;
    
    if ([FEConfigurations toCacheImage]) {
        imageCache = [[FEMemoryCache alloc] initWithSize:FE_LARGE_CACHE_SIZE];
    }
    
    if ([FEConfigurations toCacheAPIResponse]){
        apiResponseCache = [[FEMemoryCache alloc] initWithSize:FE_SMALL_CACHE_SIZE];
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[[NSOperationQueue alloc] init]];
    
    return [[FEFlickrAPIDataProvider alloc] initWithParser:[FEJsonParser new]
                                                   baseURL:[FEFlickrAPIDataProvider flickrBaseURL]
                                                   session:session
                                          apiResponseCache:apiResponseCache
                                                imageCache:imageCache
            ];
}



#pragma mark - network helpers

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
    
    //check if in cache
    id cachedResponse = [self.apiResponseCache getObjectForKey:endpoint];
    if (cachedResponse) {
        if (success) {
            success(cachedResponse);
        }
        return;
    }
    
    //not cached, fetch new one
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL: [self urlForEndPoint:endpoint]
                                                 completionHandler:^(NSData *data,
                                                                     NSURLResponse *response,
                                                                     NSError *error) {
                                         if (error) {
                                             //data task error, abort
                                             if (fail) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     fail(error);
                                                 });
                                             }
                                             return;
                                         }
                                         NSUInteger dataSize = [data length];
                                         //data task completed, proceed to parse data
                                         [self.parser parseData:data
                                              intoObjectOfClass:returnType
                                                       complete:^(id resultObject,
                                                                  NSError *parseError) {
                                             
                                             //if cannot parse, abort
                                             if (parseError) {
                                                 if (fail) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         fail(parseError);
                                                     });
                                                 }
                                                 return;
                                             }
                                             
                                             //can parse successfully
                                             [self.apiResponseCache cacheObject:resultObject ofSize:dataSize forKey:endpoint];
                                             if (success) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     success(resultObject);
                                                 });
                                             }
                                         }];
                                     }];
    
    [dataTask resume];
}

/**
 Simplified image download helper with caching
 
 @param imageUrl url of the image to download
 @param success success call back block
 @param fail fail call back block
 */
-(void) downloadImageFromUrl:(NSURL*) imageUrl
    success:(void (^)(UIImage *image)) success
       fail:(void (^)(NSError *error)) fail{
    
    //check if in cache
    id cachedResponse = [self.apiResponseCache getObjectForKey:imageUrl.absoluteString];
    if (cachedResponse) {
        if (success) {
            success(cachedResponse);
        }
        return;
    }
    
    //not cached, download new one
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL: imageUrl
                                                 completionHandler:^(NSData *data,
                                                                     NSURLResponse *response,
                                                                     NSError *error) {
                                             if (!data || error) {
                                                 //download error, abort
                                                 
                                                 if (fail) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         fail(error);
                                                     });
                                                 }
                                                 return;
                                             }
                                             
                                             //download completed, convert to image
                                             UIImage *image = [UIImage imageWithData:data];
                                             [self.imageCache cacheObject:image ofSize:[data length] forKey:imageUrl.absoluteString];
                                             
                                             if (success) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     success(image);
                                                 });
                                             }
                                         }];
    [dataTask resume];
}
#pragma mark - url construction helpers
/**
 Return Flickr API base url from config file
 
 @return Flickr API base url from config file
 */
+(NSURL*) flickrBaseURL{
    NSString *baseUrlString = [FEConfigurations baseURLStringForFlickrAPI];
    return [NSURL URLWithString:baseUrlString];
}

-(NSURL*) urlForEndPoint:(NSString *) endpoint{
    return [NSURL URLWithString:endpoint relativeToURL:self.baseURL];
}

/**
 Constructing the endpoint following Flickr API documentation. Without the base url of course E.g https://api.flickr.com/services/rest/?method=flickr.test.echo&name=value
 
 @param param query param to construct the end point
 @return the endpoint following Flickr API documentation
 */
-(NSString*) endPointForParams:(NSDictionary<NSString *, NSString *>*) param{
    NSURLComponents *components = [NSURLComponents componentsWithString:@"rest"];
    NSMutableArray *queryItems = [NSMutableArray array];
    NSArray *sortedKeys = [[param allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [(NSString*) obj1 compare:(NSString*) obj2];
    }];
    
    for (NSString *key in sortedKeys) {
        NSString *value = param[key];
        if (![FEHelper isEmptyString:key] && ![FEHelper isEmptyString:value]) {
            //only add query item if valid string
            [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:param[key]]];
        }
    }
    //add default params
    [queryItems addObject:[NSURLQueryItem queryItemWithName:FE_ENDPOINT_PARAM_API_KEY value:[FEConfigurations flickrAPIKey]]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:FE_ENDPOINT_PARAM_FORMAT value:@"json"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:FE_ENDPOINT_PARAM_NO_CALLBACK value:@"1"]];

    components.queryItems = queryItems;
    return components.URL.absoluteString;
}

-(NSString*) flickrImageSizeStringFromPhotoSize:(FEPhotoSize) size{
    switch (size) {
        case FEPhotoSizeThumb:
            return @"t";
        case FEPhotoSizeSmall:
            return @"m";
        case FEPhotoSizeMedium:
            return @"z";
        case FEPhotoSizeLarge:
            return @"b";
        case FEPhotoSizeOriginal:
            return @"o";
    }
}
/**
 Construct image url based on Flickr API documentation https://www.flickr.com/services/api/misc.urls.html
 
 @param photo detail of the photo
 @param size size to fetch
 @return the URL to download the image from
 */
-(NSURL*) flickrImageUrlFromPhoto:(FEPhoto*) photo size:(FEPhotoSize) size{
    NSString *urlString = [FE_FLICKR_URL_TEMPLATE stringByReplacingOccurrencesOfString:FE_FLICKR_URL_TEMPLATE_FARM_KEY withString:photo.farm];
    urlString = [urlString stringByReplacingOccurrencesOfString:FE_FLICKR_URL_TEMPLATE_SERVER_KEY withString:photo.server];
    urlString = [urlString stringByReplacingOccurrencesOfString:FE_FLICKR_URL_TEMPLATE_PHOTOID_KEY withString:photo.photoId];
    urlString = [urlString stringByReplacingOccurrencesOfString:FE_FLICKR_URL_TEMPLATE_SECRET_KEY withString:photo.secret];
    urlString = [urlString stringByReplacingOccurrencesOfString:FE_FLICKR_URL_TEMPLATE_SIZE_KEY withString:[self flickrImageSizeStringFromPhotoSize:size]];
    
    return [NSURL URLWithString:urlString];
}

/**
 Construct an error object to describe the "invalid request param" error with a reason

 @return an error object to describe the "invalid request param" error
 */
+(NSError*) invalidRequestParamError:(NSString*) reason{
    NSError *error = [[NSError alloc] initWithDomain:FE_NETWORK_ERROR_DOMAIN code:FE_NETWORK_ERROR_CODE_INVALID_PARAM userInfo:[NSDictionary dictionaryWithObject:reason forKey:NSLocalizedDescriptionKey]];
    return error;
}
#pragma mark - Implementation of FEDataProvider

/**
 Search Flickr API for photos matching some free text or tags. At least text or tags must present. Text takes precedent
 
 @param text    the free text to search for
 @param tags    the tags to search for. We'll use tags if text is nil or empty
 @param page    the result page to fetch
 @param success success callback block
 @param fail    failure callback block
 */
-(void) searchPhotoWithText:(NSString*) text
                       tags:(NSArray<NSString*>*)tags
                       page:(NSUInteger) page
                    success:(void (^)(FESearchResult *searchResult)) success
                       fail:(void (^)(NSError *error)) fail{
    
    //check if valid parameters
    if ([FEHelper isEmptyString:text] && [tags count] == 0) {
        if (fail) {
            fail ([FEFlickrAPIDataProvider invalidRequestParamError:NSLocalizedString(@"Either text or tags must be given", @"Invalid search param message")]);
        }
        return;
    }
    
    NSString *tagsStr = [tags componentsJoinedByString:@","];
    [self GET:[self endPointForParams:@{FE_ENDPOINT_PARAM_METHOD:FE_API_SEARCH_METHOD,
                                        FE_ENDPOINT_PARAM_TEXT:text?:@"",
                                        FE_ENDPOINT_PARAM_TAGS:tagsStr?:@"",
                                        FE_ENDPOINT_PARAM_PER_PAGE:FE_ENDPOINT_VALUE_PER_PAGE,
                                        FE_ENDPOINT_PARAM_PAGE:@(page).stringValue,
                                        FE_ENDPOINT_PARAM_EXTRA:FE_ENDPOINT_VALUE_TAGS
                                        }
               ]
   returnType:[FESearchResult class]
      success:success
         fail:fail];
}

/**
 Search Flickr API for photos nearby a location
 
 @param latitude    the latitude to search for
 @param longitude    the longitude to search for
 @param page    the result page to fetch
 @param success success callback block
 @param fail    failure callback block
 */
-(void) searchPhotoWithLatitude:(double) latitude
                      longitude:(double) longitude
                           page:(NSUInteger) page
                        success:(void (^)(FESearchResult *searchResult)) success
                           fail:(void (^)(NSError *error)) fail{
    [self GET:[self endPointForParams:@{FE_ENDPOINT_PARAM_METHOD:FE_API_SEARCH_METHOD,
                                        FE_ENDPOINT_PARAM_LATITUDE:@(latitude).stringValue,
                                        FE_ENDPOINT_PARAM_LONGITUDE:@(longitude).stringValue,
                                        FE_ENDPOINT_PARAM_PER_PAGE:FE_ENDPOINT_VALUE_PER_PAGE,
                                        FE_ENDPOINT_PARAM_PAGE:@(page).stringValue,
                                        FE_ENDPOINT_PARAM_EXTRA:FE_ENDPOINT_VALUE_TAGS
                                        }
               ]
   returnType:[FESearchResult class]
      success:success
         fail:fail];
}

/**
 Load more info about a particular photo
 
 @param photo   photo to load info of
 @param success success callback block
 @param fail    fail callback block
 */
-(void) loadInfoForPhoto:(FEPhoto*) photo
                 success:(void (^)(FEPhotoInfoResult *infoResult)) success
                    fail:(void (^)(NSError *error)) fail{
    //check if valid parameters
    if ([FEHelper isEmptyString:photo.photoId]) {
        if (fail) {
            fail ([FEFlickrAPIDataProvider invalidRequestParamError:NSLocalizedString(@"Missing photo id", @"Invalid photo info param message")]);
        }
        return;
    }
    
    [self GET:[self endPointForParams:@{FE_ENDPOINT_PARAM_METHOD:FE_API_PHOTO_INFO_METHOD,
                                        FE_ENDPOINT_PARAM_PHOTO_ID:photo.photoId,
                                        FE_ENDPOINT_PARAM_SECRET:photo.secret?:@"" //secret is optional
                                        }
               ]
   returnType:[FEPhotoInfoResult class]
      success:success
         fail:fail];
}
#pragma mark - Implementation of FEImageProvider

/**
 Download a photo from flickr
 
 @param photo the photo object containing info about the photo to download. A cached version will be returned if downloaded this before.
 @param size expected size to download
 @param success success callback block
 @param fail fail callback block
 */
-(void)downloadImageForPhoto:(FEPhoto *)photo
                        size:(FEPhotoSize)size
                     success:(void (^)(UIImage *))success
                        fail:(void (^)(NSError *))fail{
    NSURL *imageUrl = [self flickrImageUrlFromPhoto:photo size:size];
    [self downloadImageFromUrl:imageUrl success:success fail:fail];
}
@end
