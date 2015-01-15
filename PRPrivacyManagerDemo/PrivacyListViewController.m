//
//  PrivacyListViewController.m
//  PRPrivacyManagerDemo
//
//  Created by Elethom Hunter on 15/01/2015.
//  Copyright (c) 2015 Project Rhinestone. All rights reserved.
//

#import "PrivacyListViewController.h"
#import "PrivacyListViewModel.h"
#import "PrivacyListTableViewCell.h"

NSString * const kPRPrivacyListCellIdentifier = @"privacy";

@interface PrivacyListViewController ()

@property (nonatomic, copy) PrivacyListViewModel *viewModel;

@end

@implementation PrivacyListViewController

#pragma mark - Getters and setters

- (PrivacyListViewModel *)viewModel {
    return _viewModel = _viewModel ?: [[PrivacyListViewModel alloc] init];
}

#pragma mark - Override

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Privacy";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[PrivacyListTableViewCell class]
           forCellReuseIdentifier:kPRPrivacyListCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    PrivacyListItem *item = self.viewModel.listItems[section][row];
    __weak typeof(self) weakSelf = self;
    [PRPrivacyManager authorizeWithType:item.type
                             completion:^(PRPrivacyStatus status) {
                                 [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath]
                                                           withRowAnimation:UITableViewRowAnimationAutomatic];
                             }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.listItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.listItems[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrivacyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPRPrivacyListCellIdentifier
                                                                     forIndexPath:indexPath];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    PrivacyListItem *item = self.viewModel.listItems[section][row];
    [cell setupWithItem:item];
    return cell;
}

@end
