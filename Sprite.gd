extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed: float = 20

onready var timer := $Timer as Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		
	position += velocity * delta


func _on_Timer_timeout():
	print_debug("waddup %s, %s" % [1, 2])
