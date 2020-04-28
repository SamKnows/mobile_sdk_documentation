# Building the SDK instance
```kotlin
  class SampleApplication : MultiDexApplication() {
      val skSdk by lazy { SKSdk(this, <YOUR_PANEL_ID>) }

      override fun onCreate() {
          super.onCreate()
          app = this
      }

      companion object {
          lateinit var app: SampleApplication
              private set
      }
  }
```
```java
  public class SampleApplication extends MultiDexApplication {
      private static SampleApplication app;
      private SKSdk skSdk;

      @Override 
      public void onCreate() {
          super.onCreate();
          app = this;
          skSdk = new SKSdk(this, <YOUR_PANEL_ID>);
      }

      public SKSdk getSkSdk() {
          return skSdk;
      }

      public static SampleApplication getApp() {
          return app;
      }
  }
```

The first step is to initialise the SamKnows SDK, this is done inside a custom Application class, if you haven't already created one you will need to do so first.
