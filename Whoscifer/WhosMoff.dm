/obj/item/toy/plush/moth/whoscifer
	name = "Whoscifer's Moth Plushie"
	inhand_icon_state = "moffplush"
	lefthand_file = 'icons/obj/toys/plushes.dmi'
	righthand_file = 'icons/obj/toys/plushes.dmi'
	layer = BELOW_MOB_LAYER
	divine = TRUE
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	var/datum/action/cooldown/spell/pointed/projectile/moth_circle/moth_spell = null

/obj/item/toy/plush/moth/whoscifer/attack_self(mob/user)
	/*
	if(!isliving(user))
		return
	if(moth_spell != null)
		qdel(moth_spell)
	else
		moth_spell = new /datum/action/cooldown/spell/pointed/projectile/moth_circle()
		moth_spell.on_activation(user)
	*/
	return ..()

obj/projectile/moffplush
	name = "moth plushie"
	icon = 'icons/obj/toys/plushes.dmi'
	icon_state = "moffplush"
	speed = 0.5
	damage = 25
	armour_penetration = 100
	dismemberment = 100
	sharpness = SHARP_EDGED
	wound_bonus = 25
	pass_flags = PASSTABLE | PASSFLAPS
	reflectable = NONE
	eyeblur = 3
	homing = TRUE

/obj/projectile/moffplush/on_hit(atom/target, blocked = FALSE, pierce_hit)
	blocked = FALSE
	playsound(src, 'sound/voice/moth/scream_moth.ogg', 50, TRUE, -1)
	return ..()

/obj/projectile/moffplush/prehit_pierce(atom/hit)
	if(isliving(hit) && isliving(firer))
		var/mob/living/caster = firer
		var/mob/living/victim = hit
		if(caster == victim)
			return PROJECTILE_PIERCE_PHASE
	return ..()

/*
	Based off the Silver Blades spell
*/
/datum/action/cooldown/spell/pointed/projectile/moth_circle
	name = "Circle of Moths"
	desc = "Summon three moth plushies which orbit you. \
		While orbiting you, these moth will protect you from from attacks, but will be consumed on use. \
		Additionally, you can click to fire the moths at a target, dealing damage, causing bleeding, and dismemberment."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "furious_steel"
	sound = 'sound/voice/moth/scream_moth.ogg'

	school = SCHOOL_CONJURATION
	cooldown_time = 3 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	active_msg = "You summon three moth plushies of cuteness."
	deactive_msg = "You return the moth plushies to their realm."
	cast_range = 20
	projectile_type = /obj/projectile/moffplush
	projectile_amount = 3
	var/datum/status_effect/moth_circle_status/moth_circle_effect

/datum/action/cooldown/spell/pointed/projectile/moth_circle/InterceptClickOn(mob/living/caller, params, atom/click_target)
	if(get_dist(caller, click_target) <= 1)
		return FALSE
	return ..()
/datum/action/cooldown/spell/pointed/projectile/moth_circle/on_activation(mob/on_who)
	. = ..()
	if(!.)
		return

	if(!isliving(on_who))
		return
	if(moth_circle_effect)
		UnregisterSignal(moth_circle_effect, COMSIG_PARENT_QDELETING)
		QDEL_NULL(moth_circle_effect)

	set_click_ability(on_who)
	var/mob/living/living_user = on_who
	moth_circle_effect = living_user.apply_status_effect(/datum/status_effect/moth_circle_status, null, projectile_amount, 25, 0.66 SECONDS)
	RegisterSignal(moth_circle_effect, COMSIG_PARENT_QDELETING, PROC_REF(on_status_effect_deleted))

