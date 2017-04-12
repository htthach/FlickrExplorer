//
//  FESearchViewController.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 12/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FESearchViewController.h"
#import "FEPhotoCollectionViewCell.h"

#define FEPhotoCollectionViewCellIdentifier @"FEPhotoCollectionViewCellIdentifier"

@interface FESearchViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation FESearchViewController

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
#pragma mark - collection view delegate

#pragma mark - collection view data source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FEPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FEPhotoCollectionViewCellIdentifier forIndexPath:indexPath];
    return cell;
}
@end
