/obj/item/slimecross/recurring/rainbow/eternal
	name = "Eternal Slime Core"
	desc = "A dazzlingly bright core wrapped in several layers of slime. Hey, why does it have teeth?!?!"
	icon_state = "consuming"
/obj/item/slimecross/recurring/rainbow/eternal/process(delta_time)
	name = "Eternal Slime Core"
	if(cooldown > 0)
		cooldown -= delta_time
	else
		extract.Uses = 1000000
		cooldown = max_cooldown
/obj/item/slimecross/recurring/rainbow/eternal/Initialize(mapload)
	. = ..()
	name = "Eternal Slime Core"

/obj/item/slimecross/industrial/rainbow/prismatic
	name = "Prismatic Slime Core"
	desc = "A pulsating core shining with all the colors of slimes."
	icon_state = "stabilized"
	itemamount = 10
	plasmarequired = 1
/obj/item/slimecross/industrial/rainbow/prismatic/Initialize(mapload)
	. = ..()
	name = "Prismatic Slime Core"
