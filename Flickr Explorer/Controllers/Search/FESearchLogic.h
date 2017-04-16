//
//  FESearchLogic.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 13/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FEDataProvider;
@class FEPhoto;

@protocol FESearchLogicDelegate <NSObject>

-(void) searchLogicDidRefreshResult;
-(void) searchLogicDidFetchMoreResult;
-(void) searchLogicEncounteredError:(NSError*) error;

@end


/**
 This class will handle most of searching logic. We try to keep the view controller dumb.
 */
@interface FESearchLogic : NSObject
@property (nonatomic, strong) id<FEDataProvider> dataProvider;
@property (weak) id<FESearchLogicDelegate> delegate;

/**
 Initialize this class utilizing the given data provider and delegate

 @param dataProvider data provider to talk to API
 @param delegate     callback delegate
 @return an instance of FESearchLogic
 */
-(instancetype) initWithDataProvider:(id<FEDataProvider>) dataProvider delegate:(id<FESearchLogicDelegate>) delegate;

/**
 Start searching for photo given the input text from user
 
 @param text the input text to search photo
 */
-(void) searchPhotoWithText:(NSString*) text;

/**
 Start searching for photo given the selected tag
 
 @param tag tag to search photo by
 */
-(void) searchPhotoWithTag:(NSString*) tag;

/**
 Fetch more search result from current search criteria
 */
-(void) fetchMoreSearchResult;

/**
 Number of photo to show from search result

 @return Number of photo to show from search result
 */
-(NSInteger) numberOfPhotosToShow;

/**
 Return a photo of the search result at an index

 @param index index of the photo
 @return a photo of the search result at an index
 */
-(FEPhoto*) photoToDisplayAtIndex:(NSInteger) index;


/**
 From now on, all search result will be filtered by this tag.

 @param tag tag to filter result by. If pass nil, clear all tag filter.
 */
-(void) filterResultByTag:(NSString*) tag;


/**
 Return the most popular tag from the search result.
 
 @param count number of top result to return. E.g passing 10 will return top 10
 @return the most popular tag from the search result.
 */
-(NSArray*) searchResultPopularTags:(NSInteger) count;
@end
