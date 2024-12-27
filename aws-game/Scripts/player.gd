extends CharacterBody2D


const SPEED = 300.0
const MAX_JUMP_VELOCITY = -600.0
const MIN_JUMP_VELOCITY = -300.0
const MAX_CHARGE_TIME = 1 #Time in seconds to reach maximum jump velocity

var jump_hold_time = 0.0
var is_jumping = false;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump charge.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		is_jumping = true;
		jump_hold_time += delta;
		jump_hold_time = clamp(jump_hold_time,0,MAX_CHARGE_TIME)
		$AnimatedSprite2D.play("jump_charge")
	elif is_jumping:
		#Calculate jump velocity when key is released
		is_jumping = false;
		var charge_ratio = jump_hold_time/MAX_CHARGE_TIME
		var jump_dist = lerp(MIN_JUMP_VELOCITY,MAX_JUMP_VELOCITY,charge_ratio)
		velocity.y = jump_dist
		jump_hold_time = 0.0
		$AnimatedSprite2D.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animation(direction)

func update_animation(direction: float) -> void:
	#If we are in Air 
	if !is_on_floor():
		if velocity.y <0:
			#going up
			$AnimatedSprite2D.play("jump")
		else:
			#falling
			$AnimatedSprite2D.play("idle")
	elif direction > 0:
		$AnimatedSprite2D.flip_h = false;
		$AnimatedSprite2D.play("walking")
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("walking")
	else:
		$AnimatedSprite2D.play("idle")
	# Update sprite direction
	if direction != 0:
		$AnimatedSprite2D.flip_h = direction < 0
