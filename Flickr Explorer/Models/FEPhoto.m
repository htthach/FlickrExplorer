//
//  FEPhoto.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEPhoto.h"
#import "FEHelper.h"
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
    [keyMap setObject:@"dateUploaded" forKey:@"dateuploaded"];
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
 Check if this photo match some of the tags. Empty tags match with all photos
 
 @param tags tags to check
 @return YES if this photo contains any of those tags
 */
-(BOOL) containsTags:(NSArray<NSString*>*) tags{
    if ([tags count] == 0) {
        return YES; //empty tag match with all photos
    }
    
    NSSet *myTagSet = [NSSet setWithArray:[self tagArray]];
    NSSet *filterSet = [NSSet setWithArray:tags];
    
    //photo is considered contain tags if there is an intersection
    return [myTagSet intersectsSet:filterSet];
}

/**
 Separate tags properties into an array of tags
 
 @return an array of tags
 */
-(NSArray<NSString*>*) tagArray{
    if (self.tags) {
        NSMutableArray *tagArray = [[self.tags componentsSeparatedByString:@" "] mutableCopy];
        [tagArray removeObject:@" "];
        [tagArray removeObject:@","];
        [tagArray removeObject:@"."];
        return [NSArray arrayWithArray:tagArray];
    }
    else {
        return [NSArray new];
    }
}


/**
 Return a summary of this photo
 
 @return summary of this photo
 */
-(NSString*) summaryInfo{
    return [NSString stringWithFormat:NSLocalizedString(@"Owner: %@\nDate Uploaded: %@\nTitle: %@\nDescription: %@", @"Photo summmary"),
            self.owner.username?:@"-",
            [FEHelper formattedDateStringFromTimestamp:self.dateUploaded],
            self.title.content?:@"-",
            self.photoDescription?:@"-"];
}
@end
