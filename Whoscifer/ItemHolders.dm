/datum/component/holderloving/whoscifer/one
	can_transfer = FALSE
/datum/component/holderloving/whoscifer/one/check_valid_loc(atom/location)
	return location == holder

/datum/component/holderloving/whoscifer/two
	var/mob/living/simple_animal/drone/user
/datum/component/holderloving/whoscifer/two/Initialize(holder, del_parent_with_holder, player)
	. = ..(holder, del_parent_with_holder)
	user = player
/datum/component/holderloving/whoscifer/two/check_valid_loc(atom/location)
	return location == holder || location.loc == user.loc


/datum/component/holderloving/whoscifer/respawn
/datum/component/holderloving/whoscifer/respawn/check_valid_loc(atom/location)
	if (location != holder)
		src.UnregisterFromParent()
		addtimer(CALLBACK(src, PROC_REF(regen_mat)), 1 SECONDS)
	return TRUE
/datum/component/holderloving/whoscifer/respawn/proc/regen_mat()
	var/list/stack_list = holder.get_all_contents_type(parent.type)
	if (length(stack_list) == 0)
		var/obj/item/stack/sheet/sheet_clone = new parent.type(holder)
		sheet_clone.add(50)
		sheet_clone.AddComponent(/datum/component/holderloving/whoscifer/respawn, holder, TRUE)
	else
		var/obj/item/stack/sheet/found_stack = stack_list[1]
		found_stack.add(found_stack.max_amount - found_stack.amount)
