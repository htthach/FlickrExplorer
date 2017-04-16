//
//  FEPhotoDetailViewController.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 15/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEPhotoDetailViewController.h"
#import "FEPhoto.h"
#import "FEImageProvider.h"
#import "FEDataProvider.h"
#import "FEHelper.h"
#import "FEPhotoInfoResult.h"
#import "FELoadingIndicatorView.h"
#import "FEUITheme.h"

@interface FEPhotoDetailViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView   *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView    *imageView;
@property (weak, nonatomic) IBOutlet UIView         *infoContainer;
@property (weak, nonatomic) IBOutlet UILabel        *descriptionLabel;
@property (nonatomic, strong) FELoadingIndicatorView *loadingIndicator;

@property (nonatomic, strong) FEPhoto               *currentPhoto;
@property (nonatomic, strong) id<FEImageProvider>   imageProvider;
@property (nonatomic, strong) id<FEDataProvider>    dataProvider;
@end

@implementation FEPhotoDetailViewController

/**
 Factory method to return an instance of this view controller utilizing the given data and image provider
 
 @param photo the photo to show in this view controller
 @param dataProvider data provider to talk to API
 @param imageProvider image provider to load image
 @return an instance of FESearchViewController
 */
+(instancetype) viewControllerWithPhoto:(FEPhoto*) photo dataProvider:(id<FEDataProvider>) dataProvider imageProvider:(id<FEImageProvider>) imageProvider{
    FEPhotoDetailViewController *viewController = [[FEPhotoDetailViewController alloc] initWithNibName:NSStringFromClass([FEPhotoDetailViewController class])
                                                                                                bundle:nil];
    viewController.currentPhoto = photo;
    viewController.dataProvider = dataProvider;
    viewController.imageProvider = imageProvider;
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupScrollView];
    self.infoContainer.backgroundColor = [FEUITheme primaryColorLight];
    self.loadingIndicator = [[FELoadingIndicatorView alloc] initFullyInside:self.infoContainer];
    self.descriptionLabel.textColor = [FEUITheme primaryColorDark];
    self.title = self.currentPhoto.title.content;
    [self loadPhotoInfo];
    [self loadImageForSize: FEPhotoSizeLarge];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupScrollView{
    self.scrollView.backgroundColor = [FEUITheme primaryColorLight];
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale=6.0;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
}
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
#pragma mark - user interaction

/**
 If user double tap, we zoom in if not zoom yet.
 If already zoom, we zoom out to reset.

 @param sender gesture recognizer
 */
-(void) handleDoubleTap:(UITapGestureRecognizer*) sender{
    CGPoint touchPoint = [sender locationInView: self.scrollView];
    float scale = 3;
    if (self.scrollView.zoomScale > 1.01){
        //already zoom in, reset by zoom out
        scale = 1;
    }
    
    [self.scrollView zoomToRect:[self zoomRectForScrollView:self.scrollView
                                                  withScale:scale
                                                 withCenter:touchPoint]
                       animated:YES];
}
#pragma mark - functional methods

-(void) loadPhotoInfo{
    [self.loadingIndicator startAnimating];
    [self.dataProvider loadInfoForPhoto:self.currentPhoto
                                success:^(FEPhotoInfoResult *infoResult) {
                                    [self.loadingIndicator stopAnimating];
                                    self.title = self.currentPhoto.title.content;
                                    [self.descriptionLabel setText:[infoResult.photo summaryInfo]];
                                }
                                   fail:^(NSError *error) {
                                       [self.loadingIndicator stopAnimating];
                                       [FEHelper showError:error inViewController:self];
                                   }];
}
-(void) loadImageForSize:(FEPhotoSize) size{
    [self.imageProvider downloadImageForPhoto:self.currentPhoto
                                         size:size
                                      success:^(UIImage *image) {
                                          [self.imageView setImage:image];
                                      }
                                         fail:^(NSError *error) {
                                             [FEHelper showError:error inViewController:self];
                                         }];
}

#pragma mark - helper methods

- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}
@end
