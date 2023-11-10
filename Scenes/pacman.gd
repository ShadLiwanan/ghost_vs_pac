extends CharacterBody2D

class_name Player

signal player_died(life: int)



#variables
var next_movement_direction = Vector2.ZERO
var movement_direction = Vector2.ZERO
var shape_query = PhysicsShapeQueryParameters2D.new()
var effective_speed = 100
#variables for the very basic ai
var change_direction_timer = 0.0
var change_direction_interval = 1.0
var target_pellet: Pellet = null

#variables for the chase the target ai
#var movement_direction = Vector2.RIGHT
#var target_position = Vector2.ZERO
#var change_target_timer = 0.0
#var change_target_interval = 2.0

#export variables
@export var speed = 500
@export var start_position: Node2D
@export var pacman_death_sound_player: AudioStreamPlayer2D
@export var pellets_manager: PelletsManager
@export var lifes: int = 10
@export var ui: UI

#onready variables
@onready var direction_pointer = $DirectionPointer
@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer


func _ready():
	
	shape_query.shape = collision_shape_2d.shape
	shape_query.collision_mask = 2
	ui.set_lifes(lifes)
	reset_player()

func reset_player():
	animation_player.play("default")
	position = start_position.position
	set_physics_process(true)
	target_pellet = null
	change_direction_timer = change_direction_interval
	next_movement_direction = Vector2.ZERO
	movement_direction = Vector2.ZERO
	
func _physics_process(delta):
	if movement_direction == Vector2.ZERO:
		choose_nearest_pellet()

	move_towards_target(delta)

func choose_nearest_pellet():
	var pellets = get_tree().get_nodes_in_group("Pellets")
	var nearest_distance: float =5000.00
	for Pellet in pellets: # Adjust "pellets" based on your pellet structure
		var distance = Pellet.global_position.distance_to(global_position)
		if distance < nearest_distance:
			target_pellet = Pellet
			nearest_distance = distance
			print("Target Pellet:", target_pellet)


#func get_input():
#
#	if Input.is_action_pressed("left"):
#		next_movement_direction = Vector2.LEFT
#		rotation_degrees = 0
#	elif  Input.is_action_pressed("right"):
#		next_movement_direction = Vector2.RIGHT
#		rotation_degrees = 180
#	elif Input.is_action_pressed("down"):
#		next_movement_direction = Vector2.DOWN
#		rotation_degrees = 270
#	elif Input.is_action_pressed("up"):
#		next_movement_direction = Vector2.UP
#		rotation_degrees = 90

#func can_move_in_direction(dir: Vector2, delta: float) -> bool:
#	shape_query.transform = global_transform.translated(dir * speed * delta * 2)
#	var result = get_world_2d().direct_space_state.intersect_shape(shape_query)
#	return result.size() == 0	

func die():

	pellets_manager.power_pellet_sound_player.stop()
	if !pacman_death_sound_player.playing:
		pacman_death_sound_player.play()
	animation_player.play("death")
	set_physics_process(false)

func _on_animation_player_animation_finished(anim_name):
		
	if anim_name == "death":
		lifes -= 1
		ui.set_lifes(lifes)
		player_died.emit(lifes)
		if lifes != 0:
			
			reset_player()
		else:
			position = start_position.position
			set_collision_layer_value(1, false)
			
#func choose_random_direction():
#	var random_direction = randi() % 4  # Random number between 0 and 3
#	match random_direction:
#		0:
#			movement_direction = Vector2.LEFT
#			rotation_degrees = 0
#		1:
#			movement_direction = Vector2.RIGHT
#			rotation_degrees = 180
#		2:
#			movement_direction = Vector2.UP
#			rotation_degrees = 90
#		3:
#			movement_direction = Vector2.DOWN
#			rotation_degrees = 270

func move_towards_target(delta):
	if is_instance_valid(target_pellet):
		var direction_to_target = (target_pellet.global_position - position).normalized()
		var target_velocity = direction_to_target * speed * delta
		velocity = velocity.lerp(target_velocity, 0.1)
#		if abs(velocity.x) > abs(velocity.y):
#			velocity.y = 0
#		else:
#			velocity.x = 0
			
			
		var offset = effective_speed * delta  
		
		var transform = Transform2D(rotation_degrees, position)
		
		var local_offset_x = offset * cos(deg_to_rad(rotation_degrees))
		
		var new_x = position.x + velocity.x * delta
		var new_position_x = Vector2(new_x, position.y)
		if not is_colliding(new_position_x):
			position.x = new_x
		else:
			position.x += local_offset_x
		
		var local_offset_y = offset * sin(deg_to_rad(rotation_degrees))
			
		var new_y = position.y + velocity.y * delta
		var new_position_y = Vector2(position.x, new_y)
		if not is_colliding(new_position_y):
			position.y = new_y
		else:
			position.y += local_offset_y
		
		
	else:
		choose_nearest_pellet()
		velocity = Vector2.ZERO
	
	velocity = velocity.normalized() * effective_speed
	move_and_slide()

#
#		if velocity.x > 0:
#			position.x += offset
#		elif velocity.x < 0:
#			position.x -= offset
#		elif velocity.y > 0:
#			position.y += offset
#		elif velocity.y < 0:
#			position.y -= offset

	
	
	
	
func is_colliding(new_position: Vector2) -> bool:
	shape_query.transform = Transform2D(0, new_position)  # Identity transform
	shape_query.transform = shape_query.transform.translated(new_position)
	var result = get_world_2d().direct_space_state.intersect_shape(shape_query)
	return result.size() > 0
	
	
	
#	else:
#		pas

	
