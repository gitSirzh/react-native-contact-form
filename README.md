# react-native-contact-form

调用系统自带的通讯录UI 并选择联系人

## Example

<p>
    ![](https://github.com/gitSirzh/Nostalgia/blob/master/z_view/img/introduce/%E5%86%B0%E6%B2%B3%E4%B8%96%E7%BA%AA-%E6%9D%BE%E9%BC%A0.gif)
    ![](https://github.com/gitSirzh/Nostalgia/blob/master/z_view/img/introduce/%E5%86%B0%E6%B2%B3%E4%B8%96%E7%BA%AA-%E6%9D%BE%E9%BC%A0.gif)
<p>

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
