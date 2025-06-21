extends CharacterBody2D

const SPEED := 130.0
const JUMP_VELOCITY := -300.0
const DASH_SPEED := 400.0
const DASH_DURATION := 0.2

@onready var animated_sprite: AnimatedSprite2D = $%AnimatedSprite2D

var _jump_count := 0
var _max_jumps := 2
var _can_air_dash := false
var _is_dashing := false
var _dash_timer := 0.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")

	# Handle player gravity and jumps
	_player_gravity(delta)
	_reset_jumps()
	_player_jump()
	_player_dash(direction)

	# Dash duration handler
	if _is_dashing:
		_dash_timer -= delta
		if _dash_timer <= 0:
			_is_dashing = false
	else:
		_player_velocity(direction)

	# Sprite flip
	_sprite_flip(direction)

	# Animations
	_player_animation(direction)

	move_and_slide()

# Function definitions
func _player_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func _reset_jumps() -> void:
	if is_on_floor():
		_jump_count = 0

func _player_jump() -> void:
	if Input.is_action_just_pressed("jump") and (_jump_count < _max_jumps):
		velocity.y = JUMP_VELOCITY
		_jump_count += 1
		_can_air_dash = true

func _player_dash(direction) -> void:
	if Input.is_action_just_pressed("dash") and _can_air_dash and not is_on_floor():
		_can_air_dash = false
		_is_dashing = true
		_dash_timer = DASH_DURATION
		velocity.x = direction * DASH_SPEED
	
		if direction:
			velocity.y = JUMP_VELOCITY * 0.6

func _player_velocity(direction) -> void:
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _sprite_flip(direction) -> void:
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

func _player_animation(direction) -> void:
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
