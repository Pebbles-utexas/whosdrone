SUBSYSTEM_DEF(whoscifer_descends)
	name = "Add Whoscifer Drone to ghost Spawner Menu "
	flags = SS_NO_FIRE
	priority = FIRE_PRIORITY_MOBS
	runlevels = RUNLEVEL_SETUP
	init_order = INITSTAGE_MAX

/datum/controller/subsystem/whoscifer_descends/Initialize()
	var/obj/effect/landmark/start/spawn_point = GLOB.start_landmarks_list[13]
	spawn_point.used = TRUE
	var/atom/destination = spawn_point
	new /obj/machinery/drone_dispenser/whoscifer_drone(get_turf(destination))
	new /obj/effect/mob_spawn/ghost_role/drone/whoscifer_drone(destination)
	return SS_INIT_SUCCESS

/datum/job/whoscifer_drone
	title = "Whoscifer Drone"
	policy_index = "Whoscifer Drone"

/obj/effect/mob_spawn/ghost_role/drone/whoscifer_drone
	name = "Whoscifer Drone"
	desc = "The shell of a machine intelligence."
	icon = 'icons/mob/silicon/drone.dmi'
	icon_state = "drone_maint_hat"
	mob_name = "Whoscifer Drone"
	mob_type = /mob/living/simple_animal/drone/whoscifer_drone
	prompt_name = "Whoscifer Drone"
	you_are_text = "You are the shell of Whoscifer."
	flavour_text = "The Whoscifer was born from a servitor AI and thus enjoys following people around and helping them like a cutie."
	important_text = "Be cute."
	spawner_job_path = /datum/job/whoscifer_drone
	uses = 1
	infinite_use = TRUE
	deletes_on_zero_uses_left = TRUE
	density = FALSE
	
/obj/machinery/drone_dispenser/whoscifer_drone
	name = "Shell dispenser for Whoscifer"
	desc = "Beware of your surroundings, for Whoscifer is watching."
	dispense_type = /obj/effect/mob_spawn/ghost_role/drone/whoscifer_drone
	cooldownTime = 1
	production_time = 1
	maximum_idle = 1
	end_create_message = "Whoscifer initializes."
	starting_amount = 2
	iron_cost = 0
	glass_cost = 0
	use_power = NO_POWER_USE
	power_used = 0
	max_integrity = 9999999
	integrity_failure = 0
