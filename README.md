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

## Usage

```javascript
import Contacts from 'react-native-contact-form'

Contacts.openContacts((contact)=>{
    console.log('name:' + contact.name, 'phone:' + contact.phone)  //contact:{name:'小张',phone:'12345678901'}
})
