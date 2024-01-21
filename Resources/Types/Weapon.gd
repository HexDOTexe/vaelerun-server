extends Resource
class_name Weapon

enum damage_schools {PHYSICAL, FIRE, ICE, LIGHTNING, ARCANE, RADIANT, VOID, CHAOTIC}
enum weapon_types {HAND, DAGGER, SWORD, AXE, HAMMER, SHIELD, SCEPTRE, GREATSWORD, GREATAXE, GREATHAMMER, POLEARM, SCYTHE, STAFF, BOW, CROSSBOW, GUN, THROWING}


@export var weapon_name : String
@export var weapon_type : weapon_types
@export_flags("One Hand", "Main Hand", "Off Hand", "Ranged") var wield_options

@export var primary_damage_school : damage_schools
@export var primary_damage_min : int
@export var primary_damage_max : int
@export var secondary_damage_school : damage_schools
@export var secondary_damage_min : int
@export var secondary_damage_max : int

