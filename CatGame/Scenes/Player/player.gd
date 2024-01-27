extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = 400.0

var isJumping = false
var isCharging = false
var jumpCoeficient = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += (gravity * delta)
	else:
		isJumping = false

	# Handle jump.	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		$AnimatedSprite2D.play("charge")		
		isCharging = true
		
	if Input.is_action_pressed("Jump") and is_on_floor() and isCharging:
		jumpCoeficient = (jumpCoeficient + 2)
		print(jumpCoeficient)
		
	if Input.is_action_just_released("Jump") and isCharging:
		$AnimatedSprite2D.play("jump")	
		
		if $AnimatedSprite2D.flip_h:
			velocity.x = (-3 * SPEED)	
		else:
			velocity.x = (3 * SPEED)	
			
		velocity.y = -(JUMP_VELOCITY + jumpCoeficient)
		jumpCoeficient = 0
		isCharging = false
		isJumping = true
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = velocity.x < 0	
		if is_on_floor() and not isJumping:	
			$AnimatedSprite2D.play("walk")	
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and not isJumping and not isCharging:
			$AnimatedSprite2D.play("idle")
		
	move_and_slide()
	
	
