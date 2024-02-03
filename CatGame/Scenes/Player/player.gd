extends CharacterBody2D

class_name Player

var playerName = "Kocka voe"

var playerStats : PlayerStats

signal on_player_loaded


@export var speed = 300.0
@export var jumpVelocity = 540.0
@export var jumpLimit = 500.0

@onready var fallparticle : CPUParticles2D = $CPUParticles2D
@onready var soundPlayer : AudioStreamPlayer2D = $Sounds

@onready var musicPlayer : AudioStreamPlayer = $Music
@onready var music : AudioStream = load("res://Scenes/Sounds/GGJ2024ThemeSong.wav")

@export var catSounds : Array[AudioStreamWAV]
@export var dropSofaSounds : Array[AudioStreamWAV]
@export var dropClosetSounds : Array[AudioStreamWAV]
@export var canMove = true
@export var soundTimer = 10
var actualSoundTimer = 0

var isJumping = false
var isCharging = false
var jumpCoeficient = 0
var fallDuration : int

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var indicator = get_node("Sprite2D") 


func _ready():
	musicPlayer.stream = music
	musicPlayer.play()
	
	# specific stats and their values are initialized within the PlayerStats class.
	# currently the player has Hunger, Stamina and Needs (potty potty)
	playerStats = PlayerStats.new()
	on_player_loaded.emit()

func _process(delta):
	playerStats.UpdateStats(delta)
	if global_position.y < 0:
		indicator.visible = true
	else:
		indicator.visible = false
	if actualSoundTimer > soundTimer:
		if catSounds.size() > 0:
			var rng = RandomNumberGenerator.new()
			var my_random_number = rng.randi_range(0, catSounds.size()-1)
			soundPlayer.stream = catSounds[my_random_number]
			soundPlayer.play()
			actualSoundTimer = 0
		
	$Sprite2D.global_position = Vector2(global_position.x, $Sprite2D.texture.get_height())

func _physics_process(delta):
	if !canMove:
		return
		
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().get_parent().is_in_group("Sofa"):
			if is_on_floor() && soundPlayer.finished && fallDuration != 0:
				if dropSofaSounds.size() > 0:
					var rng = RandomNumberGenerator.new()
					var my_random_number = rng.randi_range(0, dropSofaSounds.size()-1)
					soundPlayer.stream = dropSofaSounds[my_random_number]
					soundPlayer.play()
		elif collision.get_collider().get_parent().is_in_group("Closet"):
			if is_on_floor() && soundPlayer.finished && fallDuration != 0:
				if dropClosetSounds.size() > 0:				
					var rng = RandomNumberGenerator.new()
					var my_random_number = rng.randi_range(0, dropClosetSounds.size()-1)
					soundPlayer.stream = dropClosetSounds[my_random_number]
					soundPlayer.play()
	
	# Add the gravity.
	fallDuration += 1
	if not is_on_floor():
		velocity.y += (gravity * delta)
	else:
		if fallDuration > 70:
			fallparticle.emitting = true
		fallDuration = 0
		#if isJumping:
			#var rng = RandomNumberGenerator.new()
			#var my_random_number = rng.randi_range(0, dropSofaSounds.size()-1)
			#soundPlayer.stream = dropSofaSounds[my_random_number]
			#soundPlayer.playing = true
		isJumping = false

	# Handle jump.	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		$AnimatedSprite2D.play("charge")
		isCharging = true
		
	if Input.is_action_pressed("Jump") and is_on_floor() and isCharging and jumpCoeficient <= jumpLimit:
		jumpCoeficient = (jumpCoeficient + 2)
		
	if Input.is_action_just_released("Jump") and isCharging:
		$AnimatedSprite2D.play("jump")	
		
		if $AnimatedSprite2D.flip_h:
			velocity.x = (-100 * speed * delta)	
		else:
			velocity.x = (100 * speed * delta)	
			
		velocity.y = -(jumpVelocity + jumpCoeficient)
		jumpCoeficient = 0
		isCharging = false
		isJumping = true
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Input.get_axis("Left", "Right")
	if direction:	
		jumpCoeficient = 0
		velocity.x = direction * speed
		$AnimatedSprite2D.flip_h = velocity.x < 0	
		if is_on_floor() and not isJumping:	
			$AnimatedSprite2D.play("walk")	
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, speed)
		if is_on_floor() and not isJumping and not isCharging:
			$AnimatedSprite2D.play("idle")
			
	if Input.is_action_just_pressed("Down"):
			for node in get_tree().get_nodes_in_group("Fall"):
				node.disabled = true
	
	if Input.is_action_just_released("Down"):
		for node in get_tree().get_nodes_in_group("Fall"):
			node.disabled = false
	
	move_and_slide()


func _on_timer_timeout():
	actualSoundTimer += 1


func _on_music_finished():
	musicPlayer.play()

func GetPlayerStats():
	return playerStats

