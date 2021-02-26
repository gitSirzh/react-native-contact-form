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

@property (nonatomic, strong) RCTPromiseResolveBlock _resolve;
@property (nonatomic, strong) RCTPromiseRejectBlock _reject;

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
 Open Contacts
 */
-(void) launchContacts {
  UIViewController *picker;
  picker = [[CNContactPickerViewController alloc] init];
  ((CNContactPickerViewController *)picker).delegate = self;
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

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    /* Return NSDictionary ans JS Object to RN, containing basic contact data
     This is a starting point, in future more fields should be added, as required.
     This could also be extended to return arrays of phone numbers addresses etc. instead of jsut first found
     */
    CNContact *contact = contactProperty.contact;
    NSString *name = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
    NSMutableDictionary *contactData = [self emptyContactDict];
    [contactData setValue:name forKey:@"name"];
    CNPhoneNumber *phoneValue = contactProperty.value;
    if ([phoneValue isKindOfClass:[CNPhoneNumber class]]) {
        NSString *phoneNumber = phoneValue.stringValue;
        [contactData setValue:phoneNumber forKey:@"phone"];
    } else {
        [contactData setValue:phoneValue forKey:@"phone"];
    }
    [self contactPicked:contactData];
}

@end

