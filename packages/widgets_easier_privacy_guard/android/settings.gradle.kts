// Only read when this folder is opened on its own (an IDE's Gradle import).
// Inside an app build the plugin is a subproject and the app's settings
// supply the Android Gradle Plugin, so this file is skipped. Keep the version
// in step with the classpath entry in build.gradle.kts.
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
    plugins {
        id("com.android.library") version "9.1.0"
    }
}

rootProject.name = "widgets_easier_privacy_guard"
