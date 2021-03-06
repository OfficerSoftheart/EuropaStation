/obj/item/gun/composite/premade/rifle
	name = "hunting rifle"
	icon_state = "ballistic_rifle"
	variant_chamber = /obj/item/gun_component/chamber/ballistic/breech
	variant_stock =   /obj/item/gun_component/stock/rifle
	variant_grip =    /obj/item/gun_component/grip/rifle
	variant_body =    /obj/item/gun_component/body/rifle
	variant_barrel =  /obj/item/gun_component/barrel/rifle

/obj/item/gun/composite/premade/rifle/preloaded
	ammo_type = /obj/item/ammo_casing/rifle_small

/obj/item/gun/composite/premade/rifle/large
	name = "7.62 rifle"
	variant_barrel = /obj/item/gun_component/barrel/rifle/large

/obj/item/gun/composite/premade/rifle/sawnoff
	name = "sawn-off rifle"
	variant_barrel = /obj/item/gun_component/barrel/rifle/short
	variant_stock =  null

/obj/item/gun/composite/premade/rifle/sawnoff/large
	variant_barrel = /obj/item/gun_component/barrel/rifle/short/large

/obj/item/gun/composite/premade/rifle/antimaterial
	name = "anti-materiel rifle"
	variant_barrel = /obj/item/gun_component/barrel/rifle/am
	variant_body =   /obj/item/gun_component/body/rifle/black
	variant_chamber = /obj/item/gun_component/chamber/ballistic/breech/am
	variant_stock =   /obj/item/gun_component/stock/rifle/am
	variant_grip =    /obj/item/gun_component/grip/rifle/am

/obj/item/gun/composite/premade/rifle/antimaterial/New()
	new /obj/item/gun_component/accessory/body/scope(src)
	..()