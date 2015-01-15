//
//  PRPrivacyManager.h
//  PRPrivacyManager
//
//  Created by Elethom Hunter on 12/23/14.
//  Copyright (c) 2014 Project Rhinestone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PRPrivacyType) {
    PRPrivacyTypeLocation,
    PRPrivacyTypeContacts,
    PRPrivacyTypePhotos,
    PRPrivacyTypeMicrophone,
    PRPrivacyTypeCamera,
};

typedef NS_ENUM(NSUInteger, PRPrivacySubtype) {
    PRPrivacySubtypeAlways,
    PRPrivacySubtypeWhenInUse,
};

typedef NS_ENUM(NSUInteger, PRPrivacyStatus) {
    PRPrivacyStatusNotDetermined,
    PRPrivacyStatusRestricted,
    PRPrivacyStatusDenied,
    PRPrivacyStatusAuthorized,
#ifdef __IPHONE_8_0
    PRPrivacyStatusAuthorizedAlways,
    PRPrivacyStatusAuthorizedWhenInUse,
#endif
};

@interface PRPrivacyManager : NSObject

+ (PRPrivacyStatus)privacyStatusForType:(PRPrivacyType)type;
+ (void)authorizeWithType:(PRPrivacyType)type
               completion:(void (^)(PRPrivacyStatus status))completion;
+ (void)authorizeWithType:(PRPrivacyType)type
                  subtype:(PRPrivacySubtype)subtype
               completion:(void (^)(PRPrivacyStatus status))completion;

@end
