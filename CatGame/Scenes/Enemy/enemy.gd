extends CharacterBody2D

@export var speed = 200.0
@export var anger = 100.0
@export var bookSpot : Vector2
@export var progress = 100

@onready var animator = get_node("AnimatedSprite2D")

@export var gameTime = 180.0
var actualGameTime = 0

@export var pageTime = 3.0
var actualPageTime = 0

var endScreen = preload("res://Scenes/MainMap/endScreen.tscn")

@export var pages = 40
var stackPage = 0
var actualProgress = 0
var cleaning = false
var triggered = false
var revert = false
var state = "Reading"
var actualAnger : float
var targets = []
var nearest : Node2D

func _ready():
	actualAnger = 0

func _process(delta):
	if actualGameTime > gameTime:
		var end = endScreen.instantiate()
		get_tree().get_root().get_node("Map").queue_free()
		get_tree().get_root().add_child(end)
		end.label.text = "You Win"
	
	if state == "Reading" && actualPageTime > pageTime && triggered:
		stackPage += 1
		pages -= 1
		if actualAnger > 0:
			actualAnger -= stackPage
		else:
			actualAnger = 0
		if pages <= 0:
			var end = endScreen.instantiate()
			get_tree().get_root().get_node("Map").queue_free()
			get_tree().get_root().add_child(end)
			end.label.text = "You Lose"
		actualPageTime = 0

func _physics_process(delta):
	targets = get_tree().get_nodes_in_group("Issues")
	for target in targets:
		if nearest == null:
			nearest = target
		elif abs(global_position.x - target.global_position.x) < abs(global_position.x - nearest.global_position.x):
			nearest = target
	
	if nearest != null:
		if nearest.global_position.x > global_position.x:
			animator.flip_h  = false
		else:
			animator.flip_h = true
		
		if state == "Reading":
			state = "Watching"
		
		if abs(global_position.x - nearest.global_position.x) <= 2 && !cleaning:
			state = "StartCleaning"
			actualProgress = 0
			cleaning = true
		
		if actualProgress < 100 && cleaning == true:
			actualProgress += 10 * delta
		elif actualProgress >= 100 && cleaning == true:
			revert = true
			state = "StartCleaning"
			actualProgress = 0
			cleaning = false
			nearest.queue_free()
	else:
		if bookSpot.x > global_position.x:
			animator.flip_h  = false
		else:
			animator.flip_h = true
		
		if state == "Walking" && abs(bookSpot.x - global_position.x) <= 2:
			state = "Reading"
			actualPageTime = 0
	
	move(delta)
	animation()

func animation():
	if !revert:
		animator.play(state)
	else:
		animator.play_backwards(state)

func move(delta):
	if state == "Reading":
		global_position.x = move_toward(global_position.x, bookSpot.x, speed * delta)
	elif state == "Walking" && nearest != null && abs(global_position.x - nearest.global_position.x) > 2:
		global_position.x = move_toward(global_position.x, nearest.global_position.x, speed * delta)
	elif state == "Walking" && abs(bookSpot.x - global_position.x) > 2:
		global_position.x = move_toward(global_position.x, bookSpot.x, speed * delta)
	
	move_and_slide()

func _on_animated_sprite_2d_animation_finished():
	if nearest != null:
		if state == "Watching":
			state = "StartWalking"
		elif state == "StartWalking":
			state = "Walking"
		elif !revert && state == "StartCleaning":
			state = "Cleaning"
	if revert && state == "StartCleaning":
		state = "Walking"
		revert = false

func makeHimAngry(angerDamage):
	if !triggered:
		triggered = true
	actualAnger += angerDamage


func _on_timer_timeout():
	actualGameTime += 1
	actualPageTime += 1
