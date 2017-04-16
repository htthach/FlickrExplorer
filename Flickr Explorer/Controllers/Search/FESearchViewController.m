//
//  FESearchViewController.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 12/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FESearchViewController.h"
#import "FEPhotoCollectionViewCell.h"
#import "FESearchLogic.h"
#import "FEHelper.h"
#import "FEPhoto.h"
#import "FEPhotoDetailViewController.h"
#import "FELoadingIndicatorView.h"
#import "FETagSelectionView.h"
static NSString * const FEPhotoCollectionViewCellIdentifier = @"FEPhotoCollectionViewCellIdentifier";
static int const FE_GRID_COLUMN_COUNT = 3;  //number of column to display search result
static int const FE_MAX_TAG_COUNT     = 10; //maximum number of tag to display for filtering
static CGFloat const FE_GRID_MARGIN   = 5;
@interface FESearchViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, FESearchLogicDelegate, FETagSelectionViewDelegate>

@property (nonatomic, strong) FESearchLogic         *searchLogic;
@property (nonatomic, strong) id<FEImageProvider>   imageProvider;
//views
@property (nonatomic, strong) UISearchBar           *searchBar;
@property (nonatomic, strong) UICollectionView      *collectionView;
@property (nonatomic, strong) FETagSelectionView    *tagBanner;
@property (nonatomic, strong) NSLayoutConstraint    *tagBannerHeightConstraint;
@property (nonatomic, strong) FELoadingIndicatorView *loadingIndicator;
@end

@implementation FESearchViewController
/**
 Factory method to return an instance of this view controller utilizing the given data and image provider
 
 @param dataProvider data provider to talk to API
 @param imageProvider image provider to load image
 @return an instance of FESearchViewController
 */
+(instancetype) viewControllerWithDataProvider:(id<FEDataProvider>) dataProvider imageProvider:(id<FEImageProvider>) imageProvider{
    return [[FESearchViewController alloc] initWithDataProvider:dataProvider imageProvider:imageProvider];
}

/**
 Initialize with basic search logic
 
 @param dataProvider data provider to talk to API
 @param imageProvider image provider to load image
 @return an instance of FESearchViewController
 */
-(instancetype)initWithDataProvider:(id<FEDataProvider>) dataProvider imageProvider:(id<FEImageProvider>) imageProvider{
    self = [super init];
    if (self) {
        self.searchLogic = [[FESearchLogic alloc] initWithDataProvider:dataProvider delegate:self];
        self.imageProvider = imageProvider;
    }
    return self;
}

#pragma mark - view life cycle
-(void)loadView{
    //create a basic view with a UICollectionView and a tag selection banner as subview
    UIView *view = [UIView new];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.tagBanner = [[FETagSelectionView alloc] initWithFrame:CGRectZero];
    self.tagBanner.delegate = self;
    [view addSubview:self.tagBanner];
    [view addSubview:self.collectionView];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupConstraints];
    [self setupCollectionView];
    [self setupSearchBar];
    [self setupOtherViews];
    
    //initially, we search for nearby photo
    [self performSearchNearby];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - view setup helper
-(void) setupConstraints{
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tagBanner setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tagBanner]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"tagBanner":self.tagBanner}]
     ];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"collectionView":self.collectionView}]
     ];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tagBanner][collectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"tagBanner":self.tagBanner,
                                                                                @"collectionView":self.collectionView}]
     ];
    
    //banner height = 0 at the beginning
    self.tagBannerHeightConstraint = [NSLayoutConstraint constraintWithItem:self.tagBanner
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:0];
    [self.view addConstraint:self.tagBannerHeightConstraint];
}

-(void) setupCollectionView{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[FEPhotoCollectionViewCell nib] forCellWithReuseIdentifier:FEPhotoCollectionViewCellIdentifier];
}

-(void) setupSearchBar{
    self.searchBar = [UISearchBar new];
    self.searchBar.placeholder = NSLocalizedString(@"Search Photo", @"Search bar title");
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.tintColor = self.navigationController.navigationBar.tintColor;
    self.searchBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    self.searchBar.delegate = self;
    self.searchBar.translucent = NO;
}

-(void) setupOtherViews{
    UIBarButtonItem *tagButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Tags", @"Tags button")
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(tagButtonPressed:)];
    self.navigationItem.rightBarButtonItem = tagButton;
    
    self.loadingIndicator = [[FELoadingIndicatorView alloc] initInside:self.view];
}

