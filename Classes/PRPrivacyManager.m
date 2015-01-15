//
//  PRPrivacyManager.m
//  PRPrivacyManager
//
//  Created by Elethom Hunter on 12/23/14.
//  Copyright (c) 2014 Project Rhinestone. All rights reserved.
//

#import "PRPrivacyManager.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIDevice.h>

#define IOS_VERSION_LESS_THAN(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending)

@interface PRPrivacyManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) void (^locationAuthorizationCompletion)(PRPrivacyStatus status);

+ (void)authorizeLocationOfSubtype:(PRPrivacySubtype)subtype
                        Completion:(void (^)(PRPrivacyStatus))completion;
+ (void)authorizeContactsCompletion:(void (^)(PRPrivacyStatus status))completion;
+ (void)authorizePhotosCompletion:(void (^)(PRPrivacyStatus status))completion;
+ (void)authorizeMicrophoneCompletion:(void (^)(PRPrivacyStatus status))completion;
+ (void)authorizeCameraCompletion:(void (^)(PRPrivacyStatus status))completion;

+ (PRPrivacyStatus)statusForLocationStatus:(CLAuthorizationStatus)status;
+ (PRPrivacyStatus)statusForContactsStatus:(ABAuthorizationStatus)status;
+ (PRPrivacyStatus)statusForPhotosStatus:(ALAuthorizationStatus)status;
+ (PRPrivacyStatus)statusForMicrophoneStatus:(AVAudioSessionRecordPermission)status;
+ (PRPrivacyStatus)statusForCameraStatus:(AVAuthorizationStatus)status;

+ (instancetype)sharedLocationManager;

@end

@implementation PRPrivacyManager

#pragma mark - Authorize

+ (void)authorizeLocationOfSubtype:(PRPrivacySubtype)subtype
                        Completion:(void (^)(PRPrivacyStatus))completion
{
    PRPrivacyStatus status = [self privacyStatusForType:PRPrivacyTypeLocation];
    if (status == PRPrivacyStatusNotDetermined) {
        if (![CLLocationManager locationServicesEnabled]) {
            return;
        }
        PRPrivacyManager *sharedLocationManager = [self sharedLocationManager];
        sharedLocationManager.locationAuthorizationCompletion = completion;
        if (!IOS_VERSION_LESS_THAN(@"8.0")) {
            switch (subtype) {
                case PRPrivacySubtypeAlways:
                    [sharedLocationManager.locationManager requestAlwaysAuthorization];
                    break;
                case PRPrivacySubtypeWhenInUse:
                    [sharedLocationManager.locationManager requestWhenInUseAuthorization];
                    break;
            }
        } else {
            [sharedLocationManager.locationManager startUpdatingLocation];
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) { completion(status); }
        });
    }
}

+ (void)authorizeContactsCompletion:(void (^)(PRPrivacyStatus))completion
{
    PRPrivacyStatus status = [self privacyStatusForType:PRPrivacyTypeContacts];
    if (status == PRPrivacyStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(NULL, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(granted ? PRPrivacyStatusAuthorized : PRPrivacyStatusDenied);
                }
            });
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) { completion(status); }
        });
    }
}

+ (void)authorizePhotosCompletion:(void (^)(PRPrivacyStatus))completion
{
    PRPrivacyStatus status = [self privacyStatusForType:PRPrivacyTypePhotos];
    if (status == PRPrivacyStatusNotDetermined) {
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                         *stop = YES;
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             if (completion) { completion(PRPrivacyStatusAuthorized); }
                                         });
                                     }
                                   failureBlock:^(NSError *error) {
                                       if (error.code == ALAssetsLibraryAccessUserDeniedError) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               if (completion) { completion(PRPrivacyStatusDenied); }
                                           });
                                       } else if (error.code == ALAssetsLibraryAccessGloballyDeniedError) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               if (completion) { completion(PRPrivacyStatusRestricted); }
                                           });
                                       } else {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               if (completion) { completion(PRPrivacyStatusNotDetermined); }
                                           });
                                       }
                                   }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) { completion(status); }
        });
    }
}

+ (void)authorizeMicrophoneCompletion:(void (^)(PRPrivacyStatus))completion
{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(granted ? PRPrivacyStatusAuthorized : PRPrivacyStatusDenied);
            }
        });
    }];
}

+ (void)authorizeCameraCompletion:(void (^)(PRPrivacyStatus status))completion
{
    PRPrivacyStatus status = [self privacyStatusForType:PRPrivacyTypeCamera];
    if (status == PRPrivacyStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (completion) {
                                             completion(granted ? PRPrivacyStatusAuthorized : PRPrivacyStatusDenied);
                                         }
                                     });
                                 }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) { completion(status); }
        });
    }
}

#pragma mark - External

