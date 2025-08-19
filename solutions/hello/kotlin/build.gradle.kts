plugins {
    kotlin("jvm") version "1.9.23"
    application
    id("org.jlleitschuh.gradle.ktlint") version "12.1.0"
}

repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib"))
}

application {
    mainClass.set("HelloKt")
}

tasks.jar {
    manifest {
        attributes["Main-Class"] = "HelloKt"
    }
    from(sourceSets.main.get().output)
    from(configurations.runtimeClasspath.get().map { if (it.isDirectory) it else zipTree(it) }) {
        exclude("META-INF/*.RSA", "META-INF/*.SF", "META-INF/*.DSA")
    }
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
}

// Configure ktlint
ktlint {
    version.set("1.0.1")
}

// Ensure test task exists even if no tests
tasks.test {
    useJUnitPlatform()
    doLast {
        println("No tests configured for hello world")
    }
}
