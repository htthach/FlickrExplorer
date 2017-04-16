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
#import "FELocationProvider.h"

static int const FE_MIN_SEARCH_RESULT_FILL_PAGE = 30;
typedef NS_ENUM(NSInteger, FESearchMode) {
    FESearchModeIdle     = 0,
    FESearchModeLocation = 1,
    FESearchModeText     = 2,
    FESearchModeTags     = 3,
};

@interface FESearchLogic () <FELocationProviderDelegate>
@property (nonatomic)         FESearchMode          searchMode;
@property (nonatomic, strong) CLLocation            *searchLocation;
@property (nonatomic, strong) NSString              *searchText;
@property (nonatomic, strong) NSArray<NSString*>    *searchTags;

@property (nonatomic, strong) FESearchResult        *searchResult;
@property (nonatomic, strong) FESearchResult        *filteredResult;
@property (nonatomic)         NSInteger             currentPage;
@property (nonatomic)         BOOL                  loadingMore;
@property (nonatomic, strong) NSArray<NSString*>    *currentFilter;
@property (nonatomic, strong) FELocationProvider    *locationProvider;

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
 Search for photo nearby with current location
 */
-(void) searchNearbyPhoto{
    if (!self.locationProvider) {
        self.locationProvider = [FELocationProvider locationProviderWithDelegate:self];
    }
    self.searchMode = FESearchModeLocation;
    [self.locationProvider requestCurrentLocation];
}

#pragma mark - search methods

/**
 Start searching for photo given the input text from user
 
 @param text the input text to search photo
 */
-(void) searchPhotoWithText:(NSString*) text{
    self.currentFilter = nil;
    self.searchMode = FESearchModeText;
    self.searchText = text;
    self.currentPage = [FESearchResult startingPageIndex];
    [self.dataProvider searchPhotoWithText:text
                                      tags:nil
                                      page:self.currentPage
                                   success:^(FESearchResult *searchResult) {
                                       if ((self.searchMode == FESearchModeText) &&[self.searchText isEqualToString:text]) {
                                           //only update if still searching for the same text
                                           [self handleNewSearchResult:searchResult];
                                       }
                                   }
                                      fail:^(NSError *error) {
                                          [self.delegate searchLogicEncounteredError:error];
                                      }];
}


/**
 Start searching for photo given the selected tags
 
 @param tags tags to search photo by
 */
-(void) searchPhotoWithTags:(NSArray<NSString*>*) tags{
    self.currentFilter = nil;
    self.searchMode = FESearchModeTags;
    self.searchTags = tags;
    self.currentPage = [FESearchResult startingPageIndex];
    [self.dataProvider searchPhotoWithText:nil
                                      tags:tags
                                      page:self.currentPage
                                   success:^(FESearchResult *searchResult) {
                                       if ((self.searchMode == FESearchModeTags) && [self.searchTags isEqualToArray:tags]) {
                                           //only update if still searching for the same tags
                                           [self handleNewSearchResult:searchResult];
                                       }
                                   } fail:^(NSError *error) {
                                       [self.delegate searchLogicEncounteredError:error];
                                   }];
}

-(void) searchPhotoWithLocation:(CLLocation*) location{
    self.currentFilter = nil;
    self.searchMode = FESearchModeLocation;
    self.searchLocation = location;
    self.currentPage = [FESearchResult startingPageIndex];
    [self.dataProvider searchPhotoWithLatitude:location.coordinate.latitude
                                     longitude:location.coordinate.longitude
                                          page:self.currentPage
                                       success:^(FESearchResult *searchResult) {
                                           if (self.searchMode == FESearchModeLocation) {
                                               [self handleNewSearchResult:searchResult];
                                           }
                                       }
                                          fail:^(NSError *error) {
                                              [self.delegate searchLogicEncounteredError:error];
                                          }];
}



/**
 New search result come back, reset result with this

 @param searchResult the new search result
 */
-(void) handleNewSearchResult:(FESearchResult *)searchResult{
    self.searchResult = searchResult;
    //this is a new search result, no filter
    self.filteredResult = searchResult;
    [self.delegate searchLogicDidRefreshResult];
}

#pragma mark - search for more
/**
 More search result come back, add to current search result

 @param moreResult the result to append to current result
 */
