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
@property (nonatomic, strong) id<FEDataProvider> dataProvider;
@property (nonatomic, strong) FESearchResult *searchResult;
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
-(void) searchPhotoPhotoWithText:(NSString*) text{
    [self.dataProvider searchPhotoWithText:text success:^(FESearchResult *searchResult) {
        self.searchResult = searchResult;
        [self.delegate searchLogicDidUpdateResult];
    } fail:^(NSError *error) {
        [self.delegate searchLogicEncounteredError:error];
    }];
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
@end
