package com.conti.its.philipp.injector;

import android.util.Log;

/**
 * This class is intended to be used to subclass the remote target class
 * and to replace an existing method. 
 * 
 * Does currently not work due to class resolution errors for a second class
 * in the dex class loader. Current research on this topic is performed by the
 * author.
 *
 *
 * Created by philipp on 1/13/17.
 */

public class Interceptor {

    public  boolean intercept() {
        Log.d(Injector.TAG, "This is injected into the target method and replaces its implementation.");
        return true;
    }

}