-(void) handleExtraSearchResult:(FESearchResult *) moreResult{
    
    [self.searchResult.photos appendPhotoList:moreResult.photos];
    
    //filter new result with the same filter
    FESearchResult *filteredMoreResult = [moreResult resultFilteredWithTags:self.currentFilter];
    [self.filteredResult.photos appendPhotoList:filteredMoreResult.photos];
    
    [self.delegate searchLogicDidFetchMoreResult];
}

/**
 Fetch more search result
 */
-(void) fetchMoreSearchResult{
    if (self.loadingMore) {
        return;//already loading more
    }
    
    //only load more if have more
    if ([self.searchResult hasMorePageAfter:self.currentPage]) {
        self.currentPage ++;
        self.loadingMore = YES;
        
        switch (self.searchMode) {
            case FESearchModeLocation:
                [self searchMoreWithCurrentLocation];
                break;
            case FESearchModeText:
                [self searchMoreWithCurrentSearchText];
                break;
            case FESearchModeTags:
                [self searchMoreWithCurrentSearchTags];
                break;
            case FESearchModeIdle:
                //not searching for anything
                break;
        }
    }
}

-(void) searchMoreWithCurrentLocation{
    [self.dataProvider searchPhotoWithLatitude:self.searchLocation.coordinate.latitude
                                     longitude:self.searchLocation.coordinate.longitude
                                          page:self.currentPage
                                       success:^(FESearchResult *searchResult) {
                                           self.loadingMore = NO;
                                           if (self.searchMode == FESearchModeLocation) {
                                               //only update if still searching by location
                                               [self handleExtraSearchResult:searchResult];
                                           }
                                       }
                                          fail:^(NSError *error) {
                                              self.loadingMore = NO;
                                              [self.delegate searchLogicEncounteredError:error];
                                          }];
}

-(void) searchMoreWithCurrentSearchText{
    NSString *text = self.searchText;
    [self.dataProvider searchPhotoWithText:text
                                      tags:nil
                                      page:self.currentPage
                                   success:^(FESearchResult *searchResult) {
                                       self.loadingMore = NO;
                                       if ((self.searchMode == FESearchModeText) && [self.searchText isEqualToString:text]) {
                                           //only update if still searching for the same text
                                           [self handleExtraSearchResult:searchResult];
                                       }
                                   } fail:^(NSError *error) {
                                       self.loadingMore = NO;
                                       [self.delegate searchLogicEncounteredError:error];
                                   }];
}

-(void) searchMoreWithCurrentSearchTags{
    NSArray<NSString*> *tags = self.searchTags;
    [self.dataProvider searchPhotoWithText:nil
                                      tags:tags
                                      page:self.currentPage
                                   success:^(FESearchResult *searchResult) {
                                       self.loadingMore = NO;
                                       if ((self.searchMode == FESearchModeTags) && [self.searchTags isEqualToArray:tags]) {
                                           //only update if still searching for the same tags
                                           [self handleExtraSearchResult:searchResult];
                                       }
                                   } fail:^(NSError *error) {
                                       self.loadingMore = NO;
                                       [self.delegate searchLogicEncounteredError:error];
                                   }];
}

#pragma mark - search result manipulation
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
    
    //if after filtering, we have too few results left, fetch more
    if ([self.filteredResult.photos numberOfPhotos] < FE_MIN_SEARCH_RESULT_FILL_PAGE) {
        [self fetchMoreSearchResult];
    }
}

/**
 Return the most popular tag from the search result.
 
 @param count number of top result to return. E.g passing 10 will return top 10
 @return the most popular tag from the search result.
 */
-(NSArray*) searchResultPopularTags:(NSInteger) count{
    return [self.searchResult.photos mostPopularTag:count];
}

#pragma mark - FELocationProviderDelegate
-(void)locationProviderDidGetCurrentLocation:(CLLocation *)currentLocation{
    //update search location
    self.searchLocation = currentLocation;
    if (self.searchMode == FESearchModeLocation) {
        //if still in search mode location aka user have not inititated a different search yet
        [self searchPhotoWithLocation:currentLocation];
    }
}
-(void)locationProviderDidFailGettingLocation:(NSError *)error{
    [self.delegate searchLogicEncounteredError:error];
}
@end
