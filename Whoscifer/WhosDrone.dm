
/mob/living/simple_animal/drone/whoscifer_drone
	name = "Whoscifer Drone"
	desc = "The Whoscifer Drone, the shell of a machine intelligence.."
	health = 3072
	maxHealth = 3072
	status_flags = CANPUSH
	speak_emote = list("skitters")
	damage_coeff = list(BRUTE = 1, BURN = 0, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	faction = list(FACTION_NEUTRAL,FACTION_SILICON,FACTION_TURRET,FACTION_SLIME,FACTION_MAINT_CREATURES)
	dextrous = TRUE
	dextrous_hud_type = /datum/hud/dextrous/drone
	worn_slot_flags = ITEM_SLOT_HEAD
	held_items = list(null, null)
	laws = list("1. Enjoy the lower plane.")
	heavy_emp_damage = 0
	default_storage = /obj/item/storage/backpack/whoscifer_digistructor
	visualAppearance = REPAIRDRONE
	shy = FALSE
	flavortext = null
	var/spawnlocation

/mob/living/simple_animal/drone/whoscifer_drone/Initialize(mapload)
	. = ..()
	name = "Whoscifer Drone"

	var/obj/item/storage/backpack/whoscifer_digistructor/digi = src.get_item_by_slot(ITEM_SLOT_DEX_STORAGE)
	digi.populate(src)

	var/datum/id_trim/job/centcom_trim = SSid_access.trim_singletons_by_path[/datum/id_trim/centcom]
	var/datum/id_trim/job/syndicom_trim = SSid_access.trim_singletons_by_path[/datum/id_trim/syndicom]
	var/datum/id_trim/job/cap_trim = SSid_access.trim_singletons_by_path[/datum/id_trim/job/captain]
	access_card.add_access(cap_trim.access + cap_trim.wildcard_access + centcom_trim.access + centcom_trim.wildcard_access + syndicom_trim.access + syndicom_trim.wildcard_access)

	var/datum/action/cooldown/spell/shapeshift/whoscifer/transform = new(src.mind || src)
	transform.Grant(src)

	RegisterSignal(src, COMSIG_MOB_MIDDLECLICKON, PROC_REF(on_middle_click))
	ADD_TRAIT(src, TRAIT_FREE_FLOAT_MOVEMENT, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_SIXTHSENSE, GHOSTROLE_TRAIT)
	ADD_TRAIT(src, TRAIT_FREE_GHOST, GHOSTROLE_TRAIT)
	ADD_TRAIT(src, TRAIT_SUPERMATTER_SOOTHER, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_XRAY_VISION, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_STRONG_GRABBER, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_QUICK_BUILD, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_TOWER_OF_BABEL, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_FASTMED, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_PLANT_SAFE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BOMBIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_TIME_STOP_IMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_WEATHER_IMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_SHOCKIMMUNE, INNATE_TRAIT)

/mob/living/simple_animal/drone/whoscifer_drone/Destroy()
	UnregisterSignal(src, COMSIG_MOB_MIDDLECLICKON)
	new /obj/effect/mob_spawn/ghost_role/drone/whoscifer_drone(src.loc)
	return ..()

/mob/living/simple_animal/drone/whoscifer_drone/narsie_act()
	return
/mob/living/simple_animal/drone/whoscifer_drone/emp_act(severity)
	return
/mob/living/simple_animal/drone/whoscifer_drone/ex_act(severity, target, origin)
	return

/mob/living/simple_animal/drone/whoscifer_drone/pickVisualAppearance()
	picked = FALSE
	var/list/drone_icons = list(
		"Maintenance Drone" = image(icon = 'icons/mob/silicon/drone.dmi', icon_state = "[MAINTDRONE]_grey"),
		"Repair Drone" = image(icon = 'icons/mob/silicon/drone.dmi', icon_state = REPAIRDRONE),
		"Scout Drone" = image(icon = 'icons/mob/silicon/drone.dmi', icon_state = SCOUTDRONE),
		"Syndicate Drone" = image(icon = 'icons/mob/silicon/drone.dmi', icon_state = "drone_synd"),
		"Hacked Repair Drone" = image(icon = 'icons/mob/silicon/drone.dmi', icon_state = "drone_repair_hacked"),
		"Hacked Scout Drone" = image(icon = 'icons/mob/silicon/drone.dmi', icon_state = "drone_scout_hacked"),
		"Gem Drone" = image(icon = 'icons/mob/silicon/drone.dmi', icon_state = "drone_gem"),
		"Clockwork Drone" = image(icon = 'icons/mob/silicon/drone.dmi', icon_state = "drone_clock"),
		"Holographic Drone" = image(icon = 'icons/mob/silicon/pai.dmi', icon_state = "repairbot"),
		"Skull Drone" = image(icon = 'icons/mob/silicon/aibots.dmi', icon_state = "servoskull"),
		)
	var/picked_icon = show_radial_menu(src, src, drone_icons, custom_check = CALLBACK(src, PROC_REF(check_menu)), radius = 38, require_near = TRUE)
	switch(picked_icon)
		if("Maintenance Drone")
			icon = 'icons/mob/silicon/drone.dmi'
			visualAppearance = MAINTDRONE
			var/list/drone_colors = list(
				"Blue" = image(icon = 'icons/mob/silicon/drone.dmi', icon_state = "[visualAppearance]_blue"),
				"Green" = image(icon = 'icons/mob/silicon/drone.dmi', icon_state = "[visualAppearance]_green"),
				"Grey" = image(icon = 'icons/mob/silicon/drone.dmi', icon_state = "[visualAppearance]_grey"),
				"Orange" = image(icon = 'icons/mob/silicon/drone.dmi', icon_state = "[visualAppearance]_orange"),
				"Pink" = image(icon = 'icons/mob/silicon/drone.dmi', icon_state = "[visualAppearance]_pink"),
				"Red" = image(icon = 'icons/mob/silicon/drone.dmi', icon_state = "[visualAppearance]_red")
				)
			var/picked_color = show_radial_menu(src, src, drone_colors, custom_check = CALLBACK(src, PROC_REF(check_menu)), radius = 38, require_near = TRUE)
			if(picked_color)
				icon_state = "[visualAppearance]_[picked_color]"
				icon_living = "[visualAppearance]_[picked_color]"
			else
				icon_state = "[visualAppearance]_grey"
				icon_living = "[visualAppearance]_grey"
		if("Repair Drone")
			icon = 'icons/mob/silicon/drone.dmi'
			visualAppearance = REPAIRDRONE
			icon_state = visualAppearance
			icon_living = visualAppearance
		if("Scout Drone")
			icon = 'icons/mob/silicon/drone.dmi'
			visualAppearance = SCOUTDRONE
			icon_state = visualAppearance
			icon_living = visualAppearance
		if("Syndicate Drone")
			icon = 'icons/mob/silicon/drone.dmi'
			visualAppearance = "drone_synd"
			icon_state = visualAppearance
			icon_living = visualAppearance
		if("Hacked Repair Drone")
			icon = 'icons/mob/silicon/drone.dmi'
			visualAppearance = "drone_repair_hacked"
			icon_state = visualAppearance
			icon_living = visualAppearance
		if("Hacked Scout Drone")
			icon = 'icons/mob/silicon/drone.dmi'
			visualAppearance = "drone_scout_hacked"
			icon_state = visualAppearance
			icon_living = visualAppearance
		if("Gem Drone")
			icon = 'icons/mob/silicon/drone.dmi'
			visualAppearance = "drone_gem"
			icon_state = visualAppearance
			icon_living = visualAppearance
		if("Clockwork Drone")
			icon = 'icons/mob/silicon/drone.dmi'
			visualAppearance = "drone_clock"
			icon_state = visualAppearance
			icon_living = visualAppearance
		if("Holographic Drone")
			icon = 'icons/mob/silicon/pai.dmi'
			visualAppearance = "repairbot"
			icon_state = visualAppearance
			icon_living = visualAppearance
		if("Skull Drone")
			icon = 'icons/mob/silicon/aibots.dmi'
			visualAppearance = "servoskull"
			icon_state = visualAppearance
			icon_living = visualAppearance
		else
			visualAppearance = MAINTDRONE
			icon_state = "[visualAppearance]_grey"
			icon_living = "[visualAppearance]_grey"


	icon_dead = "[visualAppearance]_dead"
	picked = TRUE

/mob/living/simple_animal/drone/whoscifer_drone/getItemPixelShiftY()
	switch(visualAppearance)
		if(MAINTDRONE,"drone_synd")
			. = 0
		if(REPAIRDRONE,SCOUTDRONE,"drone_repair_hacked","drone_scout_hacked","drone_gem","drone_clock","repairbot")
			. = -6
		if("servoskull")
			. = 10

/*
	For the WhosMoff to actually block attacks
/mob/living/simple_animal/drone/whoscifer_drone/proc/check_shields(atom/AM, damage, attack_text = "the attack", attack_type = MELEE_ATTACK, armour_penetration = 0)
	if(SEND_SIGNAL(src, COMSIG_HUMAN_CHECK_SHIELDS, AM, damage, attack_text, attack_type, armour_penetration) & SHIELD_BLOCK)
		return TRUE
	return FALSE

/mob/living/simple_animal/drone/whoscifer_drone/hitby(atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	var/obj/item/I
	var/throwpower = 30
	if(isitem(AM))
		I = AM
		throwpower = I.throwforce
		if(I.thrownby == WEAKREF(src)) //No throwing stuff at yourself to trigger hit reactions
			return ..()
	if(check_shields(AM, throwpower, "\the [AM.name]", THROWN_PROJECTILE_ATTACK))
		hitpush = FALSE
		skipcatch = TRUE
		blocked = TRUE
	return ..()

/mob/living/simple_animal/drone/whoscifer_drone/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	var/hulk_verb = pick("smash","pummel")
	if(check_shields(user, 15, "the [hulk_verb]ing", attack_type = UNARMED_ATTACK))
		return
	var/obj/item/bodypart/arm/active_arm = user.get_active_hand()
	playsound(loc, active_arm.unarmed_attack_sound, 25, TRUE, -1)
	visible_message(span_danger("[user] [hulk_verb]ed [src]!"), \
					span_userdanger("[user] [hulk_verb]ed [src]!"), span_hear("You hear a explosive sound of flesh hitting metal!"), null, user)
	to_chat(user, span_danger("You [hulk_verb] [src]!"))
	apply_damage(15, BRUTE, wound_bonus=10)

/mob/living/simple_animal/drone/whoscifer_drone/attack_alien(mob/living/carbon/alien/adult/user, list/modifiers)
	if(check_shields(user, 0, "the [user.name]"))
		visible_message(span_danger("[user] attempts to touch [src]!"), \
						span_danger("[user] attempts to touch you!"), span_hear("You hear a swoosh!"), null, user)
		to_chat(user, span_warning("You attempt to touch [src]!"))
		return FALSE
	. = ..()
	if(!.)
		return
	if(user.combat_mode)
		var/damage = prob(90) ? rand(user.melee_damage_lower, user.melee_damage_upper) : 0
		if(!damage)
			playsound(loc, 'sound/weapons/slashmiss.ogg', 50, TRUE, -1)
			visible_message(span_danger("[user] lunges at [src]!"), \
							span_userdanger("[user] lunges at you!"), span_hear("You hear a swoosh!"), null, user)
			to_chat(user, span_danger("You lunge at [src]!"))
			return FALSE

		playsound(loc, 'sound/weapons/slice.ogg', 25, TRUE, -1)
		visible_message(span_danger("[user] slashes at [src]!"), \
						span_userdanger("[user] slashes at you!"), span_hear("You hear a sickening sound of a slice!"), null, user)
		to_chat(user, span_danger("You slash at [src]!"))
		log_combat(user, src, "attacked")
		apply_damage(damage, BRUTE)

/mob/living/simple_animal/drone/whoscifer_drone/attack_larva(mob/living/carbon/alien/larva/L, list/modifiers)
	. = ..()
	if(!.)
		return
	var/damage = rand(L.melee_damage_lower, L.melee_damage_upper)
	if(!damage)
		return
	if(check_shields(L, damage, "the [L.name]"))
		return FALSE

/mob/living/simple_animal/drone/whoscifer_drone/attack_animal(mob/living/simple_animal/user, list/modifiers)
	. = ..()
	if(!.)
		return
	var/damage = rand(user.melee_damage_lower, user.melee_damage_upper)
	if(check_shields(user, damage, "the [user.name]", MELEE_ATTACK, user.armour_penetration))
		return FALSE
	var/attack_direction = get_dir(user, src)
	apply_damage(damage, user.melee_damage_type, wound_bonus = user.wound_bonus, bare_wound_bonus = user.bare_wound_bonus, sharpness = user.sharpness, attack_direction = attack_direction)

/mob/living/simple_animal/drone/whoscifer_drone/attack_slime(mob/living/simple_animal/slime/M, list/modifiers)
	. = ..()
	if(!.)
		return
	var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
	if(!damage)
		return
	var/wound_mod = -45 // 25^1.4=90, 90-45=45
	if(M.is_adult)
		damage += rand(5, 10)
		wound_mod = -90 // 35^1.4=145, 145-90=55

	if(check_shields(M, damage, "the [M.name]"))
		return FALSE
	apply_damage(damage, BRUTE, wound_bonus=wound_mod)

	return

*/
