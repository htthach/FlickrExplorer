//
//  FESearchLogic.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 13/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FESearchLogic.h"
#import "FEDataProvider.h"
#import "FEPhoto.h"
#import "FESearchResult.h"

@interface FESearchLogic ()
@property (nonatomic, strong) NSString          *searchText;
@property (nonatomic, strong) FESearchResult    *searchResult;
@property (nonatomic)         NSInteger         currentPage;
@property (nonatomic)         BOOL              loadingMore;
@end

@implementation FESearchLogic

/**
 Initialize this class utilizing the given data provider and delegate
 
 @param dataProvider data provider to talk to API
 @param delegate     callback delegate
 @return an instance of FESearchLogic
 */
-(instancetype) initWithDataProvider:(id<FEDataProvider>) dataProvider delegate:(id<FESearchLogicDelegate>) delegate{
    self = [super init];
    if (self) {
        self.dataProvider = dataProvider;
        self.delegate = delegate;
    }
    return self;
}
/**
 Start searching for photo given the input text from user
 
 @param text the input text to search photo
 */
-(void) searchPhotoWithText:(NSString*) text{
    self.searchText = text;
    self.currentPage = [FESearchResult startingPageIndex];
    [self.dataProvider searchPhotoWithText:text
                                      page:self.currentPage
                                   success:^(FESearchResult *searchResult) {
        if ([self.searchText isEqualToString:text]) {
            //only update if still searching for the same text
            self.searchResult = searchResult;
            [self.delegate searchLogicDidRefreshResult];
        }
    } fail:^(NSError *error) {
        [self.delegate searchLogicEncounteredError:error];
    }];
}

/**
 Start searching for photo given the selected tag
 
 @param tag tag to search photo by
 */
-(void) searchPhotoWithTag:(NSString*) tag{
    [self searchPhotoWithText:tag];
}

/**
 Fetch more search result
 */
-(void) fetchMoreSearchResult{
    if (self.loadingMore) {
        return;//already loading more
    }
    
    if ([self.searchResult hasMorePageAfter:self.currentPage]) {
        self.currentPage ++;
        NSString *text = self.searchText;
        self.loadingMore = YES;
        [self.dataProvider searchPhotoWithText:text
                                          page:self.currentPage
                                       success:^(FESearchResult *searchResult) {
                                           self.loadingMore = NO;
                                           if ([self.searchText isEqualToString:text]) {
                                               //only update if still searching for the same text
                                               [self.searchResult appendSearchResult:searchResult];
                                               [self.delegate searchLogicDidFetchMoreResult];
                                           }
                                       } fail:^(NSError *error) {
                                           self.loadingMore = NO;
                                           [self.delegate searchLogicEncounteredError:error];
                                       }];

    }
}

/**
 Number of photo to show from search result
 
 @return Number of photo to show from search result
 */
-(NSInteger) numberOfPhotosToShow{
    return [self.searchResult numberOfPhotos];
}

/**
 Return a photo of the search result at an index
 
 @param index index of the photo
 @return a photo of the search result at an index
 */
-(FEPhoto*) photoToDisplayAtIndex:(NSInteger) index{
    return [self.searchResult getPhotoAtIndex: index];
}

/**
 From now on, all search result will be filtered by this tag.
 
 @param tag tag to filter result by. If pass nil, clear all tag filter.
 */
-(void) filterResultByTag:(NSString*) tag{
    
}


/**
 Return the most popular tag from the search result.
 
 @param count number of top result to return. E.g passing 10 will return top 10
 @return the most popular tag from the search result.
 */
-(NSArray*) searchResultPopularTags:(NSInteger) count{
    return @[@"Flower", @"Sushi", @"Sashimi", @"Chicken"];
}

@end
