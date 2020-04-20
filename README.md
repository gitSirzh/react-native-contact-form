# react-native-contact-form

调用系统自带的通讯录UI 并选择联系人

## Example

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
# RN >= 0.60
cd ios && pod install

# RN < 0.60
react-native link react-native-contact-form
```

#### iOS

Using the same instructions as https://facebook.github.io/react-native/docs/linking-libraries-ios.html
1. open in xcode `open ios/yourProject.xcodeproj/`
1. drag `./node_modules/react-native-contact-form/ios/RNContacts.xcodeproj` to `Libraries` in your project view.
1. In the XCode project navigator, select your project,
select the `Build Phases` tab drag `Libraries > RNContacts.xcodeproj > Products > libRNContacts.a` into the `Link Binary With Libraries` section.

Run the app via the Run button in xcode or `react-native run-ios` in the terminal.

#### Android
For react native versions 0.60 and above you have to use Android X. Android X support was added to react-native-contact-form in version 5.x+. If you are using rn 0.59 and below install rnc versions 4.x instead.

1. In `android/settings.gradle`

```gradle
...
include ':react-native-contact-form'
project(':react-native-contact-form').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-contact-form/android')
```

2. In `android/app/build.gradle`

```gradle
...
dependencies {
    ...
    implementation project(':react-native-contact-form')
}
```

3. register module

```java
//  MainApplication.java
import com.jszh.RNContactsPackage; // <--- import

public class MainApplication extends Application implements ReactApplication {
  ......

  @Override
  protected List<ReactPackage> getPackages() {
    return Arrays.<ReactPackage>asList(
            new MainReactPackage(),
            new RNContactsPackage()); // <------ add this
  }
  ......
}
```

#### Permissions
##### API 23+
Android requires allowing permissions with https://facebook.github.io/react-native/docs/permissionsandroid.html
The `READ_CONTACTS` permission must be added to your main application's `AndroidManifest.xml`. If your app creates contacts add `WRITE_CONTACTS` permission to `AndroidManifest.xml` and request the permission at runtime.
```xml
...
<uses-permission android:name="android.permission.WRITE_CONTACTS" />
...
```

##### API 22 and below
Add `READ_PROFILE` and/or `WRITE_PROFILE` permissions to `AndroidManifest.xml`
```xml
...
<uses-permission android:name="android.permission.READ_PROFILE" />
...
```

#### ProGuard

If you use Proguard, the snippet below on proguard-rules.pro
Without it, your apk release version could failed

```
-keep class com.jszh.** {*;}
-keepclassmembers class com.jszh.** {*;}
```

### All RN versions

#### ios
Add kit specific "permission" keys to your Xcode `Info.plist` file, in order to make `requestPermission` work. Otherwise your app crashes when requesting the specific permission. Open `Info.plist`. Add key `Privacy - Contacts Usage Description` with your kit specific permission. The value for the key is optional in development. If you submit to the App Store the value must explain why you need this permission.

<img width="338" alt="screen shot 2016-09-21 at 13 13 21" src="https://cloud.githubusercontent.com/assets/5707542/18704973/3cde3b44-7ffd-11e6-918b-63888e33f983.png">

##### Accessing note filed on iOS 13 (optional)
If you'd like to read/write the contact's notes, call the `iosEnableNotesUsage(true)` method before accessing the contact infos. Also, a `com.apple.developer.contacts.notes` entitlement must be added to the project. Before submitting your app to the AppStore, the permission for using the entitlement has to be granted as well. You can find a more detailed explanation [here](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_contacts_notes?language=objc).

## Usage

```javascript
import Contacts from 'react-native-contact-form'

Contacts.openContacts((contact)=>{
    console.log('name:' + contact.name, 'phone:' + contact.phone)  // contact: {name: '小张', phone: '12345678901'}
})
