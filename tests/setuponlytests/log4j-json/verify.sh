mc-image-helper assert fileExists /data/log4j2.xml
# console appender uses the JSON pattern
grep -A1 '<Console name="SysOut"' /data/log4j2.xml | grep -q '&quot;ecs.version&quot;'
# file appender keeps the default text pattern
grep -A1 '<RollingRandomAccessFile name="File"' /data/log4j2.xml | grep -qF 'pattern="[%d{HH:mm:ss}] [%t/%level]: %msg%n"'
