//
//  RNContacts.h
//  react-native-contact-form
//
//  Created by jszh on 2020/4/18.
//  Copyright © 2020 Facebook. All rights reserved.
//


#import <React/RCTBridgeModule.h>

@import Contacts;
@import ContactsUI;
@import AddressBook;
@import AddressBookUI;

@interface RNContacts : NSObject <RCTBridgeModule, CNContactPickerDelegate, ABPeoplePickerNavigationControllerDelegate>

@end