/datum/action/cooldown/spell/pointed/projectile/moth_circle/on_deactivation(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	unset_click_ability(on_who)
	QDEL_NULL(moth_circle_effect)

/datum/action/cooldown/spell/pointed/projectile/moth_circle/fire_projectile(mob/living/user, atom/target)
	. = ..()
	qdel(moth_circle_effect.plushies[1])

/datum/action/cooldown/spell/pointed/projectile/moth_circle/ready_projectile(obj/projectile/to_launch, atom/target, mob/user, iteration)
	. = ..()
	to_launch.def_zone = check_zone(user.zone_selected)

/datum/action/cooldown/spell/pointed/projectile/moth_circle/proc/on_status_effect_deleted(datum/status_effect/moth_circle_status/source)
	SIGNAL_HANDLER
	moth_circle_effect = null
	on_deactivation()


/*
	Based off the Silver Blades spell status
*/

/datum/status_effect/moth_circle_status
	id = "moth circle status"
	alert_type = null
	status_type = STATUS_EFFECT_MULTIPLE
	tick_interval = -1
	var/max_num_plushies = 3
	var/plushie_orbit_radius = 20
	var/time_between_initial_plushies = 0.25 SECONDS
	var/delete_on_plushies_gone = TRUE
	var/list/obj/effect/floating_plushie/plushies = list()

/datum/status_effect/moth_circle_status/on_creation(
			mob/living/new_owner,
			new_duration = -1,
			max_num_plushies = 3,
			plushie_orbit_radius = 20,
			time_between_initial_plushies = 0.25 SECONDS,
		)
	src.duration = new_duration
	src.max_num_plushies = max_num_plushies
	src.plushie_orbit_radius = plushie_orbit_radius
	src.time_between_initial_plushies = time_between_initial_plushies
	return ..()

/datum/status_effect/moth_circle_status/on_apply()
	RegisterSignal(owner, COMSIG_HUMAN_CHECK_SHIELDS, PROC_REF(on_shield_reaction))
	for(var/plushie_num in 1 to max_num_plushies)
		var/time_until_created = (plushie_num - 1) * time_between_initial_plushies
		if(time_until_created <= 0)
			create_plushie()
		else
			addtimer(CALLBACK(src, PROC_REF(create_plushie)), time_until_created)
	return TRUE

/datum/status_effect/moth_circle_status/on_remove()
	UnregisterSignal(owner, COMSIG_HUMAN_CHECK_SHIELDS)
	QDEL_LIST(plushies)

	return ..()

/datum/status_effect/moth_circle_status/proc/create_plushie()
	if(QDELETED(src) || QDELETED(owner))
		return

	var/obj/effect/floating_plushie/plushie = new(get_turf(owner))
	plushies += plushie
	plushie.orbit(owner, plushie_orbit_radius)
	RegisterSignal(plushie, COMSIG_PARENT_QDELETING, PROC_REF(remove_plushie))
	playsound(get_turf(owner), 'sound/voice/moth/scream_moth.ogg', 15, TRUE)

/datum/status_effect/moth_circle_status/proc/on_shield_reaction(
	mob/living/source,
	atom/movable/hitby,
	damage = 0,
	attack_text = "the attack",
	attack_type = MELEE_ATTACK,
	armour_penetration = 0,
)
	SIGNAL_HANDLER

	armour_penetration = 0
	if(!length(plushies))
		return

	var/obj/effect/floating_plushie/to_remove = plushies[1]

	playsound(get_turf(source), 'sound/voice/moth/scream_moth.ogg', 100, TRUE)
	source.visible_message(
		span_warning("[to_remove] orbiting [source] snaps in front of [attack_text], blocking it before vanishing!"),
		span_warning("[to_remove] orbiting you snaps in front of [attack_text], blocking it before vanishing!"),
		span_hear("You hear a moth scream."),
	)
	qdel(to_remove)
	return SHIELD_BLOCK

/datum/status_effect/moth_circle_status/proc/remove_plushie(obj/effect/floating_plushie/to_remove)
	SIGNAL_HANDLER

	if(!(to_remove in plushies))
		CRASH("[type] called remove_plushie() with a plushie that was not in its plushies list.")

	to_remove.stop_orbit(owner.orbiters)
	plushies -= to_remove

	if(!length(plushies) && !QDELETED(src) && delete_on_plushies_gone)
		qdel(src)

	return TRUE

/datum/status_effect/moth_circle_status/recharging
	delete_on_plushies_gone = FALSE
	var/plushie_recharge_time = 1 SECONDS

/datum/status_effect/moth_circle_status/recharging/on_creation(
	mob/living/new_owner,
	new_duration = -1,
	max_num_plushies = 3,
	plushie_orbit_radius = 20,
	time_between_initial_plushies = 0.25 SECONDS,
	plushie_recharge_time = 1 SECONDS,
)

	src.plushie_recharge_time = plushie_recharge_time
	return ..()

/datum/status_effect/moth_circle_status/recharging/remove_plushie(obj/effect/floating_plushie/to_remove)
	. = ..()
	if(!.)
		return

	addtimer(CALLBACK(src, PROC_REF(create_plushie)), plushie_recharge_time)

/obj/effect/floating_plushie
	name = "floating moth plushie"
	icon = 'icons/obj/toys/plushes.dmi'
	icon_state = "moffplush"
	plane = GAME_PLANE_FOV_HIDDEN
	var/glow_color = "#ececff"

/obj/effect/floating_plushie/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/movetype_handler)
	ADD_TRAIT(src, TRAIT_MOVE_FLYING, INNATE_TRAIT)
	add_filter("moffplush", 2, list("type" = "outline", "color" = glow_color, "size" = 1))
