/datum/reagent/acetone
	name = "Acetone"
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#808080"
	metabolism = REM * 0.2

/datum/reagent/acetone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(removed * 3)

/datum/reagent/acetone/touch_obj(var/obj/O)	//I copied this wholesale from ethanol and could likely be converted into a shared proc. ~Techhead
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		usr << "The solution dissolves the ink on the paper."
		return
	if(istype(O, /obj/item/book))
		if(volume < 5)
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat = null
		usr << "<span class='notice'>The solution dissolves the ink on the book.</span>"
	return

/datum/reagent/aluminium
	name = "Aluminium"
	taste_description = "metal"
	taste_mult = 1.1
	reagent_state = SOLID
	color = "#A8A8A8"

/datum/reagent/ammonia
	name = "Ammonia"
	taste_description = "mordant"
	taste_mult = 2
	reagent_state = LIQUID
	color = "#404030"
	metabolism = REM * 0.5

/datum/reagent/ammonia/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(removed * 1.5)

/datum/reagent/carbon
	name = "Carbon"
	taste_description = "sour chalk"
	taste_mult = 1.5
	reagent_state = SOLID
	color = "#1C1300"
	ingest_met = REM * 5

/datum/reagent/carbon/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	var/datum/reagents/R = M.get_ingested_reagents()
	if(istype(R) && R.reagent_list.len > 1) // Need to have at least 2 reagents - cabon and something to remove
		var/effect = 1 / (R.reagent_list.len - 1)
		for(var/datum/reagent/react in R.reagent_list)
			if(react == src)
				continue
			R.remove_reagent(react.type, removed * effect)

/datum/reagent/carbon/touch_turf(var/turf/T)
	if(!istype(T, /turf/space) && !T.open_space)
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + volume * 30, 255)

/datum/reagent/copper
	name = "Copper"
	taste_description = "copper"
	color = "#6E3B08"

/datum/reagent/ethanol
	name = "Ethanol" //Parent class for all alcoholic reagents.
	taste_description = "pure alcohol"
	reagent_state = LIQUID
	color = "#404030"
	touch_met = 5
	disinfectant = TRUE

	var/nutriment_factor = 0
	var/strength = 10 // This is, essentially, units between stages - the lower, the stronger. Less fine tuning, more clarity.
	var/toxicity = 1

	var/druggy = 0
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0

	glass_name = "ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."

/datum/reagent/ethanol/touch_mob(var/mob/living/L, var/amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 15)

/datum/reagent/ethanol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(removed * 2 * toxicity)
	return

/datum/reagent/ethanol/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	M.nutrition += nutriment_factor * removed
	var/strength_mod = 1
	M.add_chemical_effect(CE_ALCOHOL, 1)

	if(dose * strength_mod >= strength) // Early warning
		M.make_dizzy(6) // It is decreased at the speed of 3 per tick
	if(dose * strength_mod >= strength * 2) // Slurring
		M.slurring = max(M.slurring, 30)
	if(dose * strength_mod >= strength * 3) // Confusion - walking in random directions
		M.confused = max(M.confused, 20)
	if(dose * strength_mod >= strength * 4) // Blurry vision
		M.eye_blurry = max(M.eye_blurry, 10)
	if(dose * strength_mod >= strength * 5) // Drowsyness - periodically falling asleep
		M.drowsyness = max(M.drowsyness, 20)
	if(dose * strength_mod >= strength * 6) // Toxic dose
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, toxicity)
	if(dose * strength_mod >= strength * 7) // Pass out
		M.paralysis = max(M.paralysis, 20)
		M.sleeping  = max(M.sleeping, 30)

	if(druggy != 0)
		M.druggy = max(M.druggy, druggy)

	if(adj_temp > 0 && M.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > targ_temp)
		M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(halluci)
		M.hallucination = max(M.hallucination, halluci)

/datum/reagent/ethanol/touch_obj(var/obj/O)
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		usr << "The solution dissolves the ink on the paper."
		return
	if(istype(O, /obj/item/book))
		if(volume < 5)
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat = null
		usr << "<span class='notice'>The solution dissolves the ink on the book.</span>"
	return

/datum/reagent/hydrazine
	name = "Hydrazine"
	taste_description = "sweet tasting metal"
	reagent_state = LIQUID
	color = "#808080"
	metabolism = REM * 0.2
	touch_met = 5

/datum/reagent/hydrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(4 * removed)

/datum/reagent/hydrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed) // Hydrazine is both toxic and flammable.
	M.adjust_fire_stacks(removed / 12)
	M.adjustToxLoss(0.2 * removed)

/datum/reagent/hydrazine/touch_turf(var/turf/T)
	new /obj/effect/decal/cleanable/liquid_fuel(T, volume)
	remove_self(volume)
	return

/datum/reagent/iron
	name = "Iron"
	taste_description = "metal"
	reagent_state = SOLID
	color = "#353535"

/datum/reagent/iron/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_BLOODRESTORE, 8 * removed)

/datum/reagent/lithium
	name = "Lithium"
	taste_description = "metal"
	reagent_state = SOLID
	color = "#808080"

/datum/reagent/lithium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
		step(M, pick(cardinal))
	if(prob(5))
		M.emote(pick("twitch", "drool", "moan"))

