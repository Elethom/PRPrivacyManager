//
//  PrivacyListItem.m
//  PRPrivacyManagerDemo
//
//  Created by Elethom Hunter on 15/01/2015.
//  Copyright (c) 2015 Project Rhinestone. All rights reserved.
//

#import "PrivacyListItem.h"

@implementation PrivacyListItem

#pragma mark - Getters and setters

- (PRPrivacyStatus)status {
    return [PRPrivacyManager privacyStatusForType:self.type];
}

- (NSString *)typeString {
    switch (self.type) {
        case PRPrivacyTypeContacts:
            return @"Contacts";
        case PRPrivacyTypePhotos:
            return @"Photos";
        case PRPrivacyTypeMicrophone:
            return @"Microphone";
        case PRPrivacyTypeCamera:
            return @"Camera";
        default:
            return nil;
    }
}

- (NSString *)statusString {
    switch (self.status) {
        case PRPrivacyStatusNotDetermined:
            return @"Not Determined";
        case PRPrivacyStatusRestricted:
            return @"Restricted";
        case PRPrivacyStatusDenied:
            return @"Denied";
        case PRPrivacyStatusAuthorized:
            return @"Authorized";
        default:
            return nil;
    }
}

#pragma mark - Life cycle

+ (instancetype)itemWithType:(PRPrivacyType)type {
    id item = [[self alloc] init];
    [item setType:type];
    return item;
}

@end
