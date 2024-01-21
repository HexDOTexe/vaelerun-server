extends Node

var skill_data

func _ready():
	var skill_data_file = FileAccess.open("res://Data/SkillData.json", FileAccess.READ)
	skill_data = JSON.parse_string(skill_data_file.get_as_text())
	skill_data_file.close()
