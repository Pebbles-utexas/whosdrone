/*
	Custom shapeshift, revert on death enabled
*/
/datum/action/cooldown/spell/shapeshift/whoscifer
	name = "Whoscifer Transformation"
	desc = "Transform into a cutie, or back again!"
	button_icon_state = "gib"
	cooldown_time = 0 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	convert_damage = FALSE
	possible_shapes = list(/mob/living/simple_animal/slime/transformed_slime/whoscifer)
	var/mob/living/shapeshifted_form

/*
	Rainbow slime transformation with custom slime power
*/
/mob/living/simple_animal/slime/transformed_slime/whoscifer
	colour = "rainbow"
	var/datum/action/temp_powers = list()

/mob/living/simple_animal/slime/transformed_slime/whoscifer/Initialize(mapload)
	. = ..()
	var/datum/action/whoscifer/rainbow_slime_power/gay = new(src)
	gay.Grant(src)
	temp_powers += gay

/datum/action/whoscifer/IsAvailable(feedback = FALSE)
	return TRUE
/datum/action/whoscifer/rainbow_slime_power
	name = "Rainbow Reproduction!"
	desc = "Produce 3 slimes of random colors."
	button_icon = 'icons/mob/simple/slimes.dmi'
	button_icon_state = "rainbow adult slime"
/datum/action/whoscifer/rainbow_slime_power/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	for (var/i in 1 to 3)
		var/mob/living/simple_animal/slime/S = new(get_turf(owner))
		S.random_colour()
	return TRUE

/*
	Teleportation power
*/
/mob/living/simple_animal/drone/whoscifer_drone/proc/on_middle_click(mob/source, atom/target)
	SIGNAL_HANDLER
	src.face_atom(target)
	src.teleport(target)
	return COMSIG_MOB_CANCEL_CLICKON

/mob/living/simple_animal/drone/whoscifer_drone/proc/teleport(atom/target)
	var/turf/open/target_turf = get_turf(target)
	if(!istype(target_turf) || target_turf.is_blocked_turf_ignore_climbable())
		balloon_alert(src, "invalid target!")
		return
	balloon_alert(src, "teleporting...")
	var/matrix/pre_matrix = matrix()
	pre_matrix.Scale(4, 0.25)
	var/matrix/post_matrix = matrix()
	post_matrix.Scale(0.25, 4)
	animate(src, 2, color = LIGHT_COLOR_BLOOD_MAGIC, transform = pre_matrix.Multiply(src.transform), easing = SINE_EASING|EASE_OUT)
	animate(src, 0.5, color = null, transform = post_matrix.Multiply(src.transform), easing = SINE_EASING|EASE_IN)
	if(!do_teleport(src, target_turf, asoundin = 'sound/effects/phasein.ogg', forced = TRUE))
		return
