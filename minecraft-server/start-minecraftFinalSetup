#!/bin/bash

if [ -n "$OPS" -a ! -e ops.txt.converted ]; then
  echo "Setting ops"
  echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

if [ -n "$WHITELIST" -a ! -e white-list.txt.converted ]; then
  echo "Setting whitelist"
  echo $WHITELIST | awk -v RS=, '{print}' >> white-list.txt
fi

if [ -n "$ICON" -a ! -e server-icon.png ]; then
  echo "Using server icon from $ICON..."
  # Not sure what it is yet...call it "img"
  wget -q -O /tmp/icon.img $ICON
  specs=$(identify /tmp/icon.img | awk '{print $2,$3}')
  if [ "$specs" = "PNG 64x64" ]; then
    mv /tmp/icon.img /data/server-icon.png
  else
    echo "Converting image to 64x64 PNG..."
    convert /tmp/icon.img -resize 64x64! /data/server-icon.png
  fi
fi

# Make sure files exist and are valid JSON (for pre-1.12 to 1.12 upgrades)
for j in *.json; do
  if [[ $(python -c "print open('$j').read().strip()==''") = True ]]; then
    echo "Fixing JSON $j"
    echo '[]' > $j
  fi
done

# If any modules have been provided, copy them over
mkdir -p /data/mods
for m in /mods/*.{jar,zip}
do
  if [ -f "$m" -a ! -f "/data/mods/$m" ]; then
    echo Copying mod `basename "$m"`
    cp "$m" /data/mods
  fi
done
[ -d /data/config ] || mkdir /data/config
for c in /config/*
do
  if [ -f "$c" ]; then
    echo Copying configuration `basename "$c"`
    cp -rf "$c" /data/config
  fi
done

if [ "$TYPE" = "SPIGOT" ]; then
  if [ -d /plugins ]; then
    echo Copying any Bukkit plugins over
    cp -r /plugins /data
  fi
fi

EXTRA_ARGS=""
# Optional disable console
if [[ ${CONSOLE} = false || ${CONSOLE} = FALSE ]]; then
  EXTRA_ARGS+="--noconsole"
fi

# Optional disable GUI for headless servers
if [[ ${GUI} = false || ${GUI} = FALSE ]]; then
  EXTRA_ARGS="${EXTRA_ARGS} nogui"
fi

# put these prior JVM_OPTS at the end to give any memory settings there higher precedence
echo "Setting initial memory to ${INIT_MEMORY:-${MEMORY}} and max to ${MAX_MEMORY:-${MEMORY}}"
JVM_OPTS="-Xms${INIT_MEMORY:-${MEMORY}} -Xmx${MAX_MEMORY:-${MEMORY}} ${JVM_OPTS}"

if [[ ${TYPE} == "FEED-THE-BEAST" ]]; then
    cp -f $SERVER_PROPERTIES ${FTB_DIR}/server.properties
    cp -f /data/{eula,ops,white-list}.txt ${FTB_DIR}/
    cd ${FTB_DIR}
    echo "Running FTB server modpack start ..."
    exec ${FTB_SERVER_START}
else
    # If we have a bootstrap.txt file... feed that in to the server stdin
    if [ -f /data/bootstrap.txt ];
    then
        exec java $JVM_XX_OPTS $JVM_OPTS -jar $SERVER "$@" $EXTRA_ARGS < /data/bootstrap.txt
    else
        exec java $JVM_XX_OPTS $JVM_OPTS -jar $SERVER "$@" $EXTRA_ARGS
    fi
fi
