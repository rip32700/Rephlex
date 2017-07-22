# Rephlex #

The tool on hand injects custom code into Android applications during runtime, its strategy is the subsequent:
                    
    * Patch the original APK to insert a newInstance field and a getInstance() method for it in the target
      class file. 
    
    * Patch the target class with a new method called loadInjection() which is always used before the
      getInstance() method returns the newInstance field to refresh/update it before
    
    * The loadInjection() method loads a DEX file during runtime which is in turn responsible for 
      replacing certain fields or methods of the target class.
    
    * Original calls found in the APK are patched to be invoked on the newInstance field like so:
        targetClassObject.targetMethod()    ====>    TargetClass.getInstance(targetClassObject).targetMethod()

    * The patched APK file is installed and run on the device.

Since the APP has not to be restarted as it reinjects the DEX during runtime for every target method call, 
merely the DEX application has to be rebuilt and redeployed thus resulting in a runtime code injection mechanic.