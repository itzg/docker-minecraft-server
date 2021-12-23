$(document).ready(function(){

  $("#txtCommand").bind("enterKey",function(e){
    sendCommand($("#txtCommand").val());
  });

  $("#txtCommand").keyup(function(e){
    if(e.keyCode == 13){
      $(this).trigger("enterKey");
      $(this).val("");
    }
  });

  $("#btnSend").click(function(){
    if($("#txtCommand").val() != ""){
      $("#btnSend").prop("disabled", true);
    }
    sendCommand($("#txtCommand").val());
  });

  $("#btnClearLog").click(function() {
    $("#groupConsole").empty();
    alertInfo("Console has cleared.");
  });
  
  var autocompleteCommands = [
      "achievement give *",
      "achievement give * <player>",
      "achievement give <name>",
      "achievement give <name> <player>",
      "achievement take *",
      "achievement take * <player>",
      "achievement take <name>",
      "achievement take <name> <player>",
      "ban <name>",
      "ban <name> <reason>",
      "ban-ip <address>",
      "ban-ip <name>",
      "ban-ip <address> <reason>",
      "ban-ip <name> <reason>",
      "banlist ips",
      "banlist players",
      "blockdata <x> <y> <z> <dataTag>",
      "clear",
      "clear <player>",
      "clear <player> <item>",
      "clear <player> <item> <data>",
      "clear <player> <item> <data> <maxCount>",
      "clear <player> <item> <data> <maxCount> <dataTag>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> filtered force <tileName>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> filtered force <tileName> <dataValue>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> filtered force <tileName> <state>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> filtered move <tileName>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> filtered move <tileName> <dataValue>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> filtered move <tileName> <state>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> filtered normal <tileName>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> filtered normal <tileName> <dataValue>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> filtered normal <tileName> <state>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> masked",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> masked force <tileName>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> masked force <tileName> <dataValue>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> masked force <tileName> <state>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> masked move <tileName>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> masked move <tileName> <dataValue>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> masked move <tileName> <state>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> masked normal <tileName>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> masked normal <tileName> <dataValue>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> masked normal <tileName> <state>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> replace",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> replace force <tileName>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> replace force <tileName> <dataValue>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> replace force <tileName> <state>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> replace move <tileName>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> replace move <tileName> <dataValue>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> replace move <tileName> <state>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> replace normal <tileName>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> replace normal <tileName> <dataValue>",
      "clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> replace normal <tileName> <state>",
      "debug start",
      "debug stop",
      "defaultgamemode survival",
      "defaultgamemode creative",
      "defaultgamemode adventure",
      "defaultgamemode spectator",
      "deop <player>",
      "difficulty peaceful",
      "difficulty easy",
      "difficulty normal",
      "difficulty hard",
      "effect <player> clear",
      "effect <player> minecraft:speed",
      "effect <player> minecraft:speed <seconds>",
      "effect <player> minecraft:speed <seconds> <amplifier>",
      "effect <player> minecraft:speed <seconds> <amplifier> true",
      "effect <player> minecraft:speed <seconds> <amplifier> false",
      "effect <player> minecraft:slowness",
      "effect <player> minecraft:slowness <seconds>",
      "effect <player> minecraft:slowness <seconds> <amplifier>",
      "effect <player> minecraft:slowness <seconds> <amplifier> true",
      "effect <player> minecraft:slowness <seconds> <amplifier> false",
      "effect <player> minecraft:haste",
      "effect <player> minecraft:haste <seconds>",
      "effect <player> minecraft:haste <seconds> <amplifier>",
      "effect <player> minecraft:haste <seconds> <amplifier> true",
      "effect <player> minecraft:haste <seconds> <amplifier> false",
      "effect <player> minecraft:mining_fatigue",
      "effect <player> minecraft:mining_fatigue <seconds>",
      "effect <player> minecraft:mining_fatigue <seconds> <amplifier>",
      "effect <player> minecraft:mining_fatigue <seconds> <amplifier> true",
      "effect <player> minecraft:mining_fatigue <seconds> <amplifier> false",
      "effect <player> minecraft:strength",
      "effect <player> minecraft:strength <seconds>",
      "effect <player> minecraft:strength <seconds> <amplifier>",
      "effect <player> minecraft:strength <seconds> <amplifier> true",
      "effect <player> minecraft:strength <seconds> <amplifier> false",
      "effect <player> minecraft:instant_health",
      "effect <player> minecraft:instant_health <seconds>",
      "effect <player> minecraft:instant_health <seconds> <amplifier>",
      "effect <player> minecraft:instant_health <seconds> <amplifier> true",
      "effect <player> minecraft:instant_health <seconds> <amplifier> false",
      "effect <player> minecraft:instant_damage",
      "effect <player> minecraft:instant_damage <seconds>",
      "effect <player> minecraft:instant_damage <seconds> <amplifier>",
      "effect <player> minecraft:instant_damage <seconds> <amplifier> true",
      "effect <player> minecraft:instant_damage <seconds> <amplifier> false",
      "effect <player> minecraft:jump_boost",
      "effect <player> minecraft:jump_boost <seconds>",
      "effect <player> minecraft:jump_boost <seconds> <amplifier>",
      "effect <player> minecraft:jump_boost <seconds> <amplifier> true",
      "effect <player> minecraft:jump_boost <seconds> <amplifier> false",
      "effect <player> minecraft:nausea",
      "effect <player> minecraft:nausea <seconds>",
      "effect <player> minecraft:nausea <seconds> <amplifier>",
      "effect <player> minecraft:nausea <seconds> <amplifier> true",
      "effect <player> minecraft:nausea <seconds> <amplifier> false",
      "effect <player> minecraft:regeneration",
      "effect <player> minecraft:regeneration <seconds>",
      "effect <player> minecraft:regeneration <seconds> <amplifier>",
      "effect <player> minecraft:regeneration <seconds> <amplifier> true",
      "effect <player> minecraft:regeneration <seconds> <amplifier> false",
      "effect <player> minecraft:resistance",
      "effect <player> minecraft:resistance <seconds>",
      "effect <player> minecraft:resistance <seconds> <amplifier>",
      "effect <player> minecraft:resistance <seconds> <amplifier> true",
      "effect <player> minecraft:resistance <seconds> <amplifier> false",
      "effect <player> minecraft:fire_resistance",
      "effect <player> minecraft:fire_resistance <seconds>",
      "effect <player> minecraft:fire_resistance <seconds> <amplifier>",
      "effect <player> minecraft:fire_resistance <seconds> <amplifier> true",
      "effect <player> minecraft:fire_resistance <seconds> <amplifier> false",
      "effect <player> minecraft:water_breathing",
      "effect <player> minecraft:water_breathing <seconds>",
      "effect <player> minecraft:water_breathing <seconds> <amplifier>",
      "effect <player> minecraft:water_breathing <seconds> <amplifier> true",
      "effect <player> minecraft:water_breathing <seconds> <amplifier> false",
      "effect <player> minecraft:invisibility",
      "effect <player> minecraft:invisibility <seconds>",
      "effect <player> minecraft:invisibility <seconds> <amplifier>",
      "effect <player> minecraft:invisibility <seconds> <amplifier> true",
      "effect <player> minecraft:invisibility <seconds> <amplifier> false",
      "effect <player> minecraft:blindness",
      "effect <player> minecraft:blindness <seconds>",
      "effect <player> minecraft:blindness <seconds> <amplifier>",
      "effect <player> minecraft:blindness <seconds> <amplifier> true",
      "effect <player> minecraft:blindness <seconds> <amplifier> false",
      "effect <player> minecraft:night_vision",
      "effect <player> minecraft:night_vision <seconds>",
      "effect <player> minecraft:night_vision <seconds> <amplifier>",
      "effect <player> minecraft:night_vision <seconds> <amplifier> true",
      "effect <player> minecraft:night_vision <seconds> <amplifier> false",
      "effect <player> minecraft:hunger",
      "effect <player> minecraft:hunger <seconds>",
      "effect <player> minecraft:hunger <seconds> <amplifier>",
      "effect <player> minecraft:hunger <seconds> <amplifier> true",
      "effect <player> minecraft:hunger <seconds> <amplifier> false",
      "effect <player> minecraft:weakness",
      "effect <player> minecraft:weakness <seconds>",
      "effect <player> minecraft:weakness <seconds> <amplifier>",
      "effect <player> minecraft:weakness <seconds> <amplifier> true",
      "effect <player> minecraft:weakness <seconds> <amplifier> false",
      "effect <player> minecraft:poison",
      "effect <player> minecraft:poison <seconds>",
      "effect <player> minecraft:poison <seconds> <amplifier>",
      "effect <player> minecraft:poison <seconds> <amplifier> true",
      "effect <player> minecraft:poison <seconds> <amplifier> false",
      "effect <player> minecraft:wither",
      "effect <player> minecraft:wither <seconds>",
      "effect <player> minecraft:wither <seconds> <amplifier>",
      "effect <player> minecraft:wither <seconds> <amplifier> true",
      "effect <player> minecraft:wither <seconds> <amplifier> false",
      "effect <player> minecraft:health_boost",
      "effect <player> minecraft:health_boost <seconds>",
      "effect <player> minecraft:health_boost <seconds> <amplifier>",
      "effect <player> minecraft:health_boost <seconds> <amplifier> true",
      "effect <player> minecraft:health_boost <seconds> <amplifier> false",
      "effect <player> minecraft:absorption",
      "effect <player> minecraft:absorption <seconds>",
      "effect <player> minecraft:absorption <seconds> <amplifier>",
      "effect <player> minecraft:absorption <seconds> <amplifier> true",
      "effect <player> minecraft:absorption <seconds> <amplifier> false",
      "effect <player> minecraft:saturation",
      "effect <player> minecraft:saturation <seconds>",
      "effect <player> minecraft:saturation <seconds> <amplifier>",
      "effect <player> minecraft:saturation <seconds> <amplifier> true",
      "effect <player> minecraft:saturation <seconds> <amplifier> false",
      "effect <player> minecraft:glowing",
      "effect <player> minecraft:glowing <seconds>",
      "effect <player> minecraft:glowing <seconds> <amplifier>",
      "effect <player> minecraft:glowing <seconds> <amplifier> true",
      "effect <player> minecraft:glowing <seconds> <amplifier> false",
      "effect <player> minecraft:levitation",
      "effect <player> minecraft:levitation <seconds>",
      "effect <player> minecraft:levitation <seconds> <amplifier>",
      "effect <player> minecraft:levitation <seconds> <amplifier> true",
      "effect <player> minecraft:levitation <seconds> <amplifier> false",
      "effect <player> minecraft:luck",
      "effect <player> minecraft:luck <seconds>",
      "effect <player> minecraft:luck <seconds> <amplifier>",
      "effect <player> minecraft:luck <seconds> <amplifier> true",
      "effect <player> minecraft:luck <seconds> <amplifier> false",
      "effect <player> minecraft:unluck",
      "effect <player> minecraft:unluck <seconds>",
      "effect <player> minecraft:unluck <seconds> <amplifier>",
      "effect <player> minecraft:unluck <seconds> <amplifier> true",
      "effect <player> minecraft:unluck <seconds> <amplifier> false",
      "enchant <player> minecraft:protection",
      "enchant <player> minecraft:protection <level>",
      "enchant <player> minecraft:fire_protection",
      "enchant <player> minecraft:fire_protection <level>",
      "enchant <player> minecraft:feather_falling",
      "enchant <player> minecraft:feather_falling <level>",
      "enchant <player> minecraft:blast_protection",
      "enchant <player> minecraft:blast_protection <level>",
      "enchant <player> minecraft:projectile_protection",
      "enchant <player> minecraft:projectile_protection <level>",
      "enchant <player> minecraft:respiration",
      "enchant <player> minecraft:respiration <level>",
      "enchant <player> minecraft:aqua_affinity",
      "enchant <player> minecraft:aqua_affinity <level>",
      "enchant <player> minecraft:thorns",
      "enchant <player> minecraft:thorns <level>",
      "enchant <player> minecraft:depth_strider",
      "enchant <player> minecraft:depth_strider <level>",
      "enchant <player> minecraft:frost_walker",
      "enchant <player> minecraft:frost_walker <level>",
      "enchant <player> minecraft:binding_curse",
      "enchant <player> minecraft:binding_curse <level>",
      "enchant <player> minecraft:sharpness",
      "enchant <player> minecraft:sharpness <level>",
      "enchant <player> minecraft:smite",
      "enchant <player> minecraft:smite <level>",
      "enchant <player> minecraft:bane_of_arthropods",
      "enchant <player> minecraft:bane_of_arthropods <level>",
      "enchant <player> minecraft:knockback",
      "enchant <player> minecraft:knockback <level>",
      "enchant <player> minecraft:fire_aspect",
      "enchant <player> minecraft:fire_aspect <level>",
      "enchant <player> minecraft:looting",
      "enchant <player> minecraft:looting <level>",
      "enchant <player> minecraft:sweeping",
      "enchant <player> minecraft:sweeping <level>",
      "enchant <player> minecraft:efficiency",
      "enchant <player> minecraft:efficiency <level>",
      "enchant <player> minecraft:silk_touch",
      "enchant <player> minecraft:silk_touch <level>",
      "enchant <player> minecraft:unbreaking",
      "enchant <player> minecraft:unbreaking <level>",
      "enchant <player> minecraft:fortune",
      "enchant <player> minecraft:fortune <level>",
      "enchant <player> minecraft:power",
      "enchant <player> minecraft:power <level>",
      "enchant <player> minecraft:punch",
      "enchant <player> minecraft:punch <level>",
      "enchant <player> minecraft:flame",
      "enchant <player> minecraft:flame <level>",
      "enchant <player> minecraft:infinity",
      "enchant <player> minecraft:infinity <level>",
      "enchant <player> minecraft:luck_of_the_sea",
      "enchant <player> minecraft:luck_of_the_sea <level>",
      "enchant <player> minecraft:lure",
      "enchant <player> minecraft:lure <level>",
      "enchant <player> minecraft:mending",
      "enchant <player> minecraft:mending <level>",
      "enchant <player> minecraft:vanishing_curse",
      "enchant <player> minecraft:vanishing_curse <level>",
      "entitydata <entity> <dataTag>",
      "execute <entity> <x> <y> <z> <command>",
      "execute <entity> <x> <y> <z> detect <x2> <y2> <z2> <block> <dataValue> <command>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <dataValue>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <state>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <dataValue> destroy",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <state> destroy",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <dataValue> destroy <dataTag>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <state> destroy <dataTag>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <dataValue> hollow",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <state> hollow",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <dataValue> hollow <dataTag>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <state> hollow <dataTag>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <dataValue> keep",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <state> keep",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <dataValue> keep <dataTag>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <state> keep <dataTag>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <dataValue> outline",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <state> outline",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <dataValue> outline <dataTag>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <state> outline <dataTag>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <dataValue> replace",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <state> replace",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <dataValue> replace <dataTag>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <state> replace <dataTag>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <dataValue> replace <replaceTileName> <replaceDataValue>",
      "fill <x1> <y1> <z1> <x2> <y2> <z2> <block> <state> replace <replaceTileName> <replaceDataValue>",
      "gamemode survival",
      "gamemode survival <player>",
      "gamemode creative",
      "gamemode creative <player>",
      "gamemode adventure",
      "gamemode adventure <player>",
      "gamemode spectator",
      "gamemode spectator <player>",
      "gamerule <rule name> <value>",
      "gamerule commandBlockOutput true",
      "gamerule commandBlockOutput false",
      "gamerule disableElytraMovementCheck true",
      "gamerule disableElytraMovementCheck false",
      "gamerule doDaylightCycle true",
      "gamerule doDaylightCycle false",
      "gamerule doDaylightCycle true",
      "gamerule doDaylightCycle false",
      "gamerule doEntityDrops true",
      "gamerule doEntityDrops false",
      "gamerule doFireTick true",
      "gamerule doFireTick false",
      "gamerule doMobLoot true",
      "gamerule doMobLoot false",
      "gamerule doMobSpawning true",
      "gamerule doMobSpawning false",
      "gamerule doWeatherCycle true",
      "gamerule doWeatherCycle false",
      "gamerule keepInventory true",
      "gamerule keepInventory false",
      "gamerule logAdminCommands true",
      "gamerule logAdminCommands false",
      "gamerule maxEntityCramming 24",
      "gamerule maxEntityCramming <value>",
      "gamerule naturalRegeneration true",
      "gamerule naturalRegeneration false",
      "gamerule randomTickSpeed 3",
      "gamerule randomTickSpeed <value>",
      "gamerule reducedDebugInfo true",
      "gamerule reducedDebugInfo false",
      "gamerule sendCommandFeedback true",
      "gamerule sendCommandFeedback false",
      "gamerule showDeathMessages true",
      "gamerule showDeathMessages false",
      "gamerule spawnRadius 10",
      "gamerule spawnRadius <value>",
      "gamerule spectatorsGenerateChunks true",
      "gamerule spectatorsGenerateChunks false",
      "give <player> <item>",
      "give <player> <item> <amount>",
      "give <player> <item> <amount> <data>",
      "give <player> <item> <amount> <data> <dataTag>",
      "help",
      "help <command>",
      "help <page>",
      "kick <player>",
      "kick <player> <reason>",
      "kill",
      "kill <player>",
      "kill <entity>",
      "list",
      "list <uuids>",
      "locate EndCity",
      "locate Fortress",
      "locate Mansion",
      "locate Mineshaft",
      "locate Monument",
      "locate Stronghold",
      "locate Temple",
      "locate Village",
      "me <action>",
      "op <player>",
      "pardon <player>",
      "pardon-ip <address>",
      "particle <name> <x> <y> <z> <xd> <yd> <zd> <speed>",
      "particle <name> <x> <y> <z> <xd> <yd> <zd> <speed> <count>",
      "particle <name> <x> <y> <z> <xd> <yd> <zd> <speed> <count> <mode>",
      "particle <name> <x> <y> <z> <xd> <yd> <zd> <speed> <count> <mode> <player>",
      "particle <name> <x> <y> <z> <xd> <yd> <zd> <speed> <count> <mode> <player> <params>",
      "playsound <sound> master <player>",
      "playsound <sound> master <player> <x> <y> <z>",
      "playsound <sound> master <player> <x> <y> <z> <volume>",
      "playsound <sound> master <player> <x> <y> <z> <volume> <pitch>",
      "playsound <sound> master <player> <x> <y> <z> <volume> <pitch> <minimumVolume>",
      "playsound <sound> music <player>",
      "playsound <sound> music <player> <x> <y> <z>",
      "playsound <sound> music <player> <x> <y> <z> <volume>",
      "playsound <sound> music <player> <x> <y> <z> <volume> <pitch>",
      "playsound <sound> music <player> <x> <y> <z> <volume> <pitch> <minimumVolume>",
      "playsound <sound> record <player>",
      "playsound <sound> record <player> <x> <y> <z>",
      "playsound <sound> record <player> <x> <y> <z> <volume>",
      "playsound <sound> record <player> <x> <y> <z> <volume> <pitch>",
      "playsound <sound> record <player> <x> <y> <z> <volume> <pitch> <minimumVolume>",
      "playsound <sound> weather <player>",
      "playsound <sound> weather <player> <x> <y> <z>",
      "playsound <sound> weather <player> <x> <y> <z> <volume>",
      "playsound <sound> weather <player> <x> <y> <z> <volume> <pitch>",
      "playsound <sound> weather <player> <x> <y> <z> <volume> <pitch> <minimumVolume>",
      "playsound <sound> block <player>",
      "playsound <sound> block <player> <x> <y> <z>",
      "playsound <sound> block <player> <x> <y> <z> <volume>",
      "playsound <sound> block <player> <x> <y> <z> <volume> <pitch>",
      "playsound <sound> block <player> <x> <y> <z> <volume> <pitch> <minimumVolume>",
      "playsound <sound> hostile <player>",
      "playsound <sound> hostile <player> <x> <y> <z>",
      "playsound <sound> hostile <player> <x> <y> <z> <volume>",
      "playsound <sound> hostile <player> <x> <y> <z> <volume> <pitch>",
      "playsound <sound> hostile <player> <x> <y> <z> <volume> <pitch> <minimumVolume>",
      "playsound <sound> neutral <player>",
      "playsound <sound> neutral <player> <x> <y> <z>",
      "playsound <sound> neutral <player> <x> <y> <z> <volume>",
      "playsound <sound> neutral <player> <x> <y> <z> <volume> <pitch>",
      "playsound <sound> neutral <player> <x> <y> <z> <volume> <pitch> <minimumVolume>",
      "playsound <sound> player <player>",
      "playsound <sound> player <player> <x> <y> <z>",
      "playsound <sound> player <player> <x> <y> <z> <volume>",
      "playsound <sound> player <player> <x> <y> <z> <volume> <pitch>",
      "playsound <sound> player <player> <x> <y> <z> <volume> <pitch> <minimumVolume>",
      "playsound <sound> ambiant <player>",
      "playsound <sound> ambiant <player> <x> <y> <z>",
      "playsound <sound> ambiant <player> <x> <y> <z> <volume>",
      "playsound <sound> ambiant <player> <x> <y> <z> <volume> <pitch>",
      "playsound <sound> ambiant <player> <x> <y> <z> <volume> <pitch> <minimumVolume>",
      "playsound <sound> voice <player>",
      "playsound <sound> voice <player> <x> <y> <z>",
      "playsound <sound> voice <player> <x> <y> <z> <volume>",
      "playsound <sound> voice <player> <x> <y> <z> <volume> <pitch>",
      "playsound <sound> voice <player> <x> <y> <z> <volume> <pitch> <minimumVolume>",
      "publish",
      "replaceitem block <x> <y> <z> slot.armor.chest <item>",
      "replaceitem block <x> <y> <z> slot.armor.chest <item> <amount>",
      "replaceitem block <x> <y> <z> slot.armor.chest <item> <amount> <data>",
      "replaceitem block <x> <y> <z> slot.armor.chest <item> <amount> <data> <dataTag>",
      "replaceitem entity <selector> slot.armor.chest <item>",
      "replaceitem entity <selector> slot.armor.chest <item> <amount>",
      "replaceitem entity <selector> slot.armor.chest <item> <amount> <data>",
      "replaceitem entity <selector> slot.armor.chest <item> <amount> <data> <dataTag>",
      "replaceitem block <x> <y> <z> slot.armor.feet <item>",
      "replaceitem block <x> <y> <z> slot.armor.feet <item> <amount>",
      "replaceitem block <x> <y> <z> slot.armor.feet <item> <amount> <data>",
      "replaceitem block <x> <y> <z> slot.armor.feet <item> <amount> <data> <dataTag>",
      "replaceitem entity <selector> slot.armor.feet <item>",
      "replaceitem entity <selector> slot.armor.feet <item> <amount>",
      "replaceitem entity <selector> slot.armor.feet <item> <amount> <data>",
      "replaceitem entity <selector> slot.armor.feet <item> <amount> <data> <dataTag>",
      "replaceitem block <x> <y> <z> slot.armor.head <item>",
      "replaceitem block <x> <y> <z> slot.armor.head <item> <amount>",
      "replaceitem block <x> <y> <z> slot.armor.head <item> <amount> <data>",
      "replaceitem block <x> <y> <z> slot.armor.head <item> <amount> <data> <dataTag>",
      "replaceitem entity <selector> slot.armor.head <item>",
      "replaceitem entity <selector> slot.armor.head <item> <amount>",
      "replaceitem entity <selector> slot.armor.head <item> <amount> <data>",
      "replaceitem entity <selector> slot.armor.head <item> <amount> <data> <dataTag>",
      "replaceitem block <x> <y> <z> slot.armor.legs <item>",
      "replaceitem block <x> <y> <z> slot.armor.legs <item> <amount>",
      "replaceitem block <x> <y> <z> slot.armor.legs <item> <amount> <data>",
      "replaceitem block <x> <y> <z> slot.armor.legs <item> <amount> <data> <dataTag>",
      "replaceitem entity <selector> slot.armor.legs <item>",
      "replaceitem entity <selector> slot.armor.legs <item> <amount>",
      "replaceitem entity <selector> slot.armor.legs <item> <amount> <data>",
      "replaceitem entity <selector> slot.armor.legs <item> <amount> <data> <dataTag>",
      "replaceitem block <x> <y> <z> slot.weapon.mainhand <item>",
      "replaceitem block <x> <y> <z> slot.weapon.mainhand <item> <amount>",
      "replaceitem block <x> <y> <z> slot.weapon.mainhand <item> <amount> <data>",
      "replaceitem block <x> <y> <z> slot.weapon.mainhand <item> <amount> <data> <dataTag>",
      "replaceitem entity <selector> slot.weapon.mainhand <item>",
      "replaceitem entity <selector> slot.weapon.mainhand <item> <amount>",
      "replaceitem entity <selector> slot.weapon.mainhand <item> <amount> <data>",
      "replaceitem entity <selector> slot.weapon.mainhand <item> <amount> <data> <dataTag>",
      "replaceitem block <x> <y> <z> slot.weapon.offhand <item>",
      "replaceitem block <x> <y> <z> slot.weapon.offhand <item> <amount>",
      "replaceitem block <x> <y> <z> slot.weapon.offhand <item> <amount> <data>",
      "replaceitem block <x> <y> <z> slot.weapon.offhand <item> <amount> <data> <dataTag>",
      "replaceitem entity <selector> slot.weapon.offhand <item>",
      "replaceitem entity <selector> slot.weapon.offhand <item> <amount>",
      "replaceitem entity <selector> slot.weapon.offhand <item> <amount> <data>",
      "replaceitem entity <selector> slot.weapon.offhand <item> <amount> <data> <dataTag>",
      "replaceitem block <x> <y> <z> slot.enderchest.<slot_number> <item>",
      "replaceitem block <x> <y> <z> slot.enderchest.<slot_number> <item> <amount>",
      "replaceitem block <x> <y> <z> slot.enderchest.<slot_number> <item> <amount> <data>",
      "replaceitem block <x> <y> <z> slot.enderchest.<slot_number> <item> <amount> <data> <dataTag>",
      "replaceitem entity <selector> slot.enderchest.<slot_number> <item>",
      "replaceitem entity <selector> slot.enderchest.<slot_number> <item> <amount>",
      "replaceitem entity <selector> slot.enderchest.<slot_number> <item> <amount> <data>",
      "replaceitem entity <selector> slot.enderchest.<slot_number> <item> <amount> <data> <dataTag>",
      "replaceitem block <x> <y> <z> slot.hotbar.<slot_number> <item>",
      "replaceitem block <x> <y> <z> slot.hotbar.<slot_number> <item> <amount>",
      "replaceitem block <x> <y> <z> slot.hotbar.<slot_number> <item> <amount> <data>",
      "replaceitem block <x> <y> <z> slot.hotbar.<slot_number> <item> <amount> <data> <dataTag>",
      "replaceitem entity <selector> slot.hotbar.<slot_number> <item>",
      "replaceitem entity <selector> slot.hotbar.<slot_number> <item> <amount>",
      "replaceitem entity <selector> slot.hotbar.<slot_number> <item> <amount> <data>",
      "replaceitem entity <selector> slot.hotbar.<slot_number> <item> <amount> <data> <dataTag>",
      "replaceitem block <x> <y> <z> slot.inventory.<slot_number> <item>",
      "replaceitem block <x> <y> <z> slot.inventory.<slot_number> <item> <amount>",
      "replaceitem block <x> <y> <z> slot.inventory.<slot_number> <item> <amount> <data>",
      "replaceitem block <x> <y> <z> slot.inventory.<slot_number> <item> <amount> <data> <dataTag>",
      "replaceitem entity <selector> slot.inventory.<slot_number> <item>",
      "replaceitem entity <selector> slot.inventory.<slot_number> <item> <amount>",
      "replaceitem entity <selector> slot.inventory.<slot_number> <item> <amount> <data>",
      "replaceitem entity <selector> slot.inventory.<slot_number> <item> <amount> <data> <dataTag>",
      "replaceitem block <x> <y> <z> slot.horse.saddle <item>",
      "replaceitem block <x> <y> <z> slot.horse.saddle <item> <amount>",
      "replaceitem block <x> <y> <z> slot.horse.saddle <item> <amount> <data>",
      "replaceitem block <x> <y> <z> slot.horse.saddle <item> <amount> <data> <dataTag>",
      "replaceitem entity <selector> slot.horse.saddle <item>",
      "replaceitem entity <selector> slot.horse.saddle <item> <amount>",
      "replaceitem entity <selector> slot.horse.saddle <item> <amount> <data>",
      "replaceitem entity <selector> slot.horse.saddle <item> <amount> <data> <dataTag>",
      "replaceitem block <x> <y> <z> slot.horse.armor <item>",
      "replaceitem block <x> <y> <z> slot.horse.armor <item> <amount>",
      "replaceitem block <x> <y> <z> slot.horse.armor <item> <amount> <data>",
      "replaceitem block <x> <y> <z> slot.horse.armor <item> <amount> <data> <dataTag>",
      "replaceitem entity <selector> slot.horse.armor <item>",
      "replaceitem entity <selector> slot.horse.armor <item> <amount>",
      "replaceitem entity <selector> slot.horse.armor <item> <amount> <data>",
      "replaceitem entity <selector> slot.horse.armor <item> <amount> <data> <dataTag>",
      "replaceitem block <x> <y> <z> slot.horse.chest.<slot_number> <item>",
      "replaceitem block <x> <y> <z> slot.horse.chest.<slot_number> <item> <amount>",
      "replaceitem block <x> <y> <z> slot.horse.chest.<slot_number> <item> <amount> <data>",
      "replaceitem block <x> <y> <z> slot.horse.chest.<slot_number> <item> <amount> <data> <dataTag>",
      "replaceitem entity <selector> slot.horse.chest.<slot_number> <item>",
      "replaceitem entity <selector> slot.horse.chest.<slot_number> <item> <amount>",
      "replaceitem entity <selector> slot.horse.chest.<slot_number> <item> <amount> <data>",
      "replaceitem entity <selector> slot.horse.chest.<slot_number> <item> <amount> <data> <dataTag>",
      "replaceitem block <x> <y> <z> slot.villager.<slot_number> <item>",
      "replaceitem block <x> <y> <z> slot.villager.<slot_number> <item> <amount>",
      "replaceitem block <x> <y> <z> slot.villager.<slot_number> <item> <amount> <data>",
      "replaceitem block <x> <y> <z> slot.villager.<slot_number> <item> <amount> <data> <dataTag>",
      "replaceitem entity <selector> slot.villager.<slot_number> <item>",
      "replaceitem entity <selector> slot.villager.<slot_number> <item> <amount>",
      "replaceitem entity <selector> slot.villager.<slot_number> <item> <amount> <data>",
      "replaceitem entity <selector> slot.villager.<slot_number> <item> <amount> <data> <dataTag>",
      "save-all",
      "save-all <flush>",
      "save-off",
      "save-on",
      "say <message>",
      "scoreboard <objectives>",
      "scoreboard <players>",
      "scoreboard <teams>",
      "seed",
      "setblock <x> <y> <z> <block>",
      "setblock <x> <y> <z> <block> <dataValue>",
      "setblock <x> <y> <z> <block> <state>",
      "setblock <x> <y> <z> <block> <dataValue> destroy",
      "setblock <x> <y> <z> <block> <state> destroy",
      "setblock <x> <y> <z> <block> <dataValue> destroy <dataTag>",
      "setblock <x> <y> <z> <block> <state> destroy <dataTag>",
      "setblock <x> <y> <z> <block> <dataValue> keep",
      "setblock <x> <y> <z> <block> <state> keep",
      "setblock <x> <y> <z> <block> <dataValue> keep <dataTag>",
      "setblock <x> <y> <z> <block> <state> keep <dataTag>",
      "setblock <x> <y> <z> <block> <dataValue> replace",
      "setblock <x> <y> <z> <block> <state> replace",
      "setblock <x> <y> <z> <block> <dataValue> replace <dataTag>",
      "setblock <x> <y> <z> <block> <state> replace <dataTag>",
      "setidletimeout <minutes>",
      "setworldspawn",
      "setworldspawn <x> <y> <z>",
      "spawnpoint",
      "spawnpoint <player>",
      "spawnpoint <player> <x> <y> <z>",
      "spreadplayers <x> <z> <spreadDistance> <maxRange> true <players>",
      "spreadplayers <x> <z> <spreadDistance> <maxRange> false <players>",
      "stats block <x> <y> <z> clear AffectedBlocks",
      "stats block <x> <y> <z> set AffectedBlocks <selector> <objective>",
      "stats entity <selector> clear AffectedBlocks",
      "stats entity <selector> set AffectedBlocks <selector> <objective>",
      "stats block <x> <y> <z> clear AffectedEntities",
      "stats block <x> <y> <z> set AffectedEntities <selector> <objective>",
      "stats entity <selector> clear AffectedEntities",
      "stats entity <selector> set AffectedEntities <selector> <objective>",
      "stats block <x> <y> <z> clear AffectedItems",
      "stats block <x> <y> <z> set AffectedItems <selector> <objective>",
      "stats entity <selector> clear AffectedItems",
      "stats entity <selector> set AffectedItems <selector> <objective>",
      "stats block <x> <y> <z> clear QueryResult",
      "stats block <x> <y> <z> set QueryResult <selector> <objective>",
      "stats entity <selector> clear QueryResult",
      "stats entity <selector> set QueryResult <selector> <objective>",
      "stats block <x> <y> <z> clear SuccessCount",
      "stats block <x> <y> <z> set SuccessCount <selector> <objective>",
      "stats entity <selector> clear SuccessCount",
      "stats entity <selector> set SuccessCount <selector> <objective>",
      "stop",
      "stopsound <player>",
      "stopsound <player> master",
      "stopsound <player> master <sound>",
      "stopsound <player> music",
      "stopsound <player> music <sound>",
      "stopsound <player> record",
      "stopsound <player> record <sound>",
      "stopsound <player> weather",
      "stopsound <player> weather <sound>",
      "stopsound <player> block",
      "stopsound <player> block <sound>",
      "stopsound <player> hostile",
      "stopsound <player> hostile <sound>",
      "stopsound <player> neutral",
      "stopsound <player> neutral <sound>",
      "stopsound <player> player",
      "stopsound <player> player <sound>",
      "stopsound <player> ambient",
      "stopsound <player> ambient <sound>",
      "stopsound <player> voice",
      "stopsound <player> voice <sound>",
      "summon <entityName>",
      "summon <entityName> <x> <y> <z>",
      "summon <entityName> <x> <y> <z> <dataTag>",
      "teleport <target entity> <x> <y> <z>",
      "teleport <target entity> <x> <y> <z> <y-rot> <x-rot>",
      "tell <player> <message>",
      "tellraw <player> <jsonMessage>",
      "testfor <player>",
      "testfor <player> <dataTag>",
      "testforblock <x> <y> <z> <block> <dataValue>",
      "testforblock <x> <y> <z> <block> <state>",
      "testforblock <x> <y> <z> <block> <dataValue> <dataTag>",
      "testforblock <x> <y> <z> <block> <state> <dataTag>",
      "testforblocks <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> all",
      "testforblocks <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> masked",
      "time <add> <value>",
      "time <query> <value>",
      "time <set> <value>",
      "title <player> clear",
      "title <player> reset",
      "title <player> title <jsonTitle>",
      "title <player> subtitle <jsonTitle>",
      "title <player> actionbar <jsonTitle>",
      "title <player> times <fadeIn> <stay> <fadeOut>",
      "toggledownfall",
      "tp <destinationPlayer>",
      "tp <player> <destinationPlayer>",
      "tp <player> <x> <y> <z>",
      "tp <player> <x> <y> <z> <yaw> <pitch>",
      "trigger <objective> <add> <value>",
      "trigger <objective> <set> <value>",
      "weather <clear>",
      "weather <clear> <duration>",
      "weather <rain>",
      "weather <rain> <duration>",
      "weather <thunder>",
      "weather <thunder> <duration>",
      "whitelist add <player>",
      "whitelist list",
      "whitelist off",
      "whitelist on",
      "whitelist reload",
      "whitelist remove <player>",
      "worldborder add <distance>",
      "worldborder add <distance> <time>",
      "worldborder center <x> <z>",
      "worldborder damage amount <damagePerBlock>",
      "worldborder damage buffer <distance>",
      "worldborder get",
      "worldborder set <distance>",
      "worldborder set <distance> <time>",
      "worldborder warning distance <distance>",
      "worldborder warning time 15",
      "worldborder warning time <time>",
      "wsserver <serverURI>",
      "connect <serverURI>",
      "xp <amount>",
      "xp <amount> <player>",
      "xp <amount>L",
      "xp <amount>L <player>"
    ].sort();;
  $("#txtCommand").autocomplete({
    source: autocompleteCommands,
    appendTo: "#txtCommandResults",
    open: function() {
      var position = $("#txtCommandResults").position(),
          left = position.left, 
          top = position.top,
          width = $("#txtCommand").width(),
          height = $("#txtCommandResults > ul").height();
      $("#txtCommandResults > ul")
        .css({
          left: left + "px",
          top: top - height - 4 + "px",
          width: 43 + width + "px"
        });
    }
  });

  $("#serverControl > button").click(function() {
    sendServerCommand($(this).children("span").text().trim())
  })

  getStatus()
  setInterval(getStatus, 5000)
});

