//
//  PrivacyListTableViewCell.m
//  PRPrivacyManagerDemo
//
//  Created by Elethom Hunter on 15/01/2015.
//  Copyright (c) 2015 Project Rhinestone. All rights reserved.
//

#import "PrivacyListTableViewCell.h"
#import "PrivacyListItem.h"

@implementation PrivacyListTableViewCell

- (void)setupWithItem:(PrivacyListItem *)item {
    self.textLabel.text = item.typeString;
    self.detailTextLabel.text = item.statusString;
}

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}

@end
