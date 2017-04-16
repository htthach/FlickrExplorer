//
//  FEFlickrAPIDataProviderTest.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 16/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FEMockNSURLSession.h"
#import "FEFlickrAPIDataProvider.h"
#import "FEJsonParser.h"
#import "FEConfigurations.h"
#import "FESearchResult.h"
#import "FEPhotoList.h"
@interface FEFlickrAPIDataProviderTest : XCTestCase

@end

@implementation FEFlickrAPIDataProviderTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSearchPhotoWithText {
    NSString *jsonString = @"{\"photos\":{\"page\":1,\"pages\":39412,\"perpage\":5,\"total\":\"197058\",\"photo\":[{\"id\":\"33689290530\",\"owner\":\"9351020@N06\",\"secret\":\"63c5cb0b92\",\"server\":\"2862\",\"farm\":3,\"title\":\"Final Rally\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0,\"tags\":\"rally mitin inigo urkullu basque first minister lehendakari lehendakaria eaj national party country bilbao bizkaia biscay euskadi pentax k50 sigma tamron 70300\"},{\"id\":\"34073270175\",\"owner\":\"25280208@N02\",\"secret\":\"8351638f77\",\"server\":\"2907\",\"farm\":3,\"title\":\"Berlin-148\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0,\"tags\":\"berlin europe germany traveling city mauerpark park\"},{\"id\":\"34073270035\",\"owner\":\"25280208@N02\",\"secret\":\"d721bd69c6\",\"server\":\"3956\",\"farm\":4,\"title\":\"Berlin-149\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0,\"tags\":\"berlin europe germany traveling city mauerpark park graffiti streetart\"},{\"id\":\"33917175192\",\"owner\":\"25280208@N02\",\"secret\":\"728e77532d\",\"server\":\"2891\",\"farm\":3,\"title\":\"Berlin-150\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0,\"tags\":\"berlin europe germany traveling city mauerpark park graffiti streetart\"},{\"id\":\"33917174882\",\"owner\":\"25280208@N02\",\"secret\":\"7fc1626bf1\",\"server\":\"2949\",\"farm\":3,\"title\":\"Berlin-151\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0,\"tags\":\"berlin europe germany traveling city mauerpark park\"}]},\"stat\":\"ok\"}";
    
    NSData *mockData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    FEMockNSURLSession *mockSession = [FEMockNSURLSession mockURLSessionWithData:mockData];
    FEFlickrAPIDataProvider *dataProvider = [[FEFlickrAPIDataProvider alloc] initWithParser:[FEJsonParser new]
                                                                baseURL:[NSURL URLWithString:@"https://baseurl.com"]
                                                                session:mockSession
                                                       apiResponseCache:nil
                                                             imageCache:nil];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Parsing Method"];

    NSString *expectedUrlString = [NSString stringWithFormat:@"https://baseurl.com/rest?extras=tags&method=flickr.photos.search&page=1&per_page=80&text=search_text&api_key=%@&format=json&nojsoncallback=1", [FEConfigurations flickrAPIKey]];
    
    [dataProvider searchPhotoWithText:@"search_text" tags:nil page:1 success:^(FESearchResult *searchResult) {
        //search result
        XCTAssertEqual([searchResult.photos numberOfPhotos], 5, @"Data provider should return data from mock session");
        [expectation fulfill];
    } fail:^(NSError *error) {
        //fail search
        XCTAssert(NO, @"Fail block should not be called");
        [expectation fulfill];
    }];
    
    XCTAssertEqualObjects(expectedUrlString, [mockSession requestedURL].absoluteString, @"data provider should construct the correct url");
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}
- (void)testSearchPhotoWithTextFail {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Parsing Method"];
    NSData *mockData = [@"corrupted data" dataUsingEncoding:NSUTF8StringEncoding];
    FEMockNSURLSession *mockSession = [FEMockNSURLSession mockURLSessionWithData:mockData];
    FEFlickrAPIDataProvider *dataProvider = [[FEFlickrAPIDataProvider alloc] initWithParser:[FEJsonParser new]
                                                                                    baseURL:[NSURL URLWithString:@"https://baseurl.com"]
                                                                                    session:mockSession
                                                                           apiResponseCache:nil
                                                                                 imageCache:nil];
    [dataProvider searchPhotoWithText:@"search_text" tags:nil page:1 success:^(FESearchResult *searchResult) {
        //search result
        XCTAssert(NO, @"Data provider should not call back success for corrupted data");
        [expectation fulfill];
    } fail:^(NSError *error) {
        //fail search
        XCTAssertNotNil(error, @"Fail block should be called with error object");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}
@end
