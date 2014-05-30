//
//  RWDemoViewController.m
//  RWDropdownMenuDemo
//
//  Created by Zhang Bin on 2014-05-30.
//  Copyright (c) 2014年 Zhang Bin. All rights reserved.
//

#import "RWDemoViewController.h"
#import "RWDropdownMenu.h"

@interface RWDemoViewController ()

@property (nonatomic, strong) NSArray *menuItems;

@property (nonatomic, assign) RWDropdownMenuStyle menuStyle;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIPopoverController *popover;

@end

@implementation RWDemoViewController

- (NSArray *)menuItems
{
    if (!_menuItems)
    {
        _menuItems =
        @[
          [RWDropdownMenuItem itemWithText:@"Twitter" image:[UIImage imageNamed:@"icon_twitter"] action:nil],
          [RWDropdownMenuItem itemWithText:@"Facebook" image:[UIImage imageNamed:@"icon_facebook"] action:nil],
          [RWDropdownMenuItem itemWithText:@"Message" image:[UIImage imageNamed:@"icon_message"] action:nil],
          [RWDropdownMenuItem itemWithText:@"Email" image:[UIImage imageNamed:@"icon_email"] action:nil],
          [RWDropdownMenuItem itemWithText:@"Save to Photo Album" image:[UIImage imageNamed:@"icon_album"] action:nil],
          ];
    }
    return _menuItems;
}

- (void)presentMenuFromNav:(id)sender
{
    RWDropdownMenuCellAlignment alignment = RWDropdownMenuCellAlignmentCenter;
    if (sender == self.navigationItem.leftBarButtonItem)
    {
        alignment = RWDropdownMenuCellAlignmentLeft;
    }
    else
    {
        alignment = RWDropdownMenuCellAlignmentRight;
    }
    
    if ([self isInPopover])
    {
        [RWDropdownMenu presentInPopoverFromBarButtonItem:sender withItems:self.menuItems completion:nil];
    }
    else
    {
        [RWDropdownMenu presentFromViewController:self withItems:self.menuItems align:alignment style:self.menuStyle navBarImage:[sender image] completion:nil];
    }
}

- (void)presentStyleMenu:(id)sender
{
    NSArray *styleItems =
    @[
      [RWDropdownMenuItem itemWithText:@"Black Gradient" image:nil action:^{
          self.menuStyle = RWDropdownMenuStyleBlackGradient;
      }],
      [RWDropdownMenuItem itemWithText:@"Translucent" image:nil action:^{
          self.menuStyle = RWDropdownMenuStyleTranslucent;
      }],
      ];
    
    [RWDropdownMenu presentFromViewController:self withItems:styleItems align:RWDropdownMenuCellAlignmentCenter style:self.menuStyle navBarImage:nil completion:nil];
}

- (void)showPopover:(id)sender
{
    RWDemoViewController *vc = [[RWDemoViewController alloc] initWithNibName:nil bundle:nil];
    vc.inPopover = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    [self.popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)loadView
{
    [super loadView];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(presentMenuFromNav:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(presentMenuFromNav:)];
    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithTitle:@"Popover" style:UIBarButtonItemStylePlain target:self action:@selector(showPopover:)]];
    
    if (![self isInPopover])
    {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [titleButton setImage:[[UIImage imageNamed:@"nav_down"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [titleButton setTitle:@"Menu Style" forState:UIControlStateNormal];
        [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
        [titleButton addTarget:self action:@selector(presentStyleMenu:) forControlEvents:UIControlEventTouchUpInside];
        
        [titleButton sizeToFit];
        self.navigationItem.titleView = titleButton;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [self.navigationController setToolbarHidden:NO];
        }
    }
    
    NSString *url = self.isInPopover ? @"http://store.apple.com" : @"http://www.apple.com";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

@end