+ (PRPrivacyStatus)privacyStatusForType:(PRPrivacyType)type
{
    switch (type) {
        case PRPrivacyTypeLocation:
            return [self statusForLocationStatus:[CLLocationManager authorizationStatus]];
        case PRPrivacyTypeContacts:
            return [self statusForContactsStatus:ABAddressBookGetAuthorizationStatus()];
        case PRPrivacyTypePhotos:
            return [self statusForPhotosStatus:[ALAssetsLibrary authorizationStatus]];
        case PRPrivacyTypeMicrophone:
            if (!IOS_VERSION_LESS_THAN(@"8.0")) {
                return [self statusForMicrophoneStatus:[AVAudioSession sharedInstance].recordPermission];
            } else {
                return PRPrivacyStatusNotDetermined;
            }
        case PRPrivacyTypeCamera:
            return [self statusForCameraStatus:[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]];
    }
}

+ (void)authorizeWithType:(PRPrivacyType)type
               completion:(void (^)(PRPrivacyStatus status))completion
{
    [self authorizeWithType:type
                    subtype:PRPrivacySubtypeAlways
                 completion:completion];
}

+ (void)authorizeWithType:(PRPrivacyType)type
                  subtype:(PRPrivacySubtype)subtype
               completion:(void (^)(PRPrivacyStatus))completion
{
    
    switch (type) {
        case PRPrivacyTypeLocation:
            [self authorizeLocationOfSubtype:subtype
                                  Completion:completion];
            break;
        case PRPrivacyTypeContacts:
            [self authorizeContactsCompletion:completion];
            break;
        case PRPrivacyTypePhotos:
            [self authorizePhotosCompletion:completion];
            break;
        case PRPrivacyTypeMicrophone:
            [self authorizeMicrophoneCompletion:completion];
            break;
        case PRPrivacyTypeCamera:
            [self authorizeCameraCompletion:completion];
            break;
    }
}

#pragma mark - Utils

+ (PRPrivacyStatus)statusForLocationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            return PRPrivacyStatusNotDetermined;
        case kCLAuthorizationStatusRestricted:
            return PRPrivacyStatusRestricted;
        case kCLAuthorizationStatusDenied:
            return PRPrivacyStatusDenied;
#ifndef __IPHONE_8_0
        case kCLAuthorizationStatusAuthorized:
            return PRPrivacyStatusAuthorized;
#else
        case kCLAuthorizationStatusAuthorizedAlways:
            return PRPrivacyStatusAuthorizedAlways;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return PRPrivacyStatusAuthorizedWhenInUse;
#endif
        default:
            break;
    }
}

+ (PRPrivacyStatus)statusForContactsStatus:(ABAuthorizationStatus)status
{
    switch (status) {
        case kABAuthorizationStatusNotDetermined:
            return PRPrivacyStatusNotDetermined;
        case kABAuthorizationStatusRestricted:
            return PRPrivacyStatusRestricted;
        case kABAuthorizationStatusDenied:
            return PRPrivacyStatusDenied;
        case kABAuthorizationStatusAuthorized:
            return PRPrivacyStatusAuthorized;
        default:
            return PRPrivacyStatusNotDetermined;
    }
}

+ (PRPrivacyStatus)statusForPhotosStatus:(ALAuthorizationStatus)status
{
    switch (status) {
        case ALAuthorizationStatusNotDetermined:
            return PRPrivacyStatusNotDetermined;
        case ALAuthorizationStatusRestricted:
            return PRPrivacyStatusRestricted;
        case ALAuthorizationStatusDenied:
            return PRPrivacyStatusDenied;
        case ALAuthorizationStatusAuthorized:
            return PRPrivacyStatusAuthorized;
        default:
            return PRPrivacyStatusNotDetermined;
    }
}

+ (PRPrivacyStatus)statusForMicrophoneStatus:(AVAudioSessionRecordPermission)status
{
    switch (status) {
        case AVAudioSessionRecordPermissionUndetermined:
            return PRPrivacyStatusNotDetermined;
        case AVAudioSessionRecordPermissionDenied:
            return PRPrivacyStatusDenied;
        case AVAudioSessionRecordPermissionGranted:
            return PRPrivacyStatusAuthorized;
        default:
            return PRPrivacyStatusNotDetermined;
    }
}

+ (PRPrivacyStatus)statusForCameraStatus:(AVAuthorizationStatus)status
{
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            return PRPrivacyStatusNotDetermined;
        case AVAuthorizationStatusRestricted:
            return PRPrivacyStatusRestricted;
        case AVAuthorizationStatusDenied:
            return PRPrivacyStatusDenied;
        case AVAuthorizationStatusAuthorized:
            return PRPrivacyStatusAuthorized;
        default:
            return PRPrivacyStatusNotDetermined;
    }
}

#pragma mark - Getters and setters

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

#pragma mark - Life cycle

+ (instancetype)sharedLocationManager
{
    static id sharedLocationManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[self alloc] init];
    });
    return sharedLocationManager;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (manager == self.locationManager) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.locationAuthorizationCompletion) {
                self.locationAuthorizationCompletion([[self class] statusForLocationStatus:status]);
                self.locationAuthorizationCompletion = nil;
            }
            if (IOS_VERSION_LESS_THAN(@"8.0")) {
                [manager stopUpdatingLocation];
            }
        });
    }
}

@end
