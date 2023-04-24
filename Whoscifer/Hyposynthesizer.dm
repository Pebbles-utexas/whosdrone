/obj/item/reagent_containers/syringe/dronehypo
	name = "Drone Hyposynthesizer"
	desc = "An complete chemical synthesizer and injection system."
	icon = 'icons/obj/medical/syringe.dmi'
	inhand_icon_state = "holy_hypo"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	icon_state = "holy_hypo"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1,5,10,20,50,100)

	var/max_volume_per_reagent = 5000
	var/charge_timer = 0
	var/recharge_time = 10
	var/dispensed_temperature = DEFAULT_REAGENT_TEMPERATURE
	var/bypass_protection = TRUE
	var/upgraded = TRUE

	var/list/default_reagent_types
	var/list/expanded_reagent_types
	var/datum/reagents/stored_reagents
	var/datum/reagent/selected_reagent
	var/tgui_theme = "ntos"


/obj/item/reagent_containers/syringe/dronehypo/Initialize(mapload)
	. = ..()
	stored_reagents = new(new_flags = NO_REACT)
	stored_reagents.maximum_volume = length(default_reagent_types) * (max_volume_per_reagent + 1)
	for(var/reagent in default_reagent_types)
		add_new_reagent(reagent)
	//START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/dronehypo/Destroy()
	//STOP_PROCESSING(SSobj, src)
	return ..()

/// Every [recharge_time] seconds, recharge some reagents for the cyborg
/obj/item/reagent_containers/syringe/dronehypo/process(delta_time)
	charge_timer += delta_time
	if(charge_timer >= recharge_time)
		regenerate_reagents(default_reagent_types)
		charge_timer = 0
	return 1

/// Use this to add more chemicals for the dronehypo to produce.
/obj/item/reagent_containers/syringe/dronehypo/proc/add_new_reagent(datum/reagent/reagent)
	stored_reagents.add_reagent(reagent, (max_volume_per_reagent + 1), reagtemp = dispensed_temperature, no_react = TRUE)

/// Regenerate our supply of all reagents (if they're not full already)
/obj/item/reagent_containers/syringe/dronehypo/proc/regenerate_reagents(list/reagents_to_regen)
	for(var/reagent in reagents_to_regen)
		var/datum/reagent/reagent_to_regen = reagent
		if(!stored_reagents.has_reagent(reagent_to_regen, max_volume_per_reagent))
			stored_reagents.add_reagent(reagent_to_regen, max_volume_per_reagent, reagtemp = dispensed_temperature, no_react = TRUE)

/obj/item/reagent_containers/syringe/dronehypo/attack(mob/living/target_mob, mob/living/user, obj/target)
	if(!selected_reagent)
		balloon_alert(user, "no reagent selected!")
		return
	if(!stored_reagents.has_reagent(selected_reagent.type, amount_per_transfer_from_this))
		balloon_alert(user, "not enough [selected_reagent.name]!")
		return

	if(istype(target_mob))
		if(target_mob.try_inject(user, user.zone_selected, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE | (bypass_protection ? INJECT_CHECK_PENETRATE_THICK : 0)))
			// This is the in-between where we're storing the reagent we're going to inject the injectee with
			// because we cannot specify a singular reagent to transfer in trans_to
			var/datum/reagents/hypospray_injector = new()
			//stored_reagents.remove_reagent(selected_reagent.type, amount_per_transfer_from_this)
			hypospray_injector.add_reagent(selected_reagent.type, amount_per_transfer_from_this, reagtemp = dispensed_temperature, no_react = TRUE)

			to_chat(target_mob, span_warning("You feel a tiny prick!"))
			to_chat(user, span_notice("You inject [target_mob] with the injector ([selected_reagent.name])."))

			if(target_mob.reagents)
				hypospray_injector.trans_to(target_mob, amount_per_transfer_from_this, transfered_by = user, methods = INJECT)
				balloon_alert(user, "[amount_per_transfer_from_this] unit\s injected")
				log_combat(user, target_mob, "injected", src, "(CHEMICALS: [selected_reagent])")
		else
			balloon_alert(user, "[parse_zone(user.zone_selected)] is blocked!")
	else if(target)
		reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user, methods = INJECT)
		balloon_alert(user, "[amount_per_transfer_from_this] unit\s transferred")
		target.update_appearance()


/obj/item/reagent_containers/syringe/dronehypo/afterattack(atom/target, mob/user, proximity)
	if(selected_reagent)
		reagents.add_reagent(selected_reagent.type, max_volume_per_reagent, reagtemp = dispensed_temperature, no_react = TRUE)
	return
/obj/item/reagent_containers/syringe/dronehypo/attackby(obj/item/O, mob/user, params)
	return

/obj/item/reagent_containers/syringe/dronehypo/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BorgHypo", name)
		ui.open()
