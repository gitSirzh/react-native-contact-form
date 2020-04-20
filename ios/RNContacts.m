//
//  RNContacts.m
//  react-native-contact-form
//
//  Created by jszh on 2020/4/18.
//  Copyright © 2020 Facebook. All rights reserved.
//


@import Foundation;
#import "RNContacts.h"
@interface RNContacts()

@property(nonatomic, retain) RCTPromiseResolveBlock _resolve;
@property(nonatomic, retain) RCTPromiseRejectBlock _reject;

@end

@implementation RNContacts

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_REMAP_METHOD(openContacts,resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){

  self._resolve = resolve;
  self._reject = reject;
  [self launchContacts];
}

#pragma mark - Shared functions
- (NSMutableDictionary *) emptyContactDict {
  return [[NSMutableDictionary alloc] initWithObjects:@[@"", @""] forKeys:@[@"name", @"phone"]];
}

/**
 打开联系人UI
 */
-(void) launchContacts {
  UIViewController *picker;
  if([CNContactPickerViewController class]) {
    //iOS 9+
    picker = [[CNContactPickerViewController alloc] init];
    ((CNContactPickerViewController *)picker).delegate = self;
  } else {
    //iOS 8 and below
    picker = [[ABPeoplePickerNavigationController alloc] init];
    [((ABPeoplePickerNavigationController *)picker) setPeoplePickerDelegate:self];
  }
  //Launch Contact Picker or Address Book View Controller
  UIViewController *root = [[[UIApplication sharedApplication] delegate] window].rootViewController;
  BOOL modalPresent = (BOOL) (root.presentedViewController);
  if (modalPresent) {
      UIViewController *parent = root.presentedViewController;
      [parent presentViewController:picker animated:YES completion:nil];
  } else {
      [root presentViewController:picker animated:YES completion:nil];
  }
}

#pragma mark - RN Promise Events

-(void)contactPicked:(NSDictionary *)contactData {
  self._resolve(contactData);
}


#pragma mark - Shared functions

/**
 Return full name as single string from first last and middle name strings, which may be empty
 */
-(NSString *) getFullNameForFirst:(NSString *)fName middle:(NSString *)mName {
  //Check whether to include middle name or not
  NSArray *names = (mName.length > 0) ? [NSArray arrayWithObjects:mName, fName, nil] : [NSArray arrayWithObjects:fName, nil];
  return [names componentsJoinedByString:@""];
}



#pragma mark - Event handlers - iOS 9+

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    /* Return NSDictionary ans JS Object to RN, containing basic contact data
     This is a starting point, in future more fields should be added, as required.
     This could also be extended to return arrays of phone numbers addresses etc. instead of jsut first found
     */
    NSMutableDictionary *contactData = [self emptyContactDict];
    NSString *fullName = [self getFullNameForFirst:contact.givenName middle:contact.familyName];
    NSArray *phoneNos = contact.phoneNumbers;
    //Return full name
    [contactData setValue:fullName forKey:@"name"];
    //Return first phone number
    if([phoneNos count] > 0) {
      CNPhoneNumber *phone = ((CNLabeledValue *)phoneNos[0]).value;
      [contactData setValue:phone.stringValue forKey:@"phone"];
    }
    [self contactPicked:contactData];
}



#pragma mark - Event handlers - iOS 8

/* Same functionality as above, implemented using iOS8 AddressBook library */
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
  /* Return NSDictionary ans JS Object to RN, containing basic contact data
   This is a starting point, in future more fields should be added, as required.
   This could also be extended to return arrays of phone numbers addresses etc. instead of jsut first found
   */
  NSMutableDictionary *contactData = [self emptyContactDict];
        NSString *fNameObject, *mNameObject, *lNameObject;
  fNameObject = (__bridge NSString *) ABRecordCopyValue(person, kABPersonFirstNameProperty);
  mNameObject = (__bridge NSString *) ABRecordCopyValue(person, kABPersonMiddleNameProperty);
  lNameObject = (__bridge NSString *) ABRecordCopyValue(person, kABPersonLastNameProperty);

  NSString *fullName = [self getFullNameForFirst:fNameObject middle:mNameObject];

  //Return full name
  [contactData setValue:fullName forKey:@"name"];

  //Return first phone number
  ABMultiValueRef phoneMultiValue = ABRecordCopyValue(person, kABPersonPhoneProperty);
  NSArray *phoneNos = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneMultiValue);
  if([phoneNos count] > 0) {
    [contactData setValue:phoneNos[0] forKey:@"phone"];
  }
  [self contactPicked:contactData];

}

@end

