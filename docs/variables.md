
!!! warning

    The variables listed on this page are manually documented and may be out-of-date or inaccurate.

    All other documentation pages are actively maintained, so please use the search box above to find the desired topic.

### General options
<table>
    <thead>
        <tr>
            <th>NAME</th>
            <th>DESCRIPTION</th>
            <th>DEFAULT</th>
            <th>REQUIRED</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>UID</code></td>
            <td>The linux user id to run as</td>
            <td><code>1000</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>GID</code></td>
            <td>The linux group id to run as</td>
            <td><code>1000</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>MEMORY</code></td>
            <td>The image declares an initial and maximum Java memory-heap limit of 1 GB.</td>
            <td><code>1G</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>INIT_MEMORY</code></td>
            <td>Independently sets the initial heap size</td>
            <td><code>1G</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>MAX_MEMORY</code></td>
            <td>independently sets the max heap size</td>
            <td><code>1G</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>TZ</code></td>
            <td>You can configure the timezone to match yours by setting the TZ environment variable.

alternatively, you can mount: <code>/etc/localtime:/etc/localtime:ro

/etc/timezone:/etc/timezone:ro</code>
            </td>
            <td><code>UTC</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>ENABLE_ROLLING_LOGS</code></td>
            <td>By default the vanilla log file will grow without limit. The logger can be reconfigured to use a rolling log files strategy by setting this to <code>true</code></td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>ENABLE_JMX</code></td>
            <td>To enable remote JMX, such as for profiling with VisualVM or JMC, add the environment variable ENABLE_JMX=true</td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>JMX_HOST</code></td>
            <td>If JMX is enabled, set JMX_HOST to the IP/host running the Docker container, and add a port forwarding of TCP port 7091</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>USE_AIKAR_FLAGS</code></td>
            <td><a href="https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/">Aikar has done some research</a> into finding the optimal JVM flags for GC tuning, which becomes more important as more users are connected concurrently</td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>USE_MEOWICE_FLAGS</code></td>
            <td><a href="https://github.com/MeowIce/meowice-flags?tab=readme-ov-file#why-would-i-have-to-switch-">MeowIce has created an updated set of JVM flags</a> based on Aikar's flags but with support for optimizations for Java 17 and above</td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>USE_MEOWICE_GRAALVM_FLAGS</code></td>
            <td>enables MeowIce's flags for GraalVM if USE_MEOWICE_GRAALVM_FLAGS is TRUE</td>
            <td><code>true</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>JVM_OPTS</code></td>
            <td>General JVM options can be passed to the Minecraft Server invocation by passing a <code>JVM_OPTS</code> environment variable. The JVM requires -XX options to precede -X options, so those can be declared in <code>JVM_XX_OPTS</code>. Both variables are space-delimited, raw JVM arguments</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>JVM_XX_OPTS</code></td>
            <td>General JVM options can be passed to the Minecraft Server invocation by passing a <code>JVM_OPTS</code> environment variable. The JVM requires -XX options to precede -X options, so those can be declared in <code>JVM_XX_OPTS</code>. Both variables are space-delimited, raw JVM arguments</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>JVM_DD_OPTS</code></td>
            <td>As a shorthand for passing several system properties as -D arguments, you can instead pass a comma separated list of name=value or name:value pairs with JVM_DD_OPTS. (The colon syntax is provided for management platforms like Plesk that don't allow = inside a value.)</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>EXTRA_ARGS</code></td>
            <td>Arguments that would usually be passed to the jar file (those which are written after the filename)</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>LOG_TIMESTAMP </code></td>
            <td>To include the timestamp with each log set to <code>true</code></td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
    </tbody>
</table>

### Server

<table>
    <thead>
        <tr>
            <th>NAME</th>
            <th>DESCRIPTION</th>
            <th>DEFAULT</th>
            <th>REQUIRED</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>TYPE</code></td>
            <td>The server <a href="../types-and-platforms/">type</a></td>
            <td><code>VANILLA</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>EULA</code></td>
            <td>You <strong>MUST</strong> set this to <code>true</code></td>
            <td><code>&nbsp;</code></td>
            <td>✅</td>
        </tr>
        <tr>
            <td><code>VERSION</code></td>
            <td>The minecraft version</td>
            <td><code>LATEST</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>MOTD</code></td>
            <td>Set the server log in message.</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>DIFFICULTY</code></td>
            <td>The difficulty level. Available values: <code>peaceful</code>,<code>easy</code>,<code>normal</code>,<code>hard</code></td>
            <td><code>easy</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>ICON</code></td>
            <td>The url or file path for the icon image to use for the server. It will be downloaded, scaled, and converted to the proper format.</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>OVERRIDE_ICON</code></td>
            <td>The server icon which has been set doesn't get overridden by default. Set this to <code>TRUE</code> to override the icon</td>
            <td><code>FALSE</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>MAX_PLAYERS</code></td>
            <td>The maximum number of players that can join the server.</td>
            <td><code>20</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>MAX_WORLD_SIZE</code></td>
            <td>The maximum possible size in blocks, expressed as a radius.</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>ALLOW_NETHER</code></td>
            <td>Allows players to travel to the Nether</td>
            <td><code>true</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>ANNOUNCE_PLAYER_ACHIEVEMENTS</code></td>
            <td>Allows server to announce when a player gets an achievement.</td>
            <td><code>true</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>ENABLE_COMMAND_BLOCK</code></td>
            <td>Enables the command blocks.</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>FORCE_GAMEMODE</code></td>
            <td>Force players to join in the default game mode.</td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>GENERATE_STRUCTURES</code></td>
            <td>Defines whether structures (such as villages) will be generated.</td>
            <td><code>true</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>HARDCORE</code></td>
            <td>If set to <code>true</code>, players will be set to spectator mode if they die.</td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>SNOOPER_ENABLED</code></td>
            <td>If set to false, the server will not send data to snoop.minecraft.net server.</td>
            <td><code>true</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>MAX_BUILD_HEIGHT</code></td>
            <td>The maximum height in which building is allowed. Terrain may still naturally generate above a low height limit.</td>
            <td><code>256</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>SPAWN_ANIMALS</code></td>
            <td>Determines if animals will be able to spawn.</td>
            <td><code>true</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>SPAWN_MONSTERS</code></td>
            <td>Determines if monsters will be spawned.</td>
            <td><code>true</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>SPAWN_NPCS</code></td>
            <td>Determines if villagers will be spawned.</td>
            <td><code>true</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>SPAWN_PROTECTION</code></td>
            <td>Sets the area that non-ops can not edit (0 to disable)</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>VIEW_DISTANCE</code></td>
            <td>Sets the amount of world data the server sends the client, measured in chunks in each direction of the player (radius, not diameter). It determines the server-side viewing distance.</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>SEED</code></td>
            <td>Sets the seed to create the Minecraft world. If you use a negative number, make sure that it is in quotes.</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>MODE</code></td>
            <td>Minecraft servers are configured to run in Survival mode by default. You can change the mode using MODE where you can either provide the <a href="http://minecraft.wiki/Game_mode#Game_modes">standard numerical values</a> or the shortcut values:<br />
            <ul>
                <li>creative</li>
                <li>survival</li>
                <li>adventure</li>
                <li>spectator(minecraft 1.8 or later)</li>
            </ul></td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>PVP</code></td>
            <td>By default, servers are created with player-vs-player (PVP) mode enabled.</td>
            <td><code>true</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>LEVEL_TYPE</code></td>
            <td>By default, a standard world is generated with hills, valleys, water, etc. A different level type can be configured by setting LEVEL_TYPE to <a href="https://minecraft.wiki/w/Server.properties#level-type">an expected type listed here</a>.
            </td>
            <td><code>minecraft:default</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>GENERATOR_SETTINGS</code></td>
            <td>For some of the level types, <code>GENERATOR_SETTINGS</code> can be used to further customize the world generation <a href="https://minecraft.wiki/w/Server.properties#generator-settings">as described here</a>.</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>LEVEL</code></td>
            <td>You can either switch between world saves or run multiple containers with different saves by using the LEVEL option</td>
            <td><code>world</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>ONLINE_MODE</code></td>
            <td>By default, server checks connecting players against Minecraft's account database. If you want to create an offline server or your server is not connected to the internet, you can disable the server to try connecting to minecraft.net to authenticate players</td>
            <td><code>true</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>ALLOW_FLIGHT</code></td>
            <td>Allows users to use flight on your server while in Survival mode, if they have a mod that provides flight installed.</td>
            <td><code>FALSE</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>SERVER_NAME</code></td>
            <td>The server name</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>SERVER_PORT</code></td>
            <td>Only change this value if you know what you're doing. It is only needed when using host networking and it is rare that host networking should be used.</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>PLAYER_IDLE_TIMEOUT</code></td>
            <td>player-idle-timeout</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>ENABLE_JMX</code></td>
            <td>enable-jmx-monitoring</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>SYNC_CHUNK_WRITES</code></td>
            <td>sync-chunk-writes</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>ENABLE_STATUS</code></td>
            <td>enable-status</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>ENTITY_BROADCAST_RANGE_PERCENTAGE</code></td>
            <td>entity-broadcast-range-percentage</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>FUNCTION_PERMISSION_LEVEL</code></td>
            <td>function-permission-level</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>NETWORK_COMPRESSION_THRESHOLD</code></td>
            <td>network-compression-threshold</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>OP_PERMISSION_LEVEL</code></td>
            <td>op-permission-level</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>PREVENT_PROXY_CONNECTIONS</code></td>
            <td>prevent-proxy-connections</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>USE_NATIVE_TRANSPORT</code></td>
            <td>use-native-transport</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>SIMULATION_DISTANCE</code></td>
            <td>simulation-distance</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>EXEC_DIRECTLY</code></td>
            <td>If you would like to docker attach to the Minecraft server console with color and interactive capabilities, then set to <code>true</code></td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>STOP_SERVER_ANNOUNCE_DELAY</code></td>
            <td>To allow time for players to finish what they're doing during a graceful server shutdown, set <code>STOP_SERVER_ANNOUNCE_DELAY</code> to a number of seconds to delay after an announcement is posted by the server.</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>PROXY</code></td>
            <td>You may configure the use of an HTTP/HTTPS proxy by passing the proxy's URL</td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>CONSOLE</code></td>
            <td>Some older versions (pre-1.14) of Spigot required <code>--noconsole</code> to be passed when detaching stdin</td>
            <td><code>TRUE</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>GUI</code></td>
            <td>Some older servers get confused and think that the GUI interface is enabled.</td>
            <td><code>TRUE</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>STOP_DURATION</code></td>
            <td>When the container is signalled to stop, the Minecraft process wrapper will attempt to send a "stop" command via RCON or console and waits for the process to gracefully finish.</td>
            <td><code>60</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>SETUP_ONLY</code></td>
            <td>If you are using a host-attached data directory, then you can have the image setup the Minecraft server files and stop prior to launching the server process by setting this to <code>true</code></td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>USE_FLARE_FLAGS</code></td>
            <td>To enable the JVM flags required to fully support the <a href="https://blog.airplane.gg/flare">Flare profiling suite</a>.</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>USE_SIMD_FLAGS</code></td>
            <td>Support for optimized SIMD operation</td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
        <!-- <tr>
            <td><code></code></td>
            <td></td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr> -->
    </tbody>
</table>

### Custom resource pack

<table>
    <thead>
        <tr>
            <th>NAME</th>
            <th>DESCRIPTION</th>
            <th>DEFAULT</th>
            <th>REQUIRED</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>RESOURCE_PACK</code></td>
            <td>A link to a custom resource pack</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>RESOURCE_PACK_SHA1</code></td>
            <td>The checksum for the custom resource pack</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>RESOURCE_PACK_ENFORCE</code></td>
            <td>Enforce the resource pack on clients</td>
            <td><code>FALSE</code></td>
            <td>⬜️</td>
        </tr>
    </tbody>
</table>

### Whitelist

<table>
    <thead>
        <tr>
            <th>NAME</th>
            <th>DESCRIPTION</th>
            <th>DEFAULT</th>
            <th>REQUIRED</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>ENABLE_WHITELIST</code></td>
            <td>Enable the whitelist to manually manage the whitelist</td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>WHITELIST</code></td>
            <td>A list of usernames and/or UUIDs separated by comma</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>WHITELIST_FILE</code></td>
            <td>A url or file path to a whitelist <code>json</code> formatted file.</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>OVERRIDE_WHITELIST</code></td>
            <td>Enforce regeneration of the whitelist on each server startup.</td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
    </tbody>
</table>

### RCON

<table>
    <thead>
        <tr>
            <th>NAME</th>
            <th>DESCRIPTION</th>
            <th>DEFAULT</th>
            <th>REQUIRED</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>ENABLE_RCON</code></td>
            <td>Enable/disable RCON support; however, be aware that disabling RCON will remove and limit some features, such as interactive and color console support.</td>
            <td><code>true</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>RCON_PASSWORD</code></td>
            <td>You <strong>MUST</strong> change this value</td>
            <td><code>Randomly generated</code></td>
            <td>✅</td>
        </tr>
        <tr>
            <td><code>RCON_PORT</code></td>
            <td>The port for RCON</td>
            <td><code>25575</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>BROADCAST_RCON_TO_OPS</code></td>
            <td>Sets broadcast-rcon-to-ops server property</td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
			<td><code>RCON_CMDS_STARTUP</code></td>
			<td>RCON commands to execute when the server starts.</td>
			<td><code></code></td>
			<td>⬜️</td>
		</tr>
		<tr>
			<td><code>RCON_CMDS_ON_CONNECT</code></td>
			<td>RCON commands to execute whenever a client connects to the server.</td>
			<td><code></code></td>
			<td>⬜️</td>
		</tr>
		<tr>
			<td><code>RCON_CMDS_FIRST_CONNECT</code></td>
			<td>RCON commands to execute on the first client connection to the server.</td>
			<td><code></code></td>
			<td>⬜️</td>
		</tr>
		<tr>
			<td><code>RCON_CMDS_ON_DISCONNECT</code></td>
			<td>RCON commands to execute whenever a client disconnects from the server.</td>
			<td><code></code></td>
			<td>⬜️</td>
		</tr>
		<tr>
			<td><code>RCON_CMDS_LAST_DISCONNECT</code></td>
			<td>RCON commands to execute when the last client disconnects from the server.</td>
			<td><code></code></td>
			<td>⬜️</td>
		</tr>
    </tbody>
</table>

### Auto-Pause

!!! note

    Autopause is not compatible with `EXEC_DIRECTLY=true` and the two cannot be set together.

<table>
    <thead>
        <tr>
            <th>NAME</th>
            <th>DESCRIPTION</th>
            <th>DEFAULT</th>
            <th>REQUIRED</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>ENABLE_AUTOPAUSE</code></td>
            <td>Enable the Autopause functionality</td>
            <td><code>FALSE</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>AUTOPAUSE_TIMEOUT_EST</code></td>
            <td>describes the time between the last client disconnect and the pausing of the process</td>
            <td><code>3600</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>AUTOPAUSE_TIMEOUT_INIT</code></td>
            <td>describes the time between server start and the pausing of the process, when no client connects in-between</td>
            <td><code>600</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>AUTOPAUSE_TIMEOUT_KN</code></td>
            <td>describes the time between knocking of the port (e.g. by the main menu ping) and the pausing of the process, when no client connects in-between</td>
            <td><code>120</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>AUTOPAUSE_PERIOD</code></td>
            <td>describes period of the daemonized state machine, that handles the pausing of the process</td>
            <td><code>10</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>AUTOPAUSE_KNOCK_INTERFACE</code></td>
            <td>Describes the interface passed to the knockd daemon. If the default interface does not work, run the ifconfig command inside the container and derive the interface receiving the incoming connection from its output. The passed interface must exist inside the container. Using the loopback interface (lo) does likely not yield the desired results.</td>
            <td><code>eth0</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>DEBUG_AUTOPAUSE</code></td>
            <td>Adds additional debugging output for AutoPause</td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
    </tbody>
</table>



### Auto-Stop

!!! note

    AutoStop function is incompatible with the Autopause functionality, as they basically cancel out each other.

<table>
    <thead>
        <tr>
            <th>NAME</th>
            <th>DESCRIPTION</th>
            <th>DEFAULT</th>
            <th>REQUIRED</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>ENABLE_AUTOSTOP</code></td>
            <td>Enable the AutoStop functionality</td>
            <td><code>FALSE</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>AUTOSTOP_TIMEOUT_EST</code></td>
            <td>describes the time between the last client disconnect and the stopping of the server</td>
            <td><code>3600</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>AUTOSTOP_TIMEOUT_INIT</code></td>
            <td>describes the time between server start and the stopping of the server, when no client connects in-between</td>
            <td><code>1800</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>AUTOSTOP_PERIOD</code></td>
            <td>describes period of the daemonized state machine, that handles the stopping of the serve</td>
            <td><code>10</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>DEBUG_AUTOSTOP</code></td>
            <td>Adds additional logging for AutoStop</td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
    </tbody>
</table>


### CurseForge

!!! tip

    Refer to the [main documentation page](types-and-platforms/mod-platforms/auto-curseforge.md) for more details and up-to-date information.

<table>
    <thead>
        <tr>
            <th>NAME</th>
            <th>DESCRIPTION</th>
            <th>DEFAULT</th>
            <th>REQUIRED</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>CF_API_KEY</code></td>
            <td><strong>YOUR</strong> CurseForge (Eternal) API Key.</td>
            <td><code></code></td>
            <td>✅</td>
        </tr>
        <tr>
            <td><code>CF_API_KEY_FILE</code></td>
            <td>A path to a file inside of container that contains <strong>YOUR</strong> CurseForge (Eternal) API Key.</td>
            <td><code></code></td>
            <td>✅</td>
        </tr>        
        <tr>
            <td><code>CF_PAGE_URL</code></td>
            <td>Pass a page URL to the modpack or a specific file</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>CF_SLUG</code></td>
            <td>Instead of a URL, the modpack slug can be provided.</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>CF_FILE_ID</code></td>
            <td>The mod curseforge numerical ID.</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>CF_FILENAME_MATCHER</code></td>
            <td>Specify a substring to match the desired filename</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>CF_EXCLUDE_INCLUDE_FILE</code></td>
            <td>Global and per modpack exclusions can be declared in a JSON file and referenced with this variable. <br /><br />By default, the <a href="https://github.com/itzg/docker-minecraft-server/blob/master/files/cf-exclude-include.json">file bundled with the image</a> will be used, but can be disabled by setting this to an empty string. The schema of this file is <a href="https://github.com/itzg/mc-image-helper#excludeinclude-file-schema">documented here</a>.</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>CF_EXCLUDE_MODS</code></td>
            <td>Mods can be excluded by passing a comma or space delimited list of project slugs or IDs</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>CF_FORCE_INCLUDE_MODS</code></td>
            <td>Mods can be included by passing a comma or space delimited list of project slugs or IDs</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>CF_FORCE_SYNCHRONIZE</code></td>
            <td>Forces the excludes/includes to be re-evaluated</td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>CF_SET_LEVEL_FROM</code></td>
            <td>Some modpacks come with world/save data via a worlds file and/or the overrides provided with the modpack. Either approach can be selected to set the LEVEL to the resulting saves directory by setting this to either:
            <ul>
                <li>WORLD_FILE</li>
                <li>OVERRIDES</li>
            </ul></td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>CF_PARALLEL_DOWNLOADS</code></td>
            <td>specify how many parallel mod downloads to perform</td>
            <td><code>4</code></td>
            <td>⬜️</td>
        </tr>
        <tr>
            <td><code>CF_OVERRIDES_SKIP_EXISTING</code></td>
            <td>if set, files in the overrides that already exist in the data directory are skipped. world data is always skipped, if present.</td>
            <td><code>false</code></td>
            <td>⬜️</td>
        </tr>
    </tbody>
</table>

<!-- ✅ ⬜️ -->
<!-- <tr>
            <td><code></code></td>
            <td></td>
            <td><code></code></td>
            <td>⬜️</td>
        </tr> -->