function logMsg(msg, sep, cls){
  var date = new Date(), 
      datetime = 
        ("0" + date.getDate()).slice(-2) + "-" + ("0" + (date.getMonth() + 1)).slice(-2) + "-" + date.getFullYear() + " @ " +
        ("0" + date.getHours()).slice(-2) + ":" + ("0" + date.getMinutes()).slice(-2) + ":" + ("0" + date.getSeconds()).slice(-2);
  $("#groupConsole")
    .append("<li class=\"list-group-item list-group-item-" + cls + " d-flex justify-content-between align-items-center\"><span><strong>" + sep + "</strong> " + msg + "</span><span class=\"badge bg-" + cls + "\">" + datetime + "</span></li>");
  $("#btnSend").prop("disabled", false);
  // Clear old logs
  var logItemSize = $("#groupConsole li").size();
  if(logItemSize > 50){
    $("#groupConsole li:first").remove();
  }
  // Scroll down
  if($("#chkAutoScroll").is(":checked")){
    $("#consoleContent").scrollTop($("#groupConsole").get(0).scrollHeight);
  }
}
function logSuccess(log){
  logMsg(log, "<", "success");
}
function logInfo(log){
  logMsg(log, "<", "info");
}
function logWarning(log){
  logMsg(log, "<", "warning");
}
function logDanger(log){
  logMsg(log, "<", "danger");
}

