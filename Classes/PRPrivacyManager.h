//
//  PRPrivacyManager.h
//  PRPrivacyManager
//
//  Created by Elethom Hunter on 12/23/14.
//  Copyright (c) 2014 Project Rhinestone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PRPrivacyType) {
    PRPrivacyTypeContacts,
    PRPrivacyTypePhotos,
    PRPrivacyTypeMicrophone,
    PRPrivacyTypeCamera
};

typedef NS_ENUM(NSUInteger, PRPrivacyStatus) {
    PRPrivacyStatusNotDetermined,
    PRPrivacyStatusRestricted,
    PRPrivacyStatusDenied,
    PRPrivacyStatusAuthorized
};

@interface PRPrivacyManager : NSObject

+ (PRPrivacyStatus)privacyStatusForType:(PRPrivacyType)type;
+ (void)authorizeWithType:(PRPrivacyType)type completion:(void (^)(PRPrivacyStatus status))completion;

@end
