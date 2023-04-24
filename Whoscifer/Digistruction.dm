/*
	Large backpack that the drone spawns with,
	initially full of tools or fun items
*/

/obj/item/storage/backpack/whoscifer_digistructor
	name = "Digistructor"
	desc = "A connection to Whoscifer's storage database."
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "nomod"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	item_flags = NO_MAT_REDEMPTION
	var/list/builtins = list(
		/obj/item/storage/digistruct_module/xeno,
		/obj/item/storage/digistruct_module/botany,
		/obj/item/storage/digistruct_module/medi,
		/obj/item/storage/digistruct_module/mats,
		/obj/item/storage/digistruct_module/eng,
		/obj/item/storage/digistruct_module/jani,
		/obj/item/debug/omnitool/whoscifer,
		/obj/item/hand_tele,
		/obj/item/toy/plush/moth/whoscifer,
	)
	rummage_if_nodrop = FALSE

/obj/item/storage/backpack/whoscifer_digistructor/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
	create_storage(max_specific_storage = WEIGHT_CLASS_GIGANTIC, max_total_storage = 3072, max_slots = 70, storage_type = /datum/storage/bag_of_holding)
	atom_storage.allow_big_nesting = TRUE

/obj/item/storage/backpack/whoscifer_digistructor/proc/populate(player)
	for(var/typepath as anything in builtins)
		var/atom/new_item = new typepath(src)
		if (istype(new_item, /obj/item/storage/digistruct_module/))
			var/obj/item/storage/digistruct_module/new_bag = new_item
			new_bag.populate(player)
			new_item.AddComponent(/datum/component/holderloving/whoscifer/one, src, TRUE)
		else
			new_item.AddComponent(/datum/component/holderloving, src, TRUE)

/*
	Bags intended to be placed inside the digistructor
	as tool/item modules
*/

/obj/item/storage/digistruct_module
	name = "Digistruct Module"
	desc = "Access your digistruct module."
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "nomod"
	item_flags = ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/list/drone_builtins
	var/mob/living/user

/obj/item/storage/digistruct_module/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 5000000
	atom_storage.max_specific_storage = WEIGHT_CLASS_BULKY
	atom_storage.max_slots = 3072
	atom_storage.rustle_sound = FALSE

/obj/item/storage/digistruct_module/proc/populate(player)
	user = player
	for(var/typepath as anything in drone_builtins)
		var/atom/new_item = new typepath(src)
		new_item.AddComponent(/datum/component/holderloving/whoscifer/two, src, TRUE, player)

/obj/item/storage/digistruct_module/xeno
	name = "Xenobiology Digistruct Module"
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "brobot"
	drone_builtins = list(
		/obj/item/storage/bag/bio/drone,
		/obj/item/storage/bag/xeno/drone,
		/obj/item/reagent_containers/syringe/dronehypo/xeno,
		/obj/item/slimecross/recurring/rainbow/eternal,
		/obj/item/slimecross/industrial/rainbow/prismatic,
		/obj/item/slimecross/industrial/grey,
	)

/obj/item/storage/digistruct_module/botany
	name = "Botany Digistruct Module"
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "hydroponics"
	drone_builtins = list(
		/obj/item/cultivator,
		/obj/item/shovel/spade,
		/obj/item/hatchet,
		/obj/item/gun/energy/floragun,
		/obj/item/plant_analyzer,
		/obj/item/geneshears,
		/obj/item/secateurs,
		/obj/item/storage/bag/plants/drone,
		/obj/item/storage/bag/plants/portaseeder/drone,
		/obj/item/reagent_containers/syringe/dronehypo/botany,
	)

/obj/item/storage/digistruct_module/eng
	name = "Engineering Digistruct Module"
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "engineer"
	drone_builtins = list(
		/obj/item/wrench/abductor,
		/obj/item/wirecutters/abductor,
		/obj/item/screwdriver/abductor,
		/obj/item/crowbar/abductor,
		/obj/item/weldingtool/abductor,
		/obj/item/multitool/abductor,
		/obj/item/construction/rcd/borg,
		/obj/item/pipe_dispenser,
		/obj/item/t_scanner,
		/obj/item/analyzer,
	)
/obj/item/storage/digistruct_module/jani
	name = "Janitorial Digistruct Module"
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "janitor"
	drone_builtins = list(
		/obj/item/storage/crayons,
		/obj/item/soap/omega/whos,
		/obj/item/mop/advanced,
		/obj/item/paint/paint_remover,
		/obj/item/storage/bag/trash/bluespace,
		/obj/item/extinguisher/mini/whos,
	)
/obj/item/storage/digistruct_module/medi
	name = "Medical Digistruct Module"
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "medical"
	drone_builtins = list(
		/obj/item/scalpel/alien,
		/obj/item/hemostat/alien,
		/obj/item/retractor/alien,
		/obj/item/circular_saw/alien,
		/obj/item/surgicaldrill/alien,
		/obj/item/cautery/alien,
		/obj/item/roller/robo,
		/obj/item/surgical_drapes,
		/obj/item/surgical_processor,
		/obj/item/healthanalyzer/advanced,
		/obj/item/reagent_containers/syringe/dronehypo/medical,
		/obj/item/gun/medbeam,
		/obj/item/shockpaddles/cyborg,
		/obj/item/necromantic_stone/whos,
		/obj/item/gun/magic/wand/resurrection/debug,
		/obj/item/gun/magic/wand/death/debug,
	)

/obj/item/storage/digistruct_module/mats
	name = "Materials Digistruct Module"
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "miner"
	drone_builtins = list(
		/obj/item/stack/sheet/iron{amount = 50},
		/obj/item/stack/sheet/glass{amount = 50},
		/obj/item/stack/sheet/rglass{amount = 50},
		/obj/item/stack/sheet/plasmaglass{amount = 50},
		/obj/item/stack/sheet/titaniumglass{amount = 50},
		/obj/item/stack/sheet/plastitaniumglass{amount = 50},
		/obj/item/stack/sheet/plasteel{amount = 50},
		/obj/item/stack/sheet/mineral/plastitanium{amount = 50},
		/obj/item/stack/sheet/mineral/titanium{amount = 50},
		/obj/item/stack/sheet/mineral/gold{amount = 50},
		/obj/item/stack/sheet/mineral/silver{amount = 50},
		/obj/item/stack/sheet/mineral/plasma{amount = 50},
		/obj/item/stack/sheet/mineral/uranium{amount = 50},
		/obj/item/stack/sheet/mineral/diamond{amount = 50},
		/obj/item/stack/sheet/mineral/adamantine{amount = 50},
		/obj/item/stack/sheet/bluespace_crystal{amount = 50},
		/obj/item/stack/sheet/mineral/bananium{amount = 50},
		/obj/item/stack/sheet/mineral/wood{amount = 50},
		/obj/item/stack/sheet/plastic{amount = 50},
		/obj/item/stack/sheet/cloth{amount = 50},
		/obj/item/stack/sheet/durathread{amount = 50},
	)
/obj/item/storage/digistruct_module/mats/populate(player)
	user = player
	for(var/typepath as anything in drone_builtins)
		var/atom/new_item = new typepath(src)
		new_item.AddComponent(/datum/component/holderloving/whoscifer/respawn, src, TRUE, player)
