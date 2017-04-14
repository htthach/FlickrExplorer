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
@end
