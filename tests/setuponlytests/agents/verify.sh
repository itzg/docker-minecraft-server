mc-image-helper assert fileExists agents/java/Log4jPatcher.jar
mc-image-helper assert fileNotExists agents/java/server.properties
mc-image-helper assert fileExists agents/jvm/libjdwp.so
