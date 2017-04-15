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

static NSString * const FEPhotoCollectionViewCellIdentifier = @"FEPhotoCollectionViewCellIdentifier";
static int const FE_GRID_COLUMN_COUNT = 3;
static CGFloat const FE_GRID_MARGIN   = 5;
@interface FESearchViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, FESearchLogicDelegate>

@property (nonatomic, strong) FESearchLogic         *searchLogic;
@property (nonatomic, strong) id<FEImageProvider>   imageProvider;
//views
@property (nonatomic, strong) UISearchBar           *searchBar;
@property (nonatomic, strong) UICollectionView      *collectionView;
@property (nonatomic, strong) UIView                *tagContainer;
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
    //create a basic view with a UICollectionView as subview
    UIView *view = [UIView new];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    [view addSubview:self.collectionView];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupConstraints];
    [self setupCollectionView];
    [self setupSearchBar];
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
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"collectionView":self.collectionView}]
     ];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"collectionView":self.collectionView}]
     ];
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
    self.searchBar.searchBarStyle = UISearchBarStyleProminent;
    self.searchBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    self.searchBar.delegate = self;
    self.searchBar.translucent = NO;
    [self.searchBar becomeFirstResponder];
}

-(void) showDetailForPhoto:(FEPhoto*) photo{
    [self.navigationController pushViewController:[FEPhotoDetailViewController viewControllerWithPhoto:photo
                                                                                         dataProvider:self.searchLogic.dataProvider
                                                                                        imageProvider:self.imageProvider]
                                         animated:YES];
}
#pragma mark - search logic delegate
-(void)searchLogicDidUpdateResult{
    [self.searchBar sizeToFit];
    [self.collectionView reloadData];
}
-(void) searchLogicEncounteredError:(NSError *)error{
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
    [self.searchLogic searchPhotoPhotoWithText:searchBar.text];
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
@end
