# PRPrivacyManager

[![Cocoapods](https://cocoapod-badges.herokuapp.com/v/PRPrivacyManager/badge.png)](http://cocoapods.org/?q=PRPrivacyManager)

All-in-one privacy manager for iOS.

Currently supported:

- [ ] Location Services
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

```
pod 'PRPrivacyManager'
```

## Usage

### Check for Status 

```
PRPrivacyStatus privacyStatus = [PRPrivacyManager privacyStatusForType:PRPrivacyTypeContacts];
```

### Ask for Permission

```
[PRPrivacyManager authorizeWithType:PRPrivacyTypeContacts
                         completion:^(PRPrivacyStatus status) {
                             // Handle result
                         }];
```

### Available Types

```
typedef NS_ENUM(NSUInteger, PRPrivacyType) {
    PRPrivacyTypeContacts,
    PRPrivacyTypePhotos,
    PRPrivacyTypeMicrophone,
    PRPrivacyTypeCamera
};
```

### Statuses

```
typedef NS_ENUM(NSUInteger, PRPrivacyStatus) {
    PRPrivacyStatusNotDetermined,
    PRPrivacyStatusRestricted,
    PRPrivacyStatusDenied,
    PRPrivacyStatusAuthorized
};
```

## License

This code is distributed under the terms and conditions of the [MIT license](http://opensource.org/licenses/MIT).

## Donate

You can support me by:

* sending me iTunes Gift Cards;
* via Alipay: elethomhunter@gmail.com
* via PayPal: elethomhunter@gmail.com

:-)

## Contact

* [Email](mailto:elethomhunter@gmail.com)
* [Twitter](https://twitter.com/elethomhunter)

