extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = 540.0
@export var JUMP_LIMIT = 500.0

@onready var fallparticle : CPUParticles2D = $CPUParticles2D
@onready var soundPlayer : AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var catSounds : Dictionary
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
	pass

func _process(delta):
	if global_position.y < 0:
		indicator.visible = true
	else:
		indicator.visible = false
		
	if actualSoundTimer > soundTimer:
		var rng = RandomNumberGenerator.new()
		var my_random_number = rng.randi_range(0, catSounds.size()-1)
		soundPlayer.stream = catSounds[my_random_number]
		soundPlayer.playing = true
		actualSoundTimer = 0
		
	$Sprite2D.global_position = Vector2(global_position.x, $Sprite2D.texture.get_height())

func _physics_process(delta):
	if !canMove:
		return
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
		$AnimatedSprite2D.play("charge")
		isCharging = true
		
	if Input.is_action_pressed("Jump") and is_on_floor() and isCharging and jumpCoeficient <= JUMP_LIMIT:
		jumpCoeficient = (jumpCoeficient + 2)
		print(jumpCoeficient)
		
	if Input.is_action_just_released("Jump") and isCharging:
		$AnimatedSprite2D.play("jump")	
		
		if $AnimatedSprite2D.flip_h:
			velocity.x = (-100 * SPEED * delta)	
		else:
			velocity.x = (100 * SPEED * delta)	
			
		velocity.y = -(JUMP_VELOCITY + jumpCoeficient)
		jumpCoeficient = 0
		isCharging = false
		isJumping = true
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Input.get_axis("Left", "Right")
	if direction:	
		jumpCoeficient = 0
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = velocity.x < 0	
		if is_on_floor() and not isJumping:	
			$AnimatedSprite2D.play("walk")	
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
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
