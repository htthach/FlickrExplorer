//
//  FEPhoto.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEPhoto.h"

@implementation FEPhoto
/**
 Return the key map between json key vs this object property name. By default we set property name same as json tag.
 Child class can override this if there is mismatch between object property name and json tag.
 
 @return the key map between json key vs this object property name
 */
-(NSMutableDictionary *)getKeyMap{
    NSMutableDictionary *keyMap = [super getKeyMap];
    [keyMap setObject:@"photoId" forKey:@"id"];
    [keyMap setObject:@"isPublic" forKey:@"ispublic"];
    [keyMap setObject:@"isFriend" forKey:@"isfriend"];
    [keyMap setObject:@"isFamily" forKey:@"isfamily"];
    [keyMap setObject:@"photoDescription" forKey:@"description"];
    return keyMap;
}

/**
 Check if two photos are the same. Currently we only consider photo id
 
 @param otherPhoto the photo to compare this to
 @return YES if both have same ID.
 */
-(BOOL) isSamePhotoAs:(FEPhoto*) otherPhoto{
    if (otherPhoto.photoId && self.photoId) {
        return [self.photoId isEqualToString:otherPhoto.photoId];
    }
    return NO;
}

/**
 Separate tags properties into an array of tags
 
 @return an array of tags
 */
-(NSArray*) tagArray{
    return [self.tags componentsSeparatedByString:@" "];
}
@end
