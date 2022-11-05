tool
class_name PlayerItem
extends Node

enum PlayerItemType {
	Hoe,
	FlowerBox
	WateringPot,
}

export var texture: Texture
export(PlayerItemType) var type

onready var sprite := $Sprite as Sprite

func _ready():
	sprite.texture = texture
