//
//  FETagSelectionView.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 16/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FETagSelectionView.h"
#import "FEUITheme.h"
static int const FE_MARGIN = 5;

@interface FETagSelectionView ()
@property (nonatomic, strong) NSArray           *tags;
@property (nonatomic, strong) NSMutableArray    *tagButtons;
@property (nonatomic, strong) NSString          *selectedTag;
@property (nonatomic)         CGFloat           contentHeight;
@property (nonatomic, strong) UIButton          *clearButton;
@property (nonatomic, strong) UIButton          *searchButton;
@end

@implementation FETagSelectionView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self updateTags:nil];
    }
    return self;
}


/**
 Recommended height for this view to fit content nicely
 
 @return Recommended height for this view to fit content nicely
 */
-(CGFloat) recommendedHeight{
    return self.contentHeight;
}

/**
 Reset content with new set of tags
 
 @param tags tag to set
 */
-(void) updateTags:(NSArray*) tags{
    self.tags = tags;
    self.selectedTag = nil;
    
    //clear old subviews
    NSArray *oldViews = self.subviews;
    for (UIView *oldView in oldViews) {
        [oldView removeFromSuperview];
    }
    
    self.tagButtons = [NSMutableArray new];
    
    //add new tags
    CGFloat margin = FE_MARGIN;
    CGFloat left = margin;
    CGFloat top = margin;
    CGFloat bottom = top;
    CGFloat containerWidth = self.frame.size.width;
    
    for (NSString *tag in self.tags) {
        CGSize size = [self estimatedSizeForText:tag];
        CGRect frame = CGRectMake(left, top, size.width, size.height);
        if (left > margin && containerWidth - size.width < left) {
            //don't have space for another tag, add on next line
            top += margin + size.height;
            left = margin;
            frame = CGRectMake(left, top, size.width, size.height);
        }
        
        UIButton *tagButton = [self buttonWithFrame: frame title:tag];
        [tagButton addTarget:self action:@selector(tagButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tagButton];
        [self.tagButtons addObject:tagButton];
        
        //move the left margin
        left += margin + size.width;
        bottom = top + size.height;
    }
    
    //add default button
    bottom = [self addDefaultButtonsBelow: bottom];
    
    //initially nothing is selected
    [self updateSelectedTag: nil];
    
    //update content height
    self.contentHeight = bottom + margin;
    
    //inform delegate to update height if needed
    [self.delegate tagSelectionViewNeedUpdateHeight:self.contentHeight];
}

-(UIFont *) tagFont{
    return [UIFont systemFontOfSize: 12];
}
/**
 Add default buttom below a Y coordinate and return the new Y coordinate below the button

 @param belowY new button should be below this
 @return bottom of the button
 */
-(CGFloat) addDefaultButtonsBelow:(CGFloat) belowY{
    CGFloat margin = FE_MARGIN;
    NSString *title = NSLocalizedString(@"Clear Filter", @"Clear Filter");
    CGSize size = [self estimatedSizeForText: title];
    CGFloat left = margin;
    CGFloat top = belowY + margin;
    CGRect frame = CGRectMake(left, top, size.width, size.height);
    self.clearButton = [self buttonWithFrame: frame title:title];
    [self.clearButton addTarget:self action:@selector(clearFilterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clearButton];
    
    left += margin + size.width;
    title = NSLocalizedString(@"Search With Tag", @"Search With Tag");
    size = [self estimatedSizeForText: title];
    frame = CGRectMake(left, top, size.width, size.height);
    self.searchButton = [self buttonWithFrame: frame title:title];
    [self.searchButton addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.searchButton];
    
    return top + size.height;
}
/**
 Create button for a string

 @param frame frame of the button
 @param title title of the button
 @return a tag button
 */
-(UIButton*) buttonWithFrame:(CGRect) frame title:(NSString*) title{
    UIButton *tagButton = [[UIButton alloc] initWithFrame:frame];
    [tagButton setBackgroundColor:[UIColor whiteColor]];
    [tagButton.titleLabel setFont:[self tagFont]];
    tagButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tagButton.layer.cornerRadius = frame.size.height/2;
    tagButton.layer.borderWidth = 1;
    [tagButton setTitle:title forState:UIControlStateNormal];
    [tagButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [tagButton setTitleColor:[FEUITheme primaryColorDark] forState:UIControlStateSelected];
    tagButton.autoresizingMask = UIViewAutoresizingNone;
    return tagButton;
}

/**
 Estimate the size to nicely fit a text string

 @param text text to check size
 @return size to fit the text
 */
-(CGSize) estimatedSizeForText:(NSString*) text{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[self tagFont]}];
    return CGSizeMake(size.width + FE_MARGIN*4, size.height + FE_MARGIN*2);
}

-(void) unselectAllTagButtons{
    for (UIButton *button in self.tagButtons) {
        [button setSelected:NO];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [button setBackgroundColor:[UIColor whiteColor]];
    }
}

-(void) updateSelectedTag:(NSString*) tag{
    self.selectedTag = tag;
    //hide buttons if no tag, show if has tag
    self.clearButton.hidden = tag?NO:YES;
    self.searchButton.hidden = tag?NO:YES;
}

-(void) updateButtonToSelectedState:(UIButton*) button{
    //update a tag button to selected state
    [button setSelected:YES];
    button.layer.borderColor = [FEUITheme primaryColorDark].CGColor;
    [button setBackgroundColor:[FEUITheme primaryColorLight]];
}
#pragma mark - user interaction

-(void) tagButtonPressed:(UIButton*) sender{
    [self updateSelectedTag: sender.titleLabel.text];
    [self unselectAllTagButtons];
    [self updateButtonToSelectedState:sender];
    [self.delegate tagSelectionViewDidSelectTag:sender.titleLabel.text];
}

-(void) clearFilterButtonPressed:(UIButton*) sender{
    [self updateSelectedTag: nil];
    [self.delegate tagSelectionViewDidClearTagSelection];
}

-(void) searchButtonPressed:(UIButton*) sender{
    [self.delegate tagSelectionViewDidChooseSearchWithTag:self.selectedTag];
}
@end
