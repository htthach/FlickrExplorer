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

#define FEPhotoCollectionViewCellIdentifier @"FEPhotoCollectionViewCellIdentifier"

@interface FESearchViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FESearchLogicDelegate>
@property (nonatomic, strong) UICollectionView      *collectionView;
@property (nonatomic, strong) FESearchLogic         *searchLogic;
@property (nonatomic, strong) id<FEImageProvider>   imageProvider;
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
    UIView *view = [UIView new];//[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor yellowColor];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    [view addSubview:self.collectionView];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupConstraints];
    [self setupCollectionView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.searchLogic searchPhotoPhotoWithText:@"flower dome"];
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
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[FEPhotoCollectionViewCell nib] forCellWithReuseIdentifier:FEPhotoCollectionViewCellIdentifier];
}
#pragma mark - search logic delegate
-(void)searchLogicDidUpdateResult{
    [self.collectionView reloadData];
}
-(void) searchLogicEncounteredError:(NSError *)error{
    //for now we just simply display the message in the error object
    [FEHelper showError:error inViewController:self];
}
#pragma mark - collection view delegate

#pragma mark - collection view data source
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
@end
