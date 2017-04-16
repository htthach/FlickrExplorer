//
//  FEPhotoList.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEPhotoList.h"
#import "FEPhoto.h"

@implementation FEPhotoList
/**
 Return the key map between json key vs this object property name. By default we set property name same as json tag.
 Child class can override this if there is mismatch between object property name and json tag.
 
 @return the key map between json key vs this object property name
 */
-(NSMutableDictionary *)getKeyMap{
    NSMutableDictionary *keyMap = [super getKeyMap];
    [keyMap setObject:@"perPage" forKey:@"perpage"];
    return keyMap;
}
/**
 if there is a property of type array, return the class of that array's elements
 
 @param arrayName name of that property
 @return class of the array's elements
 */
-(Class) getClassForArrayName:(NSString*) arrayName{
    if ([arrayName isEqualToString:@"photo"]) {
        return [FEPhoto class];
    }
    return [super getClassForArrayName:arrayName];
}

/**
 Return number of photo in this result
 
 @return Return number of photo in this result
 */
-(NSInteger) numberOfPhotos{
    return [self.photo count];
}

/**
 Get a photo at an index from this list
 
 @param index index of the requested photo
 @return a photo at an index from this list
 */
-(FEPhoto*) photoAtIndex:(NSInteger) index{
    if (index >= 0 && index < [self.photo count]) {
        return self.photo[index];
    }
    return nil;
}

/**
 Append other photo list into this list. And update with the new list page info
 
 @param otherPhotos the other photo list to append
 */
-(void) appendPhotoList:(FEPhotoList*) otherPhotos{
    if ([otherPhotos.photo count] <= 0) {
        return;//nothing to do
    }
    
    //update page info
    self.page = otherPhotos.page;
    self.pages = otherPhotos.pages;
    
    //if this list is empty, just use the other list
    if (!self.photo) {
        self.photo = otherPhotos.photo;
        return;
    }
    
    //combine
    NSMutableArray *combined = [NSMutableArray arrayWithArray:self.photo];
    [combined addObjectsFromArray: otherPhotos.photo];
    
    self.photo = [NSArray arrayWithArray:combined];
}
@end
