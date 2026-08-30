extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED := 100.0
const ATTACK_SPEED := 0.6
const ROLL_SPEED := 200
const ROLL_TIME := 0.3

var is_rolling := false
var is_attacking := false
var rolling_timer := 0.0
var attack_timer := 0.0
var last_direction := Vector2.DOWN


func _physics_process(delta: float) -> void:
	if is_rolling:
		rolling_timer -= delta
		
		if rolling_timer <= 0.0:
			is_rolling = false
			velocity = Vector2.ZERO
	
	elif is_attacking:
		attack_timer -= delta
		velocity = Vector2.ZERO
		
		if attack_timer <= 0.0:
			is_attacking = false
	else:
		process_roll()
		
		if not is_rolling:
			process_attack()
		
		if not is_rolling and not is_attacking:
			process_movement()
			
	move_and_slide()


func process_movement() -> void:
	var direction := Input.get_vector("left_input", "right_input", "up_input", "down_input")

	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction

		if abs(direction.x) > abs(direction.y):
			animated_sprite_2d.flip_h = direction.x < 0
			animated_sprite_2d.play("run_side")
		elif direction.y < 0:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("run_back")
		elif direction.y > 0:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("run_front")
	else:
		velocity = Vector2.ZERO

		if abs(last_direction.x) > abs(last_direction.y):
			animated_sprite_2d.flip_h = last_direction.x < 0
			animated_sprite_2d.play("idle_side")
		elif last_direction.y < 0:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("idle_back")
		else:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("idle_front")

func process_attack() -> void:
	
	if Input.is_action_just_pressed("attack_input"):
		print("atak")
		print(last_direction)
		is_attacking = true
		attack_timer = ATTACK_SPEED
		velocity = Vector2.ZERO
		
		if  abs(last_direction.x) > abs(last_direction.y):
			animated_sprite_2d.flip_h = last_direction.x < 0
			animated_sprite_2d.play("attack_side")
		elif last_direction.y < 0:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("attack_back")
		else:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("attack_front")	
		
func process_roll() -> void:
	if Input.is_action_just_pressed("roll_input"):
		print("roll")
		is_rolling = true
		rolling_timer = ROLL_TIME
		
		var direction := Input.get_vector("left_input", "right_input", "up_input", "down_input")
		
		if direction == Vector2.ZERO:
			direction = last_direction
		velocity=direction.normalized() * ROLL_SPEED
		
		