#pragma mark - functional methods
-(void) performSearchNearby{
    [self.loadingIndicator startAnimating];
    [self.searchLogic searchNearbyPhoto];
}
-(void) performSearchWithText:(NSString*) text{
    [self.loadingIndicator startAnimating];
    [self.searchLogic searchPhotoWithText:text];
}
-(void) performSearchWithTags:(NSArray<NSString*>*)tags{
    self.searchBar.text = @"";//to avoid confusion, we clear search bar text
    [self.loadingIndicator startAnimating];
    [self.searchLogic searchPhotoWithTags:tags];
}
-(void) showDetailForPhoto:(FEPhoto*) photo{
    [self.navigationController pushViewController:[FEPhotoDetailViewController viewControllerWithPhoto:photo
                                                                                          dataProvider:self.searchLogic.dataProvider
                                                                                         imageProvider:self.imageProvider]
                                         animated:YES];
}
-(void) toggleTagSelectionBanner{
    
    if (self.tagBannerHeightConstraint.constant > 0.0001) {
        //banner is shown => hide it
        self.tagBannerHeightConstraint.constant = 0;
    }
    else {
        //banner is hiden => show it
        self.tagBannerHeightConstraint.constant = [self.tagBanner recommendedHeight];
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}
-(void) resetContent{
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointZero animated:NO];
}
#pragma mark - search logic delegate
-(void)searchLogicDidRefreshResult{
    [self.loadingIndicator stopAnimating];
    [self.tagBanner updateTags: [self.searchLogic searchResultPopularTags:FE_MAX_TAG_COUNT]];
    [self resetContent];
}
-(void)searchLogicDidFilterResult{
    [self resetContent];
}
-(void)searchLogicDidFetchMoreResult{
    [self.collectionView reloadData];
}
-(void) searchLogicEncounteredError:(NSError *)error{
    [self.loadingIndicator stopAnimating];
    //for now we just simply display the message in the error object
    [FEHelper showError:error inViewController:self];
}

#pragma mark - UICollectionViewDelegate

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(FE_GRID_MARGIN, FE_GRID_MARGIN, FE_GRID_MARGIN, FE_GRID_MARGIN);
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    //calculate size to fit FE_GRID_COLUMN_COUNT columns. Round down to int
    int squareSide = (collectionView.frame.size.width / FE_GRID_COLUMN_COUNT) - 2*FE_GRID_MARGIN;
    return CGSizeMake(squareSide, squareSide);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self showDetailForPhoto:[self.searchLogic photoToDisplayAtIndex:indexPath.row]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        BOOL contentSizeGreaterThanCollectionViewFrame = (scrollView.contentSize.height > CGRectGetHeight(scrollView.frame));
        if (!contentSizeGreaterThanCollectionViewFrame) {
            return;
        }
        
        CGFloat yOffset = scrollView.contentOffset.y;
        
        //Load more data when scroll reaches over 70%
        //Only consider loading more if the ratio is less than 1.0 which means the content size height greater than frame height and greater than 0.7 which means the scrolling is over 70% of content.
        CGFloat ratio = (yOffset + CGRectGetHeight(scrollView.frame) ) / scrollView.contentSize.height;
        if (scrollView.contentSize.height > 0 && contentSizeGreaterThanCollectionViewFrame  && (ratio - 0.7 > 0.001) ) {
            [self.searchLogic fetchMoreSearchResult];
        }
        

        //if scrolled to the end of its content height
        if (yOffset + CGRectGetHeight(scrollView.frame) >= scrollView.contentSize.height) {
            return;
        }
    }
}
#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.searchLogic numberOfPhotosToShow];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FEPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FEPhotoCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell showPhoto:[self.searchLogic photoToDisplayAtIndex:indexPath.row] usingImageProvider:self.imageProvider];
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self performSearchWithText:searchBar.text];
    self.searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}
#pragma mark - FETagSelectionViewDelegate

-(void) tagSelectionViewDidSelectTags:(NSArray<NSString*>*)tags{
    [self.searchLogic filterResultByTags:tags];
    [self resetContent];
}

-(void) tagSelectionViewDidClearTagSelection{
    [self.searchLogic filterResultByTags: nil];
    [self resetContent];
}

-(void) tagSelectionViewDidChooseSearchWithTags:(NSArray<NSString*>*)tags{
    [self performSearchWithTags:tags];
}

-(void) tagSelectionViewNeedUpdateHeight:(CGFloat) height{
    if (self.tagBannerHeightConstraint.constant >= 0.0001) {
        //banner is showing, adjust height
        self.tagBannerHeightConstraint.constant = [self.tagBanner recommendedHeight];
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
    }
    //else banner is hidden, ignore
}
#pragma mark - user interactions
-(void) tagButtonPressed:(UIBarButtonItem*) sender{
    [self toggleTagSelectionBanner];
}
@end
