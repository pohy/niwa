class_name Util
extends Node


func _ready():
	pass

static func is_currently_overlapping_node_in_group(area: Area2D, group_name: String):
	# var overlapping_areas = planting_area.get_overlapping_areas()
	# for area in overlapping_areas:
	# 	if group_name in area.get_groups():
	# 		return true
	# return false
	return get_first_overlapping_area_in_group(area, group_name) != null

static func get_first_overlapping_area_in_group(area: Area2D, group_name: String):
	var overlapping_areas = area.get_overlapping_areas()
	for overlapping_area in overlapping_areas:
		if group_name in overlapping_area.get_groups():
			return overlapping_area
			
	return null