function alertMsg(msg, cls){
  $("#alertMessage").fadeOut("slow", function(){
    $("#alertMessage").attr("class", "alert alert-"+cls);
    $("#alertMessage").html(msg);
    $("#alertMessage").fadeIn("slow", function(){});
  });
}
function alertSuccess(msg){
  alertMsg(msg, "success");
}
function alertInfo(msg){
  alertMsg(msg, "info");
}
function alertWarning(msg){
  alertMsg(msg, "warning");
}
function alertDanger(msg){
  alertMsg(msg, "danger");
}

function sendCommand(command){
  if (command == "") {
    alertDanger("Command missing.");
    return;
  }
  logMsg(command, ">", "success");
  $.post("rcon/index.php", { cmd: command })
    .done(function(json){
      if(json.status){
        if(json.status == 'success' && json.response && json.command){
          if(json.response.indexOf("Unknown command") != -1){
            alertDanger("Unknown command : " + json.command); 
            logDanger(json.response);
          }
          else if(json.response.indexOf("Usage") != -1){
            alertWarning(json.response); 
            logWarning(json.response);
          }
          else{
            alertSuccess("Send success.");
            logInfo(json.response);
          }
        }
        else if(json.status == 'error' && json.error){
          alertDanger(json.error); 
          logDanger(json.error);
        }
        else{
          alertDanger("Malformed RCON api response"); 
          logDanger("Malformed RCON api response");
        }
      }
      else{
        alertDanger("RCON api error (no status returned)"); 
        logDanger("RCON api error (no status returned)");
      }
    })
    .fail(function() {
      alertDanger("RCON error.");
      logDanger("RCON error.");
    });
}

