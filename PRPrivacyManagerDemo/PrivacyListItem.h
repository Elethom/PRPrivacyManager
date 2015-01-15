//
//  PrivacyListItem.h
//  PRPrivacyManagerDemo
//
//  Created by Elethom Hunter on 15/01/2015.
//  Copyright (c) 2015 Project Rhinestone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRPrivacyManager.h"

@interface PrivacyListItem : NSObject

@property (nonatomic) PRPrivacyType type;
@property (nonatomic, readonly) PRPrivacyStatus status;

@property (nonatomic, readonly) NSString *typeString;
@property (nonatomic, readonly) NSString *statusString;

+ (instancetype)itemWithType:(PRPrivacyType)type;

@end
