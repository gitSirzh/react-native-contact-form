
package com.jszh;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.WritableMap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.uimanager.IllegalViewOperationException;

import com.facebook.react.bridge.Arguments;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.ContactsContract;
import android.os.Bundle;

public class RNContactsModule extends ReactContextBaseJavaModule {

    private static final int REQUEST_OPEN_EXISTING_CONTACT = 19979;

    private ReactApplicationContext reactContext;
    private Promise promise;

    public RNContactsModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        reactContext.addActivityEventListener(new BaseActivityEventListener() {
            @Override
            public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
                super.onActivityResult(activity, requestCode, resultCode, data);
                if (requestCode != REQUEST_OPEN_EXISTING_CONTACT || promise == null) {
                    return;
                }
                if (resultCode != Activity.RESULT_OK) {
                    return;
                }
                if (data != null) {
                    Uri uri = data.getData();
                    String[] contact = getPhoneContacts(uri);
                    if (contact != null) {
                        try {
                            WritableMap writableMap = Arguments.createMap();
                            writableMap.putString("name", contact[0]);
                            writableMap.putString("phone", contact[1]);
                            promise.resolve(writableMap);
                        } catch (IllegalViewOperationException e) {
                            promise.reject("500", e.getMessage(), e);
                        }
                    }
                }
            }
        });
    }

    @Override
    public String getName() {
        return "RNContacts";
    }

    @ReactMethod
    public void openContacts(final Promise promise) {
        this.promise = promise;
        reactContext.startActivityForResult(new Intent(Intent.ACTION_PICK, ContactsContract.CommonDataKinds.Phone.CONTENT_URI), REQUEST_OPEN_EXISTING_CONTACT, Bundle.EMPTY);
    }

    private String[] getPhoneContacts(Uri uri) {
        String[] contact = new String[2];
        ContentResolver cr = reactContext.getContentResolver();
        Cursor cursor = cr.query(uri, null, null, null, null);
        if (cursor != null && cursor.moveToFirst()) {
            int nameFieldColumnIndex = cursor.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME);
            contact[0] = cursor.getString(nameFieldColumnIndex);
            contact[1] = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
            cursor.close();
        } else {
            return null;
        }
        return contact;
    }

}
