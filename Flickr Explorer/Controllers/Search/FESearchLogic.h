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

-(void) searchLogicDidUpdateResult;
-(void) searchLogicEncounteredError:(NSError*) error;

@end


/**
 This class will handle most of searching logic
 */
@interface FESearchLogic : NSObject
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
-(void) searchPhotoPhotoWithText:(NSString*) text;


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

@end
