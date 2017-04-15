//
//  FEImageProvider.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 15/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FEPhoto.h"
@protocol FEImageProvider <NSObject>

/**
 Download a photo from flickr
 
 @param photo the photo object containing info about the photo to download. A cached version will be returned if downloaded this before.
 @param size expected size to download
 @param success success callback block
 @param fail fail callback block
 */
-(void) downloadImageForPhoto:(FEPhoto*) photo
                         size:(FEPhotoSize) size
                      success:(void (^)(UIImage *image)) success
                         fail:(void (^)(NSError *error)) fail;
@end
