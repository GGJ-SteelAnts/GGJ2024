extends Node2D

enum ObjectsTypes {Eat, EatAndDrop, EatGood, Drop, Nothing = -1}
@export var type = ObjectsTypes.Nothing
@export var interactable = false
@export var canInteract = true

@export var angerDamage = 15

@export var spriteNormal : Texture
@export var spriteAction : Texture

@export var particles : GPUParticles2D
@export var respawner : float = 10.0
var actualRespawner : float = 0.0

@onready var label = get_node("Label")
@onready var sprite = get_node("Sprite2D")
@onready var enemy = get_tree().get_first_node_in_group("Enemy")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var onGround = true
var num = 0

func _process(delta):
	actualRespawner += delta
	if type == ObjectsTypes.EatGood:
		if spriteAction != null:
			if actualRespawner > respawner && !canInteract:
				canInteract = true
				sprite.texture = spriteNormal
				actualRespawner = 0
			elif actualRespawner > respawner && canInteract:
				canInteract = false
				sprite.texture = spriteAction
				actualRespawner = 0
		
	if interactable && Input.is_action_just_released("Interact") && canInteract:
		Interaction(delta)
		
		
	if !onGround:
		position = position.move_toward(Vector2(position.x,602), delta * (100 + num))
		num += 10
	
	if position == Vector2(position.x,602) && !canInteract:
		add_to_group("Issues")
		enemy.makeHimAngry(angerDamage)

func _on_area_2d_body_entered(body):
	if body.name == "Player" && canInteract:
		label.visible = true
		interactable = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		label.visible = false
		interactable = false

func Interaction(delta):
	if type == ObjectsTypes.Eat:
		if spriteAction != null:
			sprite.texture = spriteAction
			canInteract = false
			add_to_group("Issues")
			enemy.makeHimAngry(angerDamage)
			interactable = false
			label.visible = false
	elif type == ObjectsTypes.EatAndDrop:
		if spriteAction != null:
			sprite.texture = spriteAction
			enemy.makeHimAngry(angerDamage)
			type = ObjectsTypes.Drop
	elif type == ObjectsTypes.EatGood:
		if spriteAction != null:
			sprite.texture = spriteAction
			canInteract = false
			enemy.makeHimAngry(angerDamage)
			actualRespawner = 0
			interactable = false
			label.visible = false
	elif type == ObjectsTypes.Drop:
		onGround = false
		canInteract = false
		num = 0
		interactable = false
		label.visible = false
