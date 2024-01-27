extends CharacterBody2D

@export var speed = 100.0
@export var anger = 200.0

@onready var animator = get_node("AnimatedSprite2D")

var state = "Idle"
var actualAnger : float
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	actualAnger = anger

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += (gravity * delta)
	
	move(delta)
	animation()

func animation():
	animator.play(state)

func move(delta):
	velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
