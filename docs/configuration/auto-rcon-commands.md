
# Auto-execute RCON commands

RCON commands can be configured to execute when the server starts, a client connects, or a client disconnects.

!!! note

    When declaring several commands within a compose file environment variable, it's easiest to use YAML's `|-` [block style indicator](https://yaml-multiline.info/).

**On Server Start:**

``` yaml
      RCON_CMDS_STARTUP:  |-
        gamerule doFireTick false
        pregen start 200
```

**On Client Connection:**

``` yaml
      RCON_CMDS_ON_CONNECT:  |-
        team join New @a[team=]
```

**Note:**
* On client connect we only know there was a connection, and not who connected. RCON commands will need to be used for that.

**On Client Disconnect:**

``` yaml
      RCON_CMDS_ON_DISCONNECT:  |-
        gamerule doFireTick true
```

**On First Client Connect**

``` yaml
      RCON_CMDS_FIRST_CONNECT: |-
        pregen stop
```

**On Last Client Disconnect**

``` yaml
      RCON_CMDS_LAST_DISCONNECT: |-
        kill @e[type=minecraft:boat]
        pregen start 200

```

**Example of rules for new players**

Uses team NEW and team OLD to track players on the server. So move player with no team to NEW, run a command, move them to team OLD.
[Reference Article](https://www.minecraftforum.net/forums/minecraft-java-edition/redstone-discussion-and/2213523-detect-players-first-join)

``` yaml
      RCON_CMDS_STARTUP:  |-
        /pregen start 200
        /gamerule doFireTick false
        /team add New
        /team add Old
      RCON_CMDS_ON_CONNECT: |-
        /team join New @a[team=]
        /give @a[team=New] birch_boat
        /team join Old @a[team=New]
      RCON_CMDS_FIRST_CONNECT: |-
        /pregen stop
      RCON_CMDS_LAST_DISCONNECT: |-
        /kill @e[type=minecraft:boat]
        /pregen start 200
```
