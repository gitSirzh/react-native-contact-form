/**
 * Created by jszh on 2020/4/18.
 */

'use strict';

import {NativeModules} from 'react-native';

const {RNContacts} = NativeModules;

export default new class Contacts {

    openContacts(callback, errorCallback) {
        RNContacts.openContacts().then((data) => {
            callback(data)
        }, (error) => {
            errorCallback({'massage': `获取联系人失败:${error}`});
        });
    };
}
