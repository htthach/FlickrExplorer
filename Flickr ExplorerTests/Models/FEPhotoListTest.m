//
//  FEPhotoListTest.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 16/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FEPhotoList.h"
#import "FEPhoto.h"

@interface FEPhotoListTest : XCTestCase
@property (nonatomic, strong) FEPhoto *photo1;
@property (nonatomic, strong) FEPhoto *photo2;
@property (nonatomic, strong) FEPhoto *photo3;
@property (nonatomic, strong) FEPhoto *photo4;
@property (nonatomic, strong) FEPhoto *photo5;
@end

@implementation FEPhotoListTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.photo1 = [[FEPhoto alloc] initWithDictionary:@{@"id":@"1", @"tags":@"tag1"} error:nil];
    self.photo2 = [[FEPhoto alloc] initWithDictionary:@{@"id":@"2", @"tags":@"tag1 tag2"} error:nil];
    self.photo3 = [[FEPhoto alloc] initWithDictionary:@{@"id":@"3", @"tags":@"tag1 tag2 tag3"} error:nil];
    self.photo4 = [[FEPhoto alloc] initWithDictionary:@{@"id":@"4", @"tags":@"tag1 tag2 tag3 tag4"} error:nil];
    self.photo5 = [[FEPhoto alloc] initWithDictionary:@{@"id":@"5", @"tags":@"tag4"} error:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testAppendPhotoList{
    FEPhotoList *list1 = [FEPhotoList new];
    list1.photos = @[self.photo1, self.photo2, self.photo3];
    
    FEPhotoList *list2 = [FEPhotoList new];
    list2.photos = @[self.photo4, self.photo5];
    
    [list1 appendPhotoList:list2];
    
    XCTAssertEqual([list1 numberOfPhotos], 5, @"List append should have sum of elements");
    XCTAssertEqualObjects([list1 photoAtIndex:4], [list2 photoAtIndex:1], @"Photo should be the same after appending");
}

-(void)testMostPopularTag{
    FEPhotoList *list = [FEPhotoList new];
    list.photos = @[self.photo1, self.photo2, self.photo3, self.photo4, self.photo5];
    NSArray *topTags = [list mostPopularTag:3];
    NSArray *alotOfTags = [list mostPopularTag:100];
    XCTAssertEqual([topTags count], 3, @"Top tag count limit should be respected");
    XCTAssertEqual([alotOfTags count], 4, @"Top tag count is also limit by number of tags available");
    XCTAssertEqualObjects([topTags firstObject], @"tag1", @"Tag with most count should be first");
    XCTAssertNotEqualObjects([topTags firstObject], @"tag2", @"Tag without most count should not be first");
    XCTAssertEqualObjects(topTags[1], @"tag2", @"Second most popular tag should be second");
}

-(void)testPhotoListFilteredWithTags{
    FEPhotoList *list1 = [FEPhotoList new];
    list1.photos = @[self.photo1, self.photo2, self.photo3, self.photo4, self.photo5];
    list1.page = @(1);
    list1.pages = @(10);
    
    FEPhotoList *list2 = [list1 photoListFilteredWithTags:@[@"tag2"]];
    XCTAssertEqualObjects(list1.page, list2.page, @"Page should be preserve after filtering");
    XCTAssertEqualObjects(list1.pages, list2.pages, @"Pages should be preserve after filtering");
    XCTAssertEqual([list2 numberOfPhotos], 3, @"Filtered list should have correct number of photo");
    XCTAssertTrue([list2 containsPhoto:self.photo2] && [list2 containsPhoto:self.photo3] && [list2 containsPhoto:self.photo4], @"Filtered list should have correct photo");
    XCTAssertFalse([list2 containsPhoto:self.photo1] || [list2 containsPhoto:self.photo5], @"Filtered list should not have filtered photo");
}
@end
