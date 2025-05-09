---
title: Spring Boot
weight: 1800
toc: true
---

To run apps based on the [Spring Boot](https://spring.io/projects/spring-boot) frameworks using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Java language module.

2. Create your Spring Boot project; we'll use the [quickstart](https://spring.io/quickstart)
   example, creating it at <https://start.spring.io>:

   ![Spring Initializr - Project Setup Screen](/unit/images/springboot.png)

   {{< note >}}
   Choose the same Java version that your Unit language module has.
   {{< /note >}}

   Download and extract the project files where you need them:

   ```console
   $ unzip demo.zip -d /path/to/app/ # Path to the application directory; use a real path in your configuration
   ```

   This creates a directory named **/path/to/app/demo/** for you to add
   your app code to; in our [example](https://spring.io/quickstart), it's a
   single file called
   **/path/to/app/demo/src/main/java/com/example/demo/DemoApplication.java**:

   ```java
   package com.example.demo;

   import org.springframework.boot.SpringApplication;
   import org.springframework.boot.autoconfigure.SpringBootApplication;
   import org.springframework.web.bind.annotation.GetMapping;
   import org.springframework.web.bind.annotation.RequestParam;
   import org.springframework.web.bind.annotation.RestController;

   @SpringBootApplication
   @RestController
   public class DemoApplication {

     public static void main(String[] args) {
       SpringApplication.run(DemoApplication.class, args);
     }

     @GetMapping("/hello")
     public String hello(@RequestParam(value = "name", defaultValue = "World") String name) {
       return String.format("Hello, %s!", name);
     }
   }
   ```

   Finally, assemble a **.war** file.

   If you chose [Gradle](https://gradle.org) as the build tool:

   ```console
   $ cd /path/to/app/demo/ # Path to the application directory; use a real path in your configuration
   ```

   ```console
   $ ./gradlew bootWar
   ```

   If you chose [Maven](https://maven.apache.org):

   ```console
   $ cd /path/to/app/demo/ # Path to the application directory; use a real path in your configuration
   ```

   ```console
   $ ./mvnw package
   ```

   {{< note >}}
   By default, Gradle puts the **.war** file in the **build/libs/**
   subdirectory, while Maven uses **target/**; note your path for later
   use in Unit configuration.
   {{< /note >}}

3. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

4. Next,
   [put together]({{< relref "/unit/configuration.md#configuration-java" >}})
   the Spring Boot configuration (use a real value for **working_directory**):

   ```json
   {
      "listeners": {
         "*:80": {
            "pass": "applications/bootdemo"
         }
      },
      "applications": {
         "bootdemo": {
            "type": "java",
            "webapp": "gradle-or-maven-build-dir/demo.war",
            "webapp_comment": "Relative pathname of your .war file",
            "working_directory": "/path/to/app/demo/",
            "working_directory_comment": "Path to the application directory; use a real path in your configuration"
         }
      }
   }
   ```

5. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your app should be available on the listener's IP
   address and port:

   ```console
   $ curl http://localhost/hello?name=Unit

         Hello, Unit!
   ```
