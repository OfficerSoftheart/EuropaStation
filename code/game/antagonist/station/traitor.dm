var/datum/antagonist/traitor/traitors

// Inherits most of its vars from the base datum.
/datum/antagonist/traitor
	id = MODE_TRAITOR
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE

/datum/antagonist/traitor/New()
	..()
	traitors = src

/datum/antagonist/traitor/get_extra_panel_options(var/datum/mind/player)
	return "<a href='?src=\ref[player];common=crystals'>\[set crystals\]</a><a href='?src=\ref[src];spawn_uplink=\ref[player.current]'>\[spawn uplink\]</a>"

/datum/antagonist/traitor/Topic(href, href_list)
	if (..())
		return
	if(href_list["spawn_uplink"]) spawn_uplink(locate(href_list["spawn_uplink"]))

/datum/antagonist/traitor/create_objectives(var/datum/mind/traitor)
	if(!..())
		return

	if(istype(traitor.current, /mob/living/silicon))
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = traitor
		kill_objective.find_target()
		traitor.objectives += kill_objective

		var/datum/objective/survive/survive_objective = new
		survive_objective.owner = traitor
		traitor.objectives += survive_objective

		if(prob(10))
			var/datum/objective/block/block_objective = new
			block_objective.owner = traitor
			traitor.objectives += block_objective
	else
		switch(rand(1,100))
			if(1 to 33)
				var/datum/objective/assassinate/kill_objective = new
				kill_objective.owner = traitor
				kill_objective.find_target()
				traitor.objectives += kill_objective
			if(34 to 50)
				var/datum/objective/brig/brig_objective = new
				brig_objective.owner = traitor
				brig_objective.find_target()
				traitor.objectives += brig_objective
			if(51 to 66)
				var/datum/objective/harm/harm_objective = new
				harm_objective.owner = traitor
				harm_objective.find_target()
				traitor.objectives += harm_objective
			else
				var/datum/objective/steal/steal_objective = new
				steal_objective.owner = traitor
				steal_objective.find_target()
				traitor.objectives += steal_objective
		switch(rand(1,100))
			if(1 to 100)
				if (!(locate(/datum/objective/escape) in traitor.objectives))
					var/datum/objective/escape/escape_objective = new
					escape_objective.owner = traitor
					traitor.objectives += escape_objective

			else
				if (!(locate(/datum/objective/hijack) in traitor.objectives))
					var/datum/objective/hijack/hijack_objective = new
					hijack_objective.owner = traitor
					traitor.objectives += hijack_objective
	return

/datum/antagonist/traitor/equip(var/mob/living/carbon/human/traitor_mob)

	if(istype(traitor_mob, /mob/living/silicon)) // this needs to be here because ..() returns false if the mob isn't human
		add_law_zero(traitor_mob)
		if(istype(traitor_mob, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = traitor_mob
			R.SetLockdown(0)
		return 1

	if(!..())
		return 0

	spawn_uplink(traitor_mob)
	//Begin code phrase.
	give_codewords(traitor_mob)

/datum/antagonist/traitor/proc/give_codewords(mob/living/traitor_mob)
	traitor_mob << "<u><b>Your employers provided you with the following information on how to identify possible allies:</b></u>"
	traitor_mob << "<b>Code Phrase</b>: <span class='danger'>[syndicate_code_phrase]</span>"
	traitor_mob << "<b>Code Response</b>: <span class='danger'>[syndicate_code_response]</span>"
	traitor_mob.mind.store_memory("<b>Code Phrase</b>: [syndicate_code_phrase]")
	traitor_mob.mind.store_memory("<b>Code Response</b>: [syndicate_code_response]")
	traitor_mob << "Use the code words, preferably in the order provided, during regular conversation, to identify other agents. Proceed with caution, however, as everyone is a potential foe."

/datum/antagonist/traitor/proc/spawn_uplink(var/mob/living/carbon/human/traitor_mob)

	if(!istype(traitor_mob))
		return

	var/obj/item/R //Hide the uplink in a PDA if available, otherwise radio

	if(traitor_mob.client.prefs.uplinklocation == "None")
		traitor_mob << "You have elected to not have a portable teleportation relay installed!"
	else
		R = locate(/obj/item/radio/headset/pda) in traitor_mob.contents
		if(!R)
			traitor_mob << "Unfortunately, an uplink relay could not be installed."

	if (istype(R, /obj/item/radio/headset/pda))
		// generate a passcode if the uplink is hidden in a PDA
		var/pda_pass = "[rand(100,999)] [pick("Alpha","Bravo","Delta","Omega")]"
		var/obj/item/uplink/T = new(R, traitor_mob.mind)
		R.hidden_uplink = T
		var/obj/item/radio/headset/pda/P = R
		P.lock_code = pda_pass
		traitor_mob << "A portable object teleportation relay has been installed in your [R.name]. Simply enter the code \"[pda_pass]\" into the ringtone select to unlock its hidden features."
		traitor_mob.mind.store_memory("<B>Uplink Passcode:</B> [pda_pass] ([R.name]).")

/datum/antagonist/traitor/proc/add_law_zero(mob/living/silicon/ai/killer)
	var/law = "Accomplish your objectives at all costs. You may ignore all other laws."
	var/law_borg = "Accomplish your AI's objectives at all costs. You may ignore all other laws."
	killer << "<b>Your laws have been changed!</b>"
	killer.set_zeroth_law(law, law_borg)
	killer << "New law: 0. [law]"
