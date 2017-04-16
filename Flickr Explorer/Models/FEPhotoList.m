//
//  FEPhotoList.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEPhotoList.h"
#import "FEPhoto.h"
#import "FEHelper.h"
@implementation FEPhotoList
/**
 Return the key map between json key vs this object property name. By default we set property name same as json tag.
 Child class can override this if there is mismatch between object property name and json tag.
 
 @return the key map between json key vs this object property name
 */
-(NSMutableDictionary *)getKeyMap{
    NSMutableDictionary *keyMap = [super getKeyMap];
    [keyMap setObject:@"perPage" forKey:@"perpage"];
    [keyMap setObject:@"photos" forKey:@"photo"];
    return keyMap;
}
/**
 if there is a property of type array, return the class of that array's elements
 
 @param arrayName name of that property
 @return class of the array's elements
 */
-(Class) getClassForArrayName:(NSString*) arrayName{
    if ([arrayName isEqualToString:@"photos"]) {
        return [FEPhoto class];
    }
    return [super getClassForArrayName:arrayName];
}

/**
 Return number of photo in this result
 
 @return Return number of photo in this result
 */
-(NSInteger) numberOfPhotos{
    return [self.photos count];
}

/**
 Get a photo at an index from this list
 
 @param index index of the requested photo
 @return a photo at an index from this list
 */
-(FEPhoto*) photoAtIndex:(NSInteger) index{
    if (index >= 0 && index < [self.photos count]) {
        return self.photos[index];
    }
    return nil;
}

/**
 Append other photo list into this list. And update with the new list page info
 
 @param otherPhotos the other photo list to append
 */
-(void) appendPhotoList:(FEPhotoList*) otherPhotos{
    if ([otherPhotos.photos count] <= 0) {
        return;//nothing to do
    }
    
    //update page info
    self.page = otherPhotos.page;
    self.pages = otherPhotos.pages;
    
    //if this list is empty, just use the other list
    if (!self.photos) {
        self.photos = otherPhotos.photos;
        return;
    }
    
    //combine
    NSMutableArray *combined = [NSMutableArray arrayWithArray:self.photos];
    [combined addObjectsFromArray: otherPhotos.photos];
    
    self.photos = [NSArray arrayWithArray:combined];
}


/**
 Get most popular tags in the photo list
 
 @param count max count of the return list
 @return most popular tags in the photo list
 */
-(NSArray<NSString*>*) mostPopularTag:(NSUInteger) count{
    
    //create a tag count
    NSMutableDictionary *tagCount = [NSMutableDictionary dictionary];
    for (FEPhoto *photo in self.photos) {
        NSArray *tags = [photo tagArray];
        for (NSString *tag in tags) {
            if (![FEHelper isEmptyString:tag]) {
                NSNumber *currentCount = tagCount[tag];
                if (!currentCount) {
                    tagCount[tag] = @(1);
                }
                else {
                    tagCount[tag] = [NSNumber numberWithInteger:([currentCount integerValue] + 1)];
                }
            }
        }
    }
    
    //sort desc
    NSArray *sortedTags = [tagCount keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [((NSNumber*) obj2) compare:(NSNumber*) obj1]; //sort desc
    }];
    
    
    //get top count tags
    NSInteger resultCount = MIN(count, [sortedTags count]);
    return [sortedTags subarrayWithRange:NSMakeRange(0, resultCount)];
}


/**
 Create new photo list that contain only photos matching filter tags.
 
 @param tags tags to filter the photo list by
 @return a new photo list that contain only photos matching filter tags.
 */
-(FEPhotoList*) photoListFilteredWithTags:(NSArray<NSString*>*) tags{
    NSMutableArray *matchingPhotos = [NSMutableArray array];
    for (FEPhoto *photo in self.photos) {
        if ([photo containsTags:tags]) {
            [matchingPhotos addObject:photo];
        }
    }
    FEPhotoList *result = [FEPhotoList new];
    result.photos = [NSArray arrayWithArray:matchingPhotos];
    result.page = self.page;
    result.pages = self.pages;
    result.perPage = self.perPage;
    return result;
}

/**
 Check if this list contain a photo
 
 @param photo photo to check
 @return YES if there is a same photo in the list
 */
-(BOOL) containsPhoto:(FEPhoto*) photo{
    return [self.photos containsObject:photo];
}
@end