/datum/reagent/mercury
	name = "Mercury"
	taste_mult = 0 //mercury apparently is tasteless. IDK
	reagent_state = LIQUID
	color = "#484848"

/datum/reagent/mercury/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
		step(M, pick(cardinal))
	if(prob(5))
		M.emote(pick("twitch", "drool", "moan"))
	M.adjustBrainLoss(0.1)

/datum/reagent/phosphorus
	name = "Phosphorus"
	taste_description = "vinegar"
	reagent_state = SOLID
	color = "#832828"

/datum/reagent/potassium
	name = "Potassium"
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	reagent_state = SOLID
	color = "#A0A0A0"

/datum/reagent/radium
	name = "Radium"
	taste_description = "the color blue, and regret"
	reagent_state = SOLID
	color = "#C7C7C7"

/datum/reagent/radium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.apply_effect(10 * removed, IRRADIATE, blocked = 0) // Radium may increase your chances to cure a disease
	if(M.virus2.len)
		for(var/ID in M.virus2)
			var/datum/disease2/disease/V = M.virus2[ID]
			if(prob(5))
				M.antibodies |= V.antigen
				if(prob(50))
					M.apply_effect(50, IRRADIATE, blocked = 0) // curing it that way may kill you instead
					M.adjustToxLoss(100)

/datum/reagent/radium/touch_turf(var/turf/T)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return

/datum/reagent/acid
	name = "Sulphuric acid"
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#DB5008"
	metabolism = REM * 2
	touch_met = 50 // It's acid!
	disinfectant = TRUE

	var/power = 5
	var/meltdose = 10 // How much is needed to melt

/datum/reagent/acid/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.take_organ_damage(0, removed * power * 2)

/datum/reagent/acid/affect_touch(var/mob/living/carbon/M, var/alien, var/removed) // This is the most interesting
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.unacidable)
				H << "<span class='danger'>Your [H.head] protects you from the acid.</span>"
				remove_self(volume)
				return
			else if(removed > meltdose)
				H << "<span class='danger'>Your [H.head] melts away!</span>"
				qdel(H.head)
				H.update_inv_head(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.wear_mask)
			if(H.wear_mask.unacidable)
				H << "<span class='danger'>Your [H.wear_mask] protects you from the acid.</span>"
				remove_self(volume)
				return
			else if(removed > meltdose)
				H << "<span class='danger'>Your [H.wear_mask] melts away!</span>"
				qdel(H.wear_mask)
				H.update_inv_wear_mask(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.glasses)
			if(H.glasses.unacidable)
				H << "<span class='danger'>Your [H.glasses] partially protect you from the acid!</span>"
				removed /= 2
			else if(removed > meltdose)
				H << "<span class='danger'>Your [H.glasses] melt away!</span>"
				qdel(H.glasses)
				H.update_inv_glasses(1)
				removed -= meltdose / 2
		if(removed <= 0)
			return

	if(M.unacidable)
		return

	if(volume < meltdose) // Not enough to melt anything
		M.take_organ_damage(0, removed * power * 0.1) //burn damage, since it causes chemical burns. Acid doesn't make bones shatter, like brute trauma would.
	else
		M.take_organ_damage(0, removed * power * 0.2)
		if(removed && ishuman(M) && prob(100 * removed / meltdose)) // Applies disfigurement
			var/mob/living/carbon/human/H = M
			var/screamed
			for(var/obj/item/organ/external/affecting in H.organs)
				if(!screamed && affecting.can_feel_pain())
					screamed = 1
					H.emote("scream")
				affecting.disfigured = 1

/datum/reagent/acid/touch_obj(var/obj/O)
	if(O.unacidable)
		return
	if((istype(O, /obj/item) || istype(O, /obj/effect/plant)) && (volume > meltdose))
		var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(O.loc)
		I.desc = "Looks like this was \an [O] some time ago."
		for(var/mob/M in viewers(5, O))
			M << "<span class='warning'>\The [O] melts.</span>"
		qdel(O)
		remove_self(meltdose) // 10 units of acid will not melt EVERYTHING on the tile

/datum/reagent/acid/hydrochloric //Like sulfuric, but less toxic and more acidic.
	name = "Hydrochloric Acid"
	taste_description = "stomach acid"
	reagent_state = LIQUID
	color = "#808080"
	power = 3
	meltdose = 8

/datum/reagent/silicon
	name = "Silicon"
	reagent_state = SOLID
	color = "#A8A8A8"

/datum/reagent/sodium
	name = "Sodium"
	taste_description = "salty metal"
	reagent_state = SOLID
	color = "#808080"

/datum/reagent/sugar
	name = "Sugar"
	taste_description = "sugar"
	taste_mult = 1.8
	reagent_state = SOLID
	color = "#FFFFFF"

	glass_name = "sugar"
	glass_desc = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	glass_icon = DRINK_ICON_NOISY

/datum/reagent/sugar/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.nutrition += removed * 3

/datum/reagent/sulfur
	name = "Sulfur"
	taste_description = "old eggs"
	reagent_state = SOLID
	color = "#BF8C00"

/datum/reagent/tungsten
	name = "Tungsten"
	taste_mult = 0 //no taste
	reagent_state = SOLID
	color = "#DCDCDC"
