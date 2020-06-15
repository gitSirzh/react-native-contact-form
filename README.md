# react-native-contact-form
[![npm version](https://badge.fury.io/js/react-native-contact-form.svg)](https://badge.fury.io/js/react-native-contact-form)

调用系统自带通讯录

#### 如果解决了您的问题，[请点个🌟](https://github.com/gitSirzh/react-native-contact-form)
#### If your problem is solved, [please click🌟](https://github.com/gitSirzh/react-native-contact-form)

## Presentation

#### ![](https://github.com/gitSirzh/react-native-contact-form/blob/master/src/file/AndroidVideo.gif)
#### ![](https://github.com/gitSirzh/react-native-contact-form/blob/master/src/file/IOSVideo.gif)

## Installation

Using npm:

```shell
npm install react-native-contact-form --save
```
or using yarn:

```shell
yarn add react-native-contact-form
```
```
# RN >= 0.61.5
cd ios && pod install
```

## Usage

```javascript
import Contacts from 'react-native-contact-form'

Contacts.openContacts().then((res) => {
    res.phone = res.phone && res.phone.replace(/\s*/g, '');
    console.log(JSON.stringify(res)) // res: {name: '小伙子', phone: '15518720000'}
}, (error) => {
    console.log(error.message) // 获取联系人失败
})
```

#### Permissions
##### API 23+
Android requires allowing permissions with https://facebook.github.io/react-native/docs/permissionsandroid.html
The `READ_CONTACTS` permission must be added to your main application's `AndroidManifest.xml`.
```xml
...
<uses-permission android:name="android.permission.READ_CONTACTS" />
...
```

##### API 22 and below
Add `READ_PROFILE` and/or `WRITE_PROFILE` permissions to `AndroidManifest.xml`
```xml
...
<uses-permission android:name="android.permission.READ_PROFILE" />
...
```

### All RN versions

#### ios
Add kit specific "permission" keys to your Xcode `Info.plist` file, in order to make `requestPermission` work. Otherwise your app crashes when requesting the specific permission. Open `Info.plist`. Add key `Privacy - Contacts Usage Description` with your kit specific permission. The value for the key is optional in development. If you submit to the App Store the value must explain why you need this permission.

<img width="338" alt="screen shot 2016-09-21 at 13 13 21" src="https://cloud.githubusercontent.com/assets/5707542/18704973/3cde3b44-7ffd-11e6-918b-63888e33f983.png">

##### Accessing note filed on iOS 13 (optional)
If you'd like to read/write the contact's notes, call the `iosEnableNotesUsage(true)` method before accessing the contact infos. Also, a `com.apple.developer.contacts.notes` entitlement must be added to the project. Before submitting your app to the AppStore, the permission for using the entitlement has to be granted as well. You can find a more detailed explanation [here](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_contacts_notes?language=objc).

