/**
 * Created by jszh on 2020/4/18.
 */

'use strict';

import {NativeModules, Platform, PermissionsAndroid} from 'react-native';

const {RNContacts} = NativeModules;

export default new class Contacts {

    async openContacts() {
        if (Platform.OS === 'ios') {
            return this.hasPermissionsOpenContacts();
        } else {
            let granted = await PermissionsAndroid.check(PermissionsAndroid.PERMISSIONS.READ_CONTACTS);
            if (granted === PermissionsAndroid.RESULTS.GRANTED) {
                return this.hasPermissionsOpenContacts();
            } else {
                granted = await PermissionsAndroid.request(PermissionsAndroid.PERMISSIONS.READ_CONTACTS);
                if (granted === PermissionsAndroid.RESULTS.GRANTED) {
                    return this.hasPermissionsOpenContacts();
                } else {
                    return this.responseError('没有权限');
                }
            }
        }
    };

    hasPermissionsOpenContacts() {
        return RNContacts.openContacts();
    }

    responseError(error) {
        return new Promise((okCallback, errorCallback) => {
            errorCallback({'message': error});
        });
    }
}
