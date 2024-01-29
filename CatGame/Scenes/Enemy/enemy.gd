extends CharacterBody2D

@export var speed = 200.0
@export var actualAnger = 0.0
@export var bookSpot : Vector2
@export var progress = 25

@onready var animator = get_node("AnimatedSprite2D")

@export var gameTime = 180.0
var actualGameTime = 0

@export var pageTime = 3.0
var actualPageTime = 0

var endScreen = preload("res://Scenes/MainMap/endScreen.tscn")

@onready var soundPlayer : AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var walkWoodSounds : Array
@export var walkKitchenSounds : Array
@export var angrySounds : Array
@export var happySounds : Array
@export var mumblingSounds : Array

@export var pages = 40
var stackPage = 0
var actualProgress = 0
var cleaning = false
var triggered = false
var revert = false
var state = "Reading"
var targets = []
var nearest : Node2D
var player : CharacterBody2D
var my_random_number
var objedno = false
var walk = true
@onready var gui = get_node("/root/Map/Dynamics/Player/Gui")
@onready var pageCounterLabel = get_node("PageCounterLabel")

func updatePageCounterLabel():
	pageCounterLabel.text = "Pages left: " + str(pages)

func _ready():
	triggered = true

func _process(delta):
	#print(actualAnger)
	updatePageCounterLabel()
	var rng = RandomNumberGenerator.new()
	if actualGameTime > gameTime:
		var end = endScreen.instantiate()
		get_tree().get_root().get_node("Map").queue_free()
		get_tree().get_root().add_child(end)
		end.scoreLabel.text = "Score: " + str(gui.Score)
		end.label.text = "You Win"
		end.SongPlay(true);
		
	if state == "Reading" && actualPageTime > pageTime && triggered:
		stackPage += 2
		pages -= 1
		if !objedno:
			objedno = true
			my_random_number = rng.randi_range(0, happySounds.size()-1)
			soundPlayer.stream = happySounds[my_random_number]
			soundPlayer.playing = true
		else:
			objedno = false
			
		if actualAnger > 0:
			actualAnger -= stackPage
		else:
			actualAnger = 0
			
		if pages <= 0:
			var end = endScreen.instantiate()
			get_tree().get_root().get_node("Map").queue_free()
			get_tree().get_root().add_child(end)
			end.scoreLabel.text = "Score: " + str(gui.Score)
			end.label.text = "You Lose"
			end.SongPlay(false);
		actualPageTime = 0

func _physics_process(delta):
	var rng = RandomNumberGenerator.new()
	targets = get_tree().get_nodes_in_group("Issues")
	for target in targets:
		if nearest == null:
			nearest = target
		elif abs(global_position.x - target.global_position.x) < abs(global_position.x - nearest.global_position.x):
			nearest = target
	
	if actualAnger >= 100:
		player = get_node("/root/Map/Dynamics/Player")
	
	if nearest != null:
		if nearest.global_position.x > global_position.x:
			animator.flip_h  = false
		else:
			animator.flip_h = true
		
		if state == "Reading":
			pageCounterLabel.visible = false
			triggered = true
			my_random_number = rng.randi_range(0, angrySounds.size()-1)
			soundPlayer.stream = angrySounds[my_random_number]
			soundPlayer.playing = true
			state = "Watching"
			
		
		if abs(global_position.x - nearest.global_position.x) <= 2 && !cleaning:
			state = "StartCleaning"
			cleaning = true
		
		if cleaning && state == "StartCleaning":
			my_random_number = rng.randi_range(0, mumblingSounds.size()-1)
			soundPlayer.stream = mumblingSounds[my_random_number]
			soundPlayer.playing = true
			actualProgress = 0
		
		if actualProgress < 100 && cleaning == true:
			actualProgress += progress * delta
		elif actualProgress >= 100 && cleaning == true:
			revert = true
			state = "StartCleaning"
			actualProgress = 0
			cleaning = false
			if nearest.itemTypeEnum != Enums.ItemTypeEnum.Laptop:
				nearest.queue_free()
			else:
				nearest.global_position = nearest.startPosition
				nearest.global_rotation = nearest.startRotation
				nearest.remove_from_group("Issues")
				nearest.breakAnimation.stop()
				nearest.breakAnimation.frame = 0
				nearest.canInteract = true
				nearest.isInteracting = false
				nearest.isFalling = false
				nearest.isGrounded = false
				nearest.fallingSpeed = randi() % 50
				nearest = null
	else:
		if bookSpot.x > global_position.x:
			animator.flip_h  = false
		else:
			animator.flip_h = true
		
		if state == "Walking" && abs(bookSpot.x - global_position.x) <= 2:
			pageCounterLabel.visible = true
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
	var rng = RandomNumberGenerator.new()
	if state == "Reading":
		global_position.x = move_toward(global_position.x, bookSpot.x, speed * delta)
	elif state == "Walking" && nearest != null && abs(global_position.x - nearest.global_position.x) > 2:
		global_position.x = move_toward(global_position.x, nearest.global_position.x, speed * delta)
	elif state == "Walking" && abs(bookSpot.x - global_position.x) > 2:
		global_position.x = move_toward(global_position.x, bookSpot.x, speed * delta)
		
	if state == "Walking" && walk:
		walk = false
		if get_node("/root/Map/Dynamics/Player").global_position.x <= 240 * 8:
			my_random_number = rng.randi_range(0, walkWoodSounds.size()-1)
			soundPlayer.stream = walkWoodSounds[my_random_number]
			soundPlayer.playing = true
		else:
			my_random_number = rng.randi_range(0, walkKitchenSounds.size()-1)
			soundPlayer.stream = walkKitchenSounds[my_random_number]
			soundPlayer.playing = true
	
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
	gui.PissMeter = actualAnger
	print(gui.PissMeter)


func _on_timer_timeout():
	if triggered:
		actualGameTime += 1
		actualPageTime += 1


func _on_audio_stream_player_2d_finished():
	walk = true
