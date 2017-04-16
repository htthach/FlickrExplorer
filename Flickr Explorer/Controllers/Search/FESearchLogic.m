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
#import "FEPhotoList.h"

@interface FESearchLogic ()
@property (nonatomic, strong) NSString          *searchText;
@property (nonatomic, strong) FESearchResult    *searchResult;
@property (nonatomic, strong) FESearchResult    *filteredResult;
@property (nonatomic)         NSInteger         currentPage;
@property (nonatomic)         BOOL              loadingMore;
@property (nonatomic, strong) NSArray<NSString*> *currentFilter;
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
    self.currentFilter = nil;
    self.searchText = text;
    self.currentPage = [FESearchResult startingPageIndex];
    [self.dataProvider searchPhotoWithText:text
                                      page:self.currentPage
                                   success:^(FESearchResult *searchResult) {
        if ([self.searchText isEqualToString:text]) {
            //only update if still searching for the same text
            self.searchResult = searchResult;
            self.filteredResult = searchResult; //initially, no filtering
            [self.delegate searchLogicDidRefreshResult];
        }
    } fail:^(NSError *error) {
        [self.delegate searchLogicEncounteredError:error];
    }];
}


/**
 Start searching for photo given the selected tags
 
 @param tags tags to search photo by
 */
-(void) searchPhotoWithTags:(NSArray<NSString*>*) tags{
    [self searchPhotoWithText:[tags firstObject]];
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
                                               [self.searchResult.photos appendPhotoList:searchResult.photos];
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
    return [self.filteredResult.photos numberOfPhotos];
}

/**
 Return a photo of the search result at an index
 
 @param index index of the photo
 @return a photo of the search result at an index
 */
-(FEPhoto*) photoToDisplayAtIndex:(NSInteger) index{
    return [self.filteredResult.photos photoAtIndex:index];
}



/**
 From now on, all search result will be filtered by these tags.
 
 @param tags tag to filter result by. If pass nil, clear all tag filter.
 */
-(void) filterResultByTags:(NSArray<NSString*>*) tags{
    self.currentFilter = tags;
    self.filteredResult = [self.searchResult resultFilteredWithTags: tags];
    [self.delegate searchLogicDidFilterResult];
}


/**
 Return the most popular tag from the search result.
 
 @param count number of top result to return. E.g passing 10 will return top 10
 @return the most popular tag from the search result.
 */
-(NSArray*) searchResultPopularTags:(NSInteger) count{
    return [self.searchResult.photos mostPopularTag:count];
}

@end
