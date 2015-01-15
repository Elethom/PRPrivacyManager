//
//  PrivacyListTableViewCell.h
//  PRPrivacyManagerDemo
//
//  Created by Elethom Hunter on 15/01/2015.
//  Copyright (c) 2015 Project Rhinestone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrivacyListItem;

@interface PrivacyListTableViewCell : UITableViewCell

- (void)setupWithItem:(PrivacyListItem *)item;

@end
