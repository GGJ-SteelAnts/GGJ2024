extends CharacterBody2D

class_name Player

var playerName : String = "Kocka voe"

var playerStats : PlayerStats

signal on_player_loaded


@export var speed : float = 300.0
@export var jumpVelocity : float = 540.0
@export var jumpLimit : float = 460.0

# if Needs (stat) hit critical value, the total jump strenght gets lowered by 30% with value 0.3
@export var jumpNeedsPenalty : float = 0.3		# <0, 1>

@onready var fallparticle : CPUParticles2D = $FallParticlesFX
@onready var soundPlayer : AudioStreamPlayer2D = $Sounds
@onready var musicPlayer : AudioStreamPlayer = $Music
@onready var music : AudioStream = load("res://Scenes/Sounds/GGJ2024ThemeSong.wav")

@export var catSounds : Array[AudioStreamWAV]
@export var dropSofaSounds : Array[AudioStreamWAV]
@export var dropClosetSounds : Array[AudioStreamWAV]
@export var canMove : bool = true
@export var soundTimer : float = 10
var actualSoundTimer : float = 0

var isJumping : bool = false
var isCharging : bool = false
var jumpCoeficient : float = 1
var fallDuration : float

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	musicPlayer.stream = music
	musicPlayer.play()
	
	# specific stats and their values are initialized within the PlayerStats class.
	# currently the player has Hunger, Stamina and Needs (potty potty)
	playerStats = PlayerStats.new()
	on_player_loaded.emit()

func _process(delta):
	playerStats.UpdateStats(delta)
	
	if actualSoundTimer > soundTimer:
		if catSounds.size() > 0:
			soundPlayer.stream = catSounds[randi() % catSounds.size()]
			soundPlayer.play()
			actualSoundTimer = 0

func _physics_process(delta):
	if !canMove:
		return
		
	PlayDropSound()
	
	# Add the gravity.
	fallDuration += 1
	if not is_on_floor():
		velocity.y += (gravity * delta)
	else:
		if fallDuration > 70:
			fallparticle.emitting = true
		fallDuration = 0
		isJumping = false

	# Handle jump.	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		$CatAnimator.play("charge")
		isCharging = true
		
	if Input.is_action_pressed("Jump") and is_on_floor() and isCharging and jumpCoeficient <= jumpLimit:
		jumpCoeficient += 5
		
	if Input.is_action_just_released("Jump") and isCharging:
		var _jumpStrength = jumpVelocity + jumpCoeficient
		$CatAnimator.play("jump")
		
		if playerStats.stats["Needs"].Critical():
			_jumpStrength *= 1 - jumpNeedsPenalty
		
		if $CatAnimator.flip_h:
			velocity.x = (-100 * speed * delta)
		else:
			velocity.x = (100 * speed * delta)
			
		velocity.y = -1 * (_jumpStrength)
		jumpCoeficient = 0
		isCharging = false
		isJumping = true
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Input.get_axis("Left", "Right")
	if direction:	
		jumpCoeficient = 0
		velocity.x = direction * speed
		$CatAnimator.flip_h = velocity.x < 0	
		if is_on_floor() and not isJumping:	
			$CatAnimator.play("walk")	
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, speed)
		if is_on_floor() and not isJumping and not isCharging:
			$CatAnimator.play("idle")
			
	if Input.is_action_just_pressed("Down"):
			for node in get_tree().get_nodes_in_group("Fall"):
				node.disabled = true
	
	if Input.is_action_just_released("Down"):
		for node in get_tree().get_nodes_in_group("Fall"):
			node.disabled = false
	
	move_and_slide()


func PlayDropSound():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().get_parent().is_in_group("Sofa"):
			if is_on_floor() && soundPlayer.finished && fallDuration != 0:
				if dropSofaSounds.size() > 0:
					soundPlayer.stream = dropSofaSounds[randi() % dropSofaSounds.size()]
					soundPlayer.play()
		elif collision.get_collider().get_parent().is_in_group("Closet"):
			if is_on_floor() && soundPlayer.finished && fallDuration != 0:
				if dropClosetSounds.size() > 0:	
					soundPlayer.stream = dropClosetSounds[randi() % dropClosetSounds.size()]
					soundPlayer.play()

func _on_timer_timeout():
	actualSoundTimer += 1


func _on_music_finished():
	musicPlayer.play()

func GetPlayerStats():
	return playerStats