/obj/item/reagent_containers/syringe/dronehypo/ui_data(mob/user)
	var/list/available_reagents = list()
	for(var/datum/reagent/reagent in stored_reagents.reagent_list)
		if(reagent)
			available_reagents.Add(list(list(
				"name" = reagent.name,
				"volume" = round(reagent.volume, 0.01) - 1,
				"description" = reagent.description,
			))) // list in a list because Byond merges the first list...
	var/data = list()
	data["theme"] = tgui_theme
	data["maxVolume"] = max_volume_per_reagent
	data["reagents"] = available_reagents
	data["selectedReagent"] = selected_reagent?.name
	return data
/obj/item/reagent_containers/syringe/dronehypo/attack_self(mob/user)
	ui_interact(user)
/obj/item/reagent_containers/syringe/dronehypo/ui_act(action, params)
	. = ..()
	if(.)
		return

	for(var/datum/reagent/reagent in stored_reagents.reagent_list)
		if(reagent.name == action)
			selected_reagent = reagent
			reagents.clear_reagents()
			reagents.add_reagent(reagent.type, max_volume_per_reagent, reagtemp = dispensed_temperature, no_react = TRUE)
			. = TRUE

			var/mob/living/drone = loc
			playsound(drone, 'sound/effects/pop.ogg', 50, FALSE)
			balloon_alert(drone, "dispensing [selected_reagent.name]")
			break

/obj/item/reagent_containers/syringe/dronehypo/examine(mob/user)
	. = ..()
	. += "Currently loaded: [selected_reagent ? "[selected_reagent]. [selected_reagent.description]" : "nothing."]"
	. += span_notice("<i>Alt+Click</i> to change transfer amount. Currently set to [amount_per_transfer_from_this]u.")

/obj/item/reagent_containers/syringe/dronehypo/try_syringe(atom/target, mob/user, proximity)
	return
/obj/item/reagent_containers/syringe/dronehypo/afterattack_secondary(atom/target, mob/user, proximity_flag, click_parameters)
	return
/obj/item/reagent_containers/syringe/dronehypo/on_accidental_consumption(mob/living/carbon/victim, mob/living/carbon/user, obj/item/source_item,  discover_after = TRUE)
	return FALSE
/obj/item/reagent_containers/syringe/dronehypo/update_icon_state()
	. = ..()
	icon = 'icons/obj/medical/syringe.dmi'
	inhand_icon_state = "holy_hypo"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	icon_state = "holy_hypo"

/obj/item/reagent_containers/syringe/dronehypo/update_overlays()
	. = ..()

/obj/item/reagent_containers/syringe/dronehypo/afterattack(atom/target, mob/user, proximity)
	return


/*
	Custom loadout for the hyposynthesizer
*/
/obj/item/reagent_containers/syringe/dronehypo/medical
	name = "Drone Medical Hyposynthesizer"
	default_reagent_types = list(
		/datum/reagent/medicine/c2/aiuri,
		/datum/reagent/medicine/c2/convermol,
		/datum/reagent/medicine/epinephrine,
		/datum/reagent/medicine/c2/libital,
		/datum/reagent/medicine/c2/multiver,
		/datum/reagent/medicine/salglu_solution,
		/datum/reagent/medicine/spaceacillin,
		/datum/reagent/medicine/lidocaine,
		/datum/reagent/medicine/omnizine/godblood,
		/datum/reagent/pax,
		/datum/reagent/medicine/haloperidol,
		/datum/reagent/medicine/inacusiate,
		/datum/reagent/medicine/mannitol,
		/datum/reagent/medicine/mutadone,
		/datum/reagent/medicine/oculine,
		/datum/reagent/medicine/oxandrolone,
		/datum/reagent/medicine/pen_acid,
		/datum/reagent/medicine/rezadone,
		/datum/reagent/medicine/sal_acid
	)

/obj/item/reagent_containers/syringe/dronehypo/botany
	name = "Drone Botanical Hyposynthesizer"
	default_reagent_types = list(
		/datum/reagent/water,
		/datum/reagent/saltpetre,
		/datum/reagent/diethylamine,
		/datum/reagent/ash,
		/datum/reagent/brimdust,
		/datum/reagent/medicine/cryoxadone,
		/datum/reagent/plantnutriment/liquidearthquake,
		/datum/reagent/ants,
	)

/obj/item/reagent_containers/syringe/dronehypo/xeno
	name = "Drone Xenobiology Hyposynthesizer"
	default_reagent_types = list(
		/datum/reagent/water,
		/datum/reagent/stable_plasma,
		/datum/reagent/blood,
		/datum/reagent/monkey_powder,
		/datum/reagent/mutationtoxin/moth,
		/datum/reagent/mutationtoxin/pod,
		/datum/reagent/mutationtoxin/jelly,
		/datum/reagent/mutationtoxin/skeleton,
		/datum/reagent/mutationtoxin/abductor,
		/datum/reagent/mutationtoxin/android,
		/datum/reagent/cyborg_mutation_nanomachines,
		/datum/reagent/xenomicrobes,
		/datum/reagent/magillitis,
		/datum/reagent/aslimetoxin,
	)
