tool
class_name PlayerItem
extends Node

enum Type {
	Hoe,
	FlowerBox
	WateringPot,
}

export var texture: Texture
export(Type) var type
export var infinite_charges: bool = false
export var max_charges: int = 4

onready var sprite := $Sprite as Sprite
onready var charge_label := $ChargeLabel as RichTextLabel

onready var current_charges: int = max_charges

func _ready():
	sprite.texture = texture
	if infinite_charges:
		charge_label.visible = false

	update_charge_label()

func can_be_used():
	return infinite_charges or current_charges > 0

func use():
	if not can_be_used():
		return
	current_charges -= 1
	update_charge_label()

func restore(charges: int = max_charges):
	current_charges = int(min(max_charges, current_charges + charges))
	print_debug("Restoring charges by: %s -> %s" % [charges, current_charges])
	update_charge_label()

func update_charge_label():
	charge_label.text = String(current_charges)
