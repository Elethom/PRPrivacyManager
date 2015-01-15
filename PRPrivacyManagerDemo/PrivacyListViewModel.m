//
//  PrivacyListViewModel.m
//  PRPrivacyManagerDemo
//
//  Created by Elethom Hunter on 15/01/2015.
//  Copyright (c) 2015 Project Rhinestone. All rights reserved.
//

#import "PrivacyListViewModel.h"

@interface PrivacyListViewModel ()

@property (nonatomic, copy) NSArray *listItems;

@end

@implementation PrivacyListViewModel

- (NSArray *)listItems {
    if (!_listItems) {
        _listItems = @[@[[PrivacyListItem itemWithType:PRPrivacyTypeContacts],
                         [PrivacyListItem itemWithType:PRPrivacyTypePhotos],
                         [PrivacyListItem itemWithType:PRPrivacyTypeMicrophone],
                         [PrivacyListItem itemWithType:PRPrivacyTypeCamera]]];
    }
    return _listItems;
}

@end
