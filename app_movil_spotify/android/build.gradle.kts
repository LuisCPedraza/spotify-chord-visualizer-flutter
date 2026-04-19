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
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    // Workaround AGP 8+: algunos plugins no declaran namespace.
    fun applyNamespaceFallback() {
        val androidExt = extensions.findByName("android") ?: return

        try {
            val getNamespace = androidExt.javaClass.methods.firstOrNull {
                it.name == "getNamespace" && it.parameterCount == 0
            }
            val setNamespace = androidExt.javaClass.methods.firstOrNull {
                it.name == "setNamespace" && it.parameterCount == 1
            }

            val currentNamespace = getNamespace?.invoke(androidExt) as? String
            if (currentNamespace.isNullOrBlank() && setNamespace != null) {
                val fallbackNamespace = "com.example.${project.name.replace('-', '_')}"
                setNamespace.invoke(androidExt, fallbackNamespace)
            }
        } catch (_: Throwable) {
            // Ignorar módulos sin soporte de namespace.
        }
    }

    if (state.executed) {
        applyNamespaceFallback()
    } else {
        afterEvaluate {
            applyNamespaceFallback()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
