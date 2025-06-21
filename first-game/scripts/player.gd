extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 400.0
const DASH_DURATION = 0.2

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var jump_count = 0
var max_jumps = 2
var can_air_dash = false
var is_dashing = false
var dash_timer = 0.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		jump_count = 0

	if Input.is_action_just_pressed("jump") and (jump_count < max_jumps):
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		can_air_dash = true

	# Start dash
	if Input.is_action_just_pressed("dash") and can_air_dash and not is_on_floor():
		can_air_dash = false
		is_dashing = true
		dash_timer = DASH_DURATION
		velocity.x = direction * DASH_SPEED
		
		if direction:
			velocity.y = JUMP_VELOCITY * 0.6

	# Dash duration handler
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	else:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Sprite flip
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	move_and_slide()
