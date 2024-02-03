extends CharacterBody2D

# - - - Modificable parameters - - -
@export var speed = 200.0
@export var actualAnger = 0.0
@export var progress = 25

@export var gameTime = 180.0
var actualGameTime = 0

@export var pageTime = 3.0
var actualPageTime = 0

@export var bookSpot : Vector2

# - - - Game connectors - - -
@onready var animator = get_node("AnimatedSprite2D")
var endScreen = preload("res://Scenes/MainMap/endScreen.tscn")
@onready var soundPlayer : AudioStreamPlayer2D = $AudioStreamPlayer2D



# - - - Audio - - -
@export var walkWoodSounds : Array
@export var walkKitchenSounds : Array
@export var angrySounds : Array
@export var happySounds : Array
@export var mumblingSounds : Array

@export var pages = 21
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


var anger : Stat
var reading : Stat
var enemyState : EnemyStates

enum EnemyStates {
	READING,
	WALKING,
	CLEANING,
	WATCHING,
	IDLE,
	OTHER
}



# - - - - - - - Methods - - - - - - - -


func UpdateStats(delta):
	anger.Update(delta)
	reading.Update(delta)
	#print("Anger: %.2f" % anger.Value())

func UpdateGUI():
	gui.PissMeter = anger.Value()
	pageCounterLabel.text = "Pages left: %d" % reading.Value()

func _ready():
	enemyState = EnemyStates.OTHER
	triggered = true
	#Stat.new(name, max, updateAmount, value = max, min = 0, mods = [], mults = [])
	anger = Stat.new("Anger", 100, -1, 0, 0)
	reading = Stat.new("Reading", pages, -0.5, pages, 0)

func _process(delta):
	CheckGameOverConditions()
	
	if state == "Reading" or enemyState == EnemyStates.READING:
		UpdateStats(delta)
		print("Reading...")
	
	UpdateGUI()
	
	# IDK co je tohle
	if state == "Reading" && actualPageTime > pageTime && triggered:
		if !objedno:
			objedno = true
			var rng = RandomNumberGenerator.new()
			my_random_number = rng.randi_range(0, happySounds.size()-1)
			soundPlayer.stream = happySounds[my_random_number]
			soundPlayer.playing = true
		actualPageTime = 0

func _physics_process(delta):
	var rng = RandomNumberGenerator.new()
	targets = get_tree().get_nodes_in_group("Issues")
	for target in targets:
		if nearest == null:
			nearest = target
		elif abs(global_position.x - target.global_position.x) < abs(global_position.x - nearest.global_position.x):
			nearest = target
	
	if anger.Value() >= 100:
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
			#enemyState = EnemyStates.WATCHING
			
		
		if abs(global_position.x - nearest.global_position.x) <= 2 && !cleaning:
			state = "StartCleaning"
			#enemyState = EnemyStates.CLEANING
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
			enemyState = EnemyStates.CLEANING
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
			#enemyState = EnemyStates.READING
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
			#enemyState = EnemyStates.WALKING
		elif state == "StartWalking":
			state = "Walking"
		elif !revert && state == "StartCleaning":
			state = "Cleaning"
			#enemyState = EnemyStates.CLEANING
	if revert && state == "StartCleaning":
		state = "Walking"
		#enemyState = EnemyStates.WALKING
		revert = false

func makeHimAngry(angerDamage):
	if !triggered:
		triggered = true
	anger.Add(angerDamage) 
	
	#print(gui.PissMeter)

func CheckGameOverConditions():
	if actualGameTime > gameTime:
		GameOverWin()
	if reading.Value() <= reading.minValue:			# going updating max --> min
		GameOverLose()

func GameOverWin():
	var end = endScreen.instantiate()
	get_tree().get_root().get_node("Map").queue_free()
	get_tree().get_root().add_child(end)
	end.scoreLabel.text = "Score: " + str(gui.Score)
	end.label.text = "You Win"
	end.SongPlay(true);

func GameOverLose():
	var end = endScreen.instantiate()
	get_tree().get_root().get_node("Map").queue_free()
	get_tree().get_root().add_child(end)
	end.scoreLabel.text = "Score: " + str(gui.Score)
	end.label.text = "You Lose"
	end.SongPlay(false);

func _on_timer_timeout():
	if triggered:
		actualGameTime += 1
		actualPageTime += 1


func _on_audio_stream_player_2d_finished():
	walk = true
