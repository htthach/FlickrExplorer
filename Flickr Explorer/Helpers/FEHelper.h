//
//  FEHelper.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FEHelper : NSObject


/**
 Check if string containt at least 1 non space character

 @param string target string to check
 @return YES if string is nil, or just contains spaces and new lines. NO otherwise
 */
+(BOOL) isEmptyString:(NSString*) string;


/**
 Simple error handling by displaying everything to user.

 @param error error to show
 @param viewController the view controller to show this error message in
 */
+(void) showError:(NSError*) error inViewController:(UIViewController*) viewController;


/**
 Placeholder for missing image

 @return placeholder for missing image
 */
+(UIImage*) imagePlaceholder;
@end
