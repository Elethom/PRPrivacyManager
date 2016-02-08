# PRPrivacyManager

[![CocoaPods](https://img.shields.io/cocoapods/v/PRPrivacyManager.svg)](https://cocoapods.org/pods/PRPrivacyManager)
[![Language](https://img.shields.io/badge/language-Objective--C-blue.svg)](../../search)
[![License](https://img.shields.io/github/license/Elethom/PRPrivacyManager.svg)](/LICENSE)

[![Tweet](https://img.shields.io/twitter/url/http/ElethomHunter.svg?style=social)](https://twitter.com/intent/tweet?text=PRPrivacyManager%3A%20All-in-one%20privacy%20manager%20for%20iOS.&url=https%3A%2F%2Fgithub.com%2FElethom%2FPRPrivacyManager&via=ElethomHunter)
[![Twitter](https://img.shields.io/twitter/follow/ElethomHunter.svg?style=social)](https://twitter.com/intent/follow?user_id=1512633926)

All-in-one privacy manager for iOS.

Currently supported:

- [x] Location Services
- [x] Contacts
- [ ] Calendars
- [ ] Reminders
- [x] Photos
- [ ] Bluetooth Sharing
- [x] Microphone
- [x] Camera
- [ ] Health
- [ ] HomeKit

## Installation

### With CocoaPods

In your `Podfile`:

```Ruby
pod 'PRPrivacyManager'
```

## Usage

### Check for Status 

```Objective-C
PRPrivacyStatus privacyStatus = [PRPrivacyManager privacyStatusForType:PRPrivacyTypeContacts];
```

### Ask for Permission

```Objective-C
[PRPrivacyManager authorizeWithType:PRPrivacyTypeContacts
                         completion:^(PRPrivacyStatus status) {
                             // Handle result
                         }];
```

```Objective-C
[PRPrivacyManager authorizeWithType:PRPrivacyTypeLocation
                            subtype:PRPrivacySubtypeWhenInUse
                         completion:^(PRPrivacyStatus status) {
                             // Handle result
                         }];
```

### Available Types

```Objective-C
typedef NS_ENUM(NSUInteger, PRPrivacyType) {
    PRPrivacyTypeLocation,
    PRPrivacyTypeContacts,
    PRPrivacyTypePhotos,
    PRPrivacyTypeMicrophone,
    PRPrivacyTypeCamera,
};
```

### Statuses

```Objective-C
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
```

## License

This code is distributed under the terms and conditions of the [MIT license](http://opensource.org/licenses/MIT).

## Donate

You can support me by:

* sending me iTunes Gift Cards;
* via [Alipay](https://www.alipay.com): elethomhunter@gmail.com
* via [PayPal](https://www.paypal.com): elethomhunter@gmail.com

:-)

## Contact

* [Telegram](https://telegram.org): [@elethom](http://telegram.me/elethom)
* [Email](mailto:elethomhunter@gmail.com)
* [Twitter](https://twitter.com/elethomhunter)
* [Blog](http://blog.projectrhinestone.org)

