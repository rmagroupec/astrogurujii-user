import java.util.Properties
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    
}
val localProperties = Properties().apply {
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.reader(Charsets.UTF_8).use { reader ->
            load(reader)
        }
    }
}
android {
    
    namespace = "com.user.astrogurujii"
    ndkVersion = "27.0.12077973"
    compileSdk = 35
    

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
    signingConfigs {
        create("release") {
            storeFile = file("astrogurujii_user.jks")
            storePassword = "arvind123arvind"
            keyAlias = "arvind123arvind"
            keyPassword = "arvind123arvind"
        }
    }
    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.user.astrogurujii"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = 34
        versionName = "1.1.34"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    lint {
        disable += listOf("InvalidPackage", "Instantiatable")
        checkReleaseBuilds = false
        abortOnError = false
    }
}

flutter {
    source = "../.."
}
dependencies {
    val kotlinVersion = "1.9.10" // Replace with your actual Kotlin version
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlinVersion")
    implementation("com.google.firebase:firebase-messaging:23.0.7")
    implementation("com.facebook.android:facebook-android-sdk:[8,9)")
    implementation("com.google.firebase:firebase-analytics:21.1.0")
    implementation("androidx.multidex:multidex:2.0.1")
    implementation(platform("com.google.firebase:firebase-bom:30.2.0"))
}
