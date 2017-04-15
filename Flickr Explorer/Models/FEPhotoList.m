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
@end
