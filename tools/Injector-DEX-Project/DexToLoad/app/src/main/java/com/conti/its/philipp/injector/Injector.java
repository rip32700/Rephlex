package com.conti.its.philipp.injector;

import android.util.Log;

import net.bytebuddy.ByteBuddy;
import net.bytebuddy.android.AndroidClassLoadingStrategy;
import net.bytebuddy.implementation.FixedValue;
import net.bytebuddy.matcher.ElementMatchers;

import java.io.File;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.List;

/**
 * This class will be injectd into the victim APK by means
 * of binary instrumentation and dex class loading.
 *
 * The inject() method will be invoked to deliver a modified
 * instance of the target class.
 *
 * Created by philipp rieger on 1/10/17.
**/

public class Injector {

    public final static String TAG = "INJECTOR";

    private boolean isMethodToModify = true;
    private boolean isMethodToExecute = false;
    private boolean isFieldToModify = true;

    private String victimClass  = "com.conti.its.philipp.rephlexdemo.LoginVerifier";
    private String victimPackage = "com.conti.its.philipp.rephlexdemo";

    private String victimMethod = "verifyLogin";
    private Object targetReturnValue = false;

    private String victimField  = "password";
    private Object targetFieldValue = "injected again";

    /**
     * This method will be invoked via the dex class loader and handles the custom injection code
     * @param victimClassLoader: the class loader of the victim application
     * @param remoteInstance: the instance of the remote target class 
     * @return Object: the newly created and modified remote instance
     */
    public Object inject(final ClassLoader victimClassLoader, final Object remoteInstance) {
        Log.d(TAG, "Injected DEX executing begins...");
        Object newRemoteInstance = null;
        try {
            final Class cls = victimClassLoader.loadClass(victimClass);
            Log.d(TAG, "Loaded target class: " + cls.getName());
            // fields
            listAllRemoteFields(cls, remoteInstance);
            if(isFieldToModify) {
                modifyTargetField(cls, remoteInstance);
            }
            // methods
            listAllRemoteMethods(cls);
            if(isMethodToExecute) {
                executeTargetMethod(cls, remoteInstance);
            }
            if(isMethodToModify) {
                newRemoteInstance = modifyTargetMethod(cls, remoteInstance);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        }

        Log.d(TAG, "Injected DEX execution finished.");
        return newRemoteInstance;
    }

    /**
      * modifies the specified remote target field in the remote instance
      */
    public void modifyTargetField(final Class cls, final Object remoteInstance) throws NoSuchFieldException, IllegalAccessException {
        Log.d(TAG, "Modifying target field...");
        Field targetField = cls.getDeclaredField(victimField);
        targetField.setAccessible(true);
        Log.d(TAG, "Got field name : " + targetField.getName());
        Log.d(TAG, "Got field type : " + targetField.getType());
        Log.d(TAG, "Got field value: " + targetField.get(remoteInstance));
        targetField.set(remoteInstance, targetFieldValue);
        Log.d(TAG, "Field modified - new value: " + targetField.get(remoteInstance));
    }

    /**
      * lists all remote fields of the remote class and instance
      */
    public void listAllRemoteFields(final Class cls, final Object remoteInstance) throws IllegalAccessException {
        Log.d(TAG, "Listing all remote fields...");
        Field[] fields = cls.getDeclaredFields();
        for(Field f : fields) {
            f.setAccessible(true);
            Log.d(TAG, "Got field name : " + f.getName());
            Log.d(TAG, "Got field type : " + f.getType());
            Log.d(TAG, "Got field value: " + f.get(remoteInstance));
        }
    }

    /**
      * lists all remote methods of the remote class
      */
    public void listAllRemoteMethods(final Class cls) {
        Log.d(TAG, "Listing all remote methods...");
        Method[] methods = cls.getDeclaredMethods();
        for(Method m : methods) {
            m.setAccessible(true);
            Class<?>[] paramTypes = m.getParameterTypes();
            Log.d(TAG, "Got method name    : " + m.getName());
            for(Class clazz : paramTypes) {
                Log.d(TAG, "Got parameter types: " + clazz);
            }
            Log.d(TAG, "Got return type    : " + m.getReturnType());
        }
    }

    /**
      * modifies the original method by subclassing the target class and returning a new instance with an overwritten method
      */
    public Object modifyTargetMethod(final Class cls, final Object remoteInstance) throws IllegalAccessException, InstantiationException, InvocationTargetException {
        Log.d(TAG, "Overwriting original method...");
        File f = new File("/data/user/0/" + victimPackage + "/injector");
        f.mkdirs();

        // create the new instance
        Object newRemoteInstance = new ByteBuddy(/*ClassFileVersion.JAVA_V8*/)
                .subclass(cls)
                .method(ElementMatchers.named(victimMethod)).intercept(FixedValue.value(targetReturnValue))
                /*
                    Actually intended but still in research: 
                   .method(ElementMatchers.named(victimMethod)).intercept(MethodDelegation.to(new Interceptor()))
                */
                .make()
                .load(cls.getClassLoader(), new AndroidClassLoadingStrategy(f))
                .getLoaded()
                .newInstance();

        // copy original field values to the copy
        List<Field> fields = Arrays.asList(cls.getDeclaredFields());
        for(Field field : fields) {
            field.setAccessible(true);
            field.set(newRemoteInstance, field.get(remoteInstance));
        }
        Log.d(TAG, "Overwritten.");
        return newRemoteInstance;
    }

    /**
      * triggers the execution of the remote target method
      */
    public void executeTargetMethod(final Class cls, final Object remoteInstance) throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        Method methodToLoad = cls.getDeclaredMethod(victimMethod, String.class);
        methodToLoad.setAccessible(true);
        boolean returnValue = (boolean) methodToLoad.invoke(remoteInstance, "");
        Log.d(TAG, "Executed victim method and got: " + returnValue);
    }
}