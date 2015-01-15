//
//  PRPrivacyManager.m
//  PRPrivacyManager
//
//  Created by Elethom Hunter on 12/23/14.
//  Copyright (c) 2014 Project Rhinestone. All rights reserved.
//

#import "PRPrivacyManager.h"
#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIDevice.h>

#define IOS_VERSION_LESS_THAN(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending)

@interface PRPrivacyManager ()

+ (void)authorizeContactsCompletion:(void (^)(PRPrivacyStatus status))completion;
+ (void)authorizePhotosCompletion:(void (^)(PRPrivacyStatus status))completion;
+ (void)authorizeMicrophoneCompletion:(void (^)(PRPrivacyStatus status))completion;
+ (void)authorizeCameraCompletion:(void (^)(PRPrivacyStatus status))completion;

@end

@implementation PRPrivacyManager

+ (void)authorizeContactsCompletion:(void (^)(PRPrivacyStatus))completion
{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status) {
        case kABAuthorizationStatusNotDetermined:
        {
            ABAddressBookRequestAccessWithCompletion(NULL, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(granted ? PRPrivacyStatusAuthorized : PRPrivacyStatusDenied);
                    }
                });
            });
            break;
        }
        case kABAuthorizationStatusRestricted:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) { completion(PRPrivacyStatusRestricted); }
            });
            break;
        }
        case kABAuthorizationStatusDenied:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) { completion(PRPrivacyStatusDenied); }
            });
            break;
        }
        case kABAuthorizationStatusAuthorized:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) { completion(PRPrivacyStatusAuthorized); }
            });
            break;
        }
        default:
            break;
    }
}

+ (void)authorizePhotosCompletion:(void (^)(PRPrivacyStatus))completion
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    switch (status) {
        case ALAuthorizationStatusNotDetermined:
        {
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
            break;
        }
        case ALAuthorizationStatusRestricted:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) { completion(PRPrivacyStatusRestricted); }
            });
            break;
        }
        case ALAuthorizationStatusDenied:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) { completion(PRPrivacyStatusDenied); }
            });
            break;
        }
        case ALAuthorizationStatusAuthorized:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) { completion(PRPrivacyStatusAuthorized); }
            });
            break;
        }
        default:
            break;
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
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             if (completion) {
                                                 completion(granted ? PRPrivacyStatusAuthorized : PRPrivacyStatusDenied);
                                             }
                                         });
                                     }];
            break;
        }
        case AVAuthorizationStatusRestricted:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) { completion(PRPrivacyStatusRestricted); }
            });
            break;
        }
        case AVAuthorizationStatusDenied:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) { completion(PRPrivacyStatusDenied); }
            });
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) { completion(PRPrivacyStatusAuthorized); }
            });
            break;
        }
        default:
            break;
    }
}

+ (PRPrivacyStatus)privacyStatusForType:(PRPrivacyType)type
{
    switch (type) {
        case PRPrivacyTypeContacts:
        {
            ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
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
                    break;
            }
            break;
        }
        case PRPrivacyTypePhotos:
        {
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
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
                    break;
            }
            break;
        }
        case PRPrivacyTypeMicrophone:
        {
            if (!IOS_VERSION_LESS_THAN(@"8.0")) {
                AVAudioSessionRecordPermission permission = [AVAudioSession sharedInstance].recordPermission;
                switch (permission) {
                    case AVAudioSessionRecordPermissionUndetermined:
                        return PRPrivacyStatusNotDetermined;
                    case AVAudioSessionRecordPermissionDenied:
                        return PRPrivacyStatusDenied;
                    case AVAudioSessionRecordPermissionGranted:
                        return PRPrivacyStatusAuthorized;
                    default:
                        break;
                }
            }
            break;
        }
        case PRPrivacyTypeCamera:
        {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
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
                    break;
            }
        }
    }
    return PRPrivacyStatusNotDetermined;
}

+ (void)authorizeWithType:(PRPrivacyType)type completion:(void (^)(PRPrivacyStatus status))completion
{
    switch (type) {
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

@end
