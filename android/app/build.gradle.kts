plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.smart_bharat"
    compileSdk = 35  // Updated to SDK 35 as required
    ndkVersion = "27.0.12077973"  // Updated to NDK 27.0.12077973 as required

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.smart_bharat"
        minSdk = 21
        targetSdk = 35  // Also update targetSdk to match compileSdk
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            // TODO: Add your signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.firebase:firebase-analytics:21.5.0")
    implementation(platform("com.google.firebase:firebase-bom:32.7.2"))
    implementation("com.google.android.gms:play-services-safetynet:18.0.1")
}
