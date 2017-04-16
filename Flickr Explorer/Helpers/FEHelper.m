//
//  FEHelper.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEHelper.h"


@implementation FEHelper
/**
 Check if string containt at least 1 non space character
 
 @param string target string to check
 @return YES if string is nil, or just contains spaces and new lines. NO otherwise
 */
+(BOOL) isEmptyString:(NSString*) string{
    NSString *trim = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return (trim == nil || [trim length] == 0);
}

/**
 Simple error handling by displaying everything to user.
 
 @param error error to show
 @param viewController the view controller to show this error message in
 */
+(void) showError:(NSError*) error inViewController:(UIViewController*) viewController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:viewController.title message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}


/**
 Placeholder for missing image
 
 @return placeholder for missing image
 */
+(UIImage*) imagePlaceholder{
    return [UIImage imageNamed:@"PhotoPlaceholder"];
}

/**
 Return a formatted date string from a time stamp
 
 @param timeStamp the time stamp to convert
 @return the formatted date string
 */
+(NSString*) formattedDateStringFromTimestamp:(NSNumber*) timeStamp{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [timeStamp doubleValue]];
    NSString* resultString = [df stringFromDate:date];
    return resultString;
}
@end
