/obj/item/storage/bag/bio/drone
	name = "Drone Slimebag"
/obj/item/storage/bag/bio/drone/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 3072
	atom_storage.max_slots = 3072
	atom_storage.set_holdable(list(
		/obj/item/slimecross,
		/obj/item/slime_extract/,
	))

/obj/item/storage/bag/xeno/drone
	name = "Drone Xenobag"
/obj/item/storage/bag/xeno/drone/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 3072
	atom_storage.max_slots = 3072

/obj/item/storage/bag/plants/drone
	name = "Drone Plantbag"
/obj/item/storage/bag/plants/drone/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 3072
	atom_storage.max_slots = 3072

/obj/item/storage/bag/plants/portaseeder/drone
	name = "Drone Seed Extractor"
/obj/item/storage/bag/plants/portaseeder/drone/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 3072
	atom_storage.max_slots = 3072

/obj/item/necromantic_stone/whos
	name = "Lich Gem"
	unlimited = TRUE
	applied_outfit = /datum/outfit/job/scientist
	max_thralls = 666

/obj/item/soap/omega/whos
	uses = 1000000

/obj/item/extinguisher/mini/whos
	name = "Drone Mini Fire Extinguisher"
	max_water = 1000
/obj/item/extinguisher/mini/whos/afterattack(atom/target, mob/user , flag)
	reagents.total_volume = reagents.maximum_volume
	..()

/obj/item/debug/omnitool/whoscifer
	name = "Whoscifer's Omnitool"
	desc = "The divine tool, shaped before time. Use it in hand to unleash its true power."
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "sunflower"
	inhand_icon_state = "sunflower"
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
