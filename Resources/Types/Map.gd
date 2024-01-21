extends Resource
class_name Map

enum map_types {WORLD, INSTANCE}
enum instance_types {NONE, SOLO, PARTY, ALLIANCE}

@export var map_id : int
@export var map_name : String
@export var map_type : map_types
@export var instance_type : instance_types
@export var maximum_players : int
