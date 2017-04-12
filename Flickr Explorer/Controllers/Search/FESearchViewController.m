//
//  FESearchViewController.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 12/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FESearchViewController.h"

@interface FESearchViewController ()

@end

@implementation FESearchViewController

-(void)loadView{
    UIView *view = [UIView new];//[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor yellowColor];
    self.view = view;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
