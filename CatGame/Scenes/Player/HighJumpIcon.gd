extends Sprite2D

@onready var player = get_parent()
@onready var pos_y = texture.get_height()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if player.global_position.y < 0:
		visible = true
	else:
		visible = false
	global_position = Vector2(player.global_position.x, pos_y)
