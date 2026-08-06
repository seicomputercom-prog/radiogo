pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        val localPropertiesFile = file("local.properties")
        if (localPropertiesFile.exists()) {
            properties.load(java.io.FileInputStream(localPropertiesFile))
        }
        properties.getProperty("flutter.sdk")
            ?: System.getenv("FLUTTER_ROOT")
            ?: error("flutter.sdk not set in local.properties or FLUTTER_ROOT env")
    }
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.5.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
}

include(":app")
