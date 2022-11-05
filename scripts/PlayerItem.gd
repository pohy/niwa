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

onready var sprite := $Sprite as Sprite

func _ready():
	sprite.texture = texture

