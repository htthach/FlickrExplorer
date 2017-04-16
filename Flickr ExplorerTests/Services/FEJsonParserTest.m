//
//  FEJsonParserTest.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 16/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FEJsonParser.h"
#import "FESearchResult.h"
#import "FEPhotoList.h"
#import "FEPhoto.h"
#import "FEContent.h"

@interface FEJsonParserTest : XCTestCase
@property (nonatomic, strong) NSData *testData;
@end

@implementation FEJsonParserTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSString *jsonString = @"{\"photos\":{\"page\":1,\"pages\":39412,\"perpage\":5,\"total\":\"197058\",\"photo\":[{\"id\":\"33689290530\",\"owner\":\"9351020@N06\",\"secret\":\"63c5cb0b92\",\"server\":\"2862\",\"farm\":3,\"title\":\"Final Rally\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0,\"tags\":\"rally mitin inigo urkullu basque first minister lehendakari lehendakaria eaj national party country bilbao bizkaia biscay euskadi pentax k50 sigma tamron 70300\"},{\"id\":\"34073270175\",\"owner\":\"25280208@N02\",\"secret\":\"8351638f77\",\"server\":\"2907\",\"farm\":3,\"title\":\"Berlin-148\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0,\"tags\":\"berlin europe germany traveling city mauerpark park\"},{\"id\":\"34073270035\",\"owner\":\"25280208@N02\",\"secret\":\"d721bd69c6\",\"server\":\"3956\",\"farm\":4,\"title\":\"Berlin-149\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0,\"tags\":\"berlin europe germany traveling city mauerpark park graffiti streetart\"},{\"id\":\"33917175192\",\"owner\":\"25280208@N02\",\"secret\":\"728e77532d\",\"server\":\"2891\",\"farm\":3,\"title\":\"Berlin-150\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0,\"tags\":\"berlin europe germany traveling city mauerpark park graffiti streetart\"},{\"id\":\"33917174882\",\"owner\":\"25280208@N02\",\"secret\":\"7fc1626bf1\",\"server\":\"2949\",\"farm\":3,\"title\":\"Berlin-151\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0,\"tags\":\"berlin europe germany traveling city mauerpark park\"}]},\"stat\":\"ok\"}";
    
    self.testData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParseData {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Parsing Method"];

    
    FEJsonParser *parser = [FEJsonParser new];
    [parser parseData:self.testData intoObjectOfClass:[FESearchResult class] complete:^(id resultObject, NSError *parseError) {
        FESearchResult *searchResult = resultObject;
        XCTAssertNil(parseError, @"Parser should parse correct data with no error");
        XCTAssert([resultObject isMemberOfClass:[FESearchResult class]], @"Parser should parse into given class");
        XCTAssertEqualObjects(searchResult.stat, @"ok", @"Parser should parse attribute properly");
        XCTAssertEqual([searchResult.photos numberOfPhotos], 5, @"Parser should parse all array element");
        XCTAssertEqualObjects([searchResult.photos photoAtIndex:0].photoId, @"33689290530", @"Parser should parse nested object");
        XCTAssertEqualObjects([searchResult.photos photoAtIndex:0].owner.nsid, @"9351020@N06", @"Parser should parse string-initializable property correctly");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}
- (void)testParseDataError {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Parsing Method"];
    
    FEJsonParser *parser = [FEJsonParser new];
    [parser parseData:[@"corrupted data" dataUsingEncoding:NSUTF8StringEncoding] intoObjectOfClass:[FESearchResult class] complete:^(id resultObject, NSError *parseError) {
        XCTAssertNotNil(parseError, @"Parser should parse corrupted data with error");
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