function getStatus() {
  $.get("control/?query=status")
    .done(function(json) {
      switch (json.status || null) {
        case "success":
          styles = {'Starting': 'info', 'Up': 'success', 'Paused': 'warning', 'Down': 'danger'}
          $('#serverStatus').text(json.response).attr('class', 'text-'+styles[json.response])
          break
        case "error":
          alertDanger(json.error)
          logDanger(json.error)
          break
        default:
          alertDanger("query api error (no status returned)"); 
          logDanger("query api error (no status returned)");
      }
    })
    .fail(function() {
      alertDanger("getStatus request error")
      logDanger("getStatus request error")
    }).then(function() {
      if ($('#serverStatus').text() == "Up") {
        $.get("control/?query=version")
        .done(function(json) {
          switch (json.status || null) {
            case "success":
              $('#serverVersion').text(json.response).attr('class', 'text-info')
              break
            case "error":
              alertDanger(json.error)
              logDanger(json.error)
              break
            default:
              alertDanger("query api error (no status returned)"); 
              logDanger("query api error (no status returned)");
          }
        })
        .fail(function() {
          alertDanger("getStatus request error")
          logDanger("getStatus request error")
        })
      }
    })
}

function sendServerCommand(command) {
  if (! (window.processingCommand || false)) {
    window.processingCommand = true
    $.post("control/", {'command': command})
      .done(function(json) {
        switch (json.status) {
          case "success":
            alertSuccess(`Requested ${json.command}`)
            logSuccess(`Requested ${json.command}`)
            window.qcrInt = setInterval(queryCommandResult, 2000)
            break
          case "error":
            alertDanger(json.error)
            logDanger(json.error)
            window.processingCommand = false
            break
          default:
            alertDanger("query api error (no status returned)"); 
            logDanger("query api error (no status returned)");
            window.processingCommand = false
        }
      })
      .fail(function() {
        alertDanger("sendServerControl request error")
        logDanger("sendServerControl request error")
        window.processingCommand = false
      })
  }
}

function queryCommandResult() {
  $.get("control/?query=command_result")
    .done(function(json) {
      switch (json.status || null) {
        case "success":
          alertSuccess("Command successful")
          logSuccess("Command successful")
          clearInterval(window.qcrInt)
          window.processingCommand = false
          break
        case "pending":
          break
        case "error":
          alertDanger(json.error)
          logDanger(json.error)
          break
        default:
          alertDanger("query api error (no status returned)"); 
          logDanger("query api error (no status returned)");
      }
    })
    .fail(function() {
      alertDanger("getStatus request error")
      logDanger("getStatus request error")
    })
}