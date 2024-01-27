extends CharacterBody2D

@export var speed = 100.0
@export var anger = 100.0
@export var bookSpot : Vector2

@onready var animator = get_node("AnimatedSprite2D")

var triggered = false
var state = "Reading"
var actualAnger : float
var targets = []
var nearest : Node2D

func _ready():
	actualAnger = 0

func _physics_process(delta):
	targets = get_tree().get_nodes_in_group("Issues")
	for target in targets:
		if nearest == null:
			nearest = target
		elif global_position.distance_to(target.global_position) < global_position.distance_to(nearest.global_position):
			nearest = target
	
	if nearest != null:
		if nearest.global_position.x > global_position.x:
			animator.flip_h  = false
		else:
			animator.flip_h = true
		
		if state == "Reading":
			state = "Watching"
	
	move(delta)
	animation()

func animation():
	animator.play(state)

func move(_delta):
	if state == "Reading":
		velocity.x = move_toward(velocity.x, 0, speed)
	elif state == "Walking" && bookSpot != global_position:
		velocity.x = move_toward(global_position.x, bookSpot.x, speed)
	
	move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	if nearest != null:
		if state == "Watching":
			state = "StartWalking"
		elif state == "StartWalking":
			state = "Walking"
	else:
		if state == "Walking" && bookSpot == global_position:
			state = "Reading"
