allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    // ✅ Force checker-qual version to resolve firebase_auth compilation error
    project.configurations.all {
        resolutionStrategy.eachDependency {
            if (requested.group == "org.checkerframework" && requested.name == "checker-qual") {
                useVersion("3.42.0")
            }
            // ✅ Force Kotlin Gradle Plugin version to resolve warnings
            if (requested.group == "org.jetbrains.kotlin" && requested.name.startsWith("kotlin-gradle-plugin")) {
                useVersion("2.2.20")
            }
        }
    }

    // ✅ Force SDK versions to 35 as requested
    afterEvaluate {
        if (project.extensions.findByName("android") != null) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            android.compileSdkVersion(35)
            android.defaultConfig.targetSdkVersion(35)
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
