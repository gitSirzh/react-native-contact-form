
package com.reactlibrary;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import android.content.ContentResolver;
import com.facebook.react.bridge.Promise;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.ContactsContract;

public class RNContactsModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public RNContactsModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNContacts";
    }

    @ReactMethod
    public void openContacts(Promise promise) {
        reactContext.startActivityForResult(new Intent(Intent.ACTION_PICK, ContactsContract.CommonDataKinds.Phone.CONTENT_URI), 0, null);
        reactContext.addActivityEventListener(new BaseActivityEventListener() {
            @Override
            public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
                super.onActivityResult(activity, requestCode, resultCode, data);
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
