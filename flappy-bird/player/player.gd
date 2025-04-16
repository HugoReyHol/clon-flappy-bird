extends CharacterBody2D


enum State {
	WAIT,
	FALL,
	JUMP,
	RISE,
}

@export var sprite: AnimatedSprite2D
@export var jump_speed: int = -300

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var actual_state: State = State.WAIT


# Al iniciar el player usa la animacion en bucle
func _ready() -> void:
	sprite.play("wait_loop")


# Calcula el movimiento del jugador en cada frame
func _physics_process(delta: float) -> void:
	match actual_state:
		State.WAIT:
			velocity.y -= gravity * delta
			pass
		
		State.FALL:
			rotation_degrees = lerp(rotation_degrees, 35.0, 3.5*delta)
		
		State.JUMP:
			sprite.play("jump")
			velocity.y = jump_speed
			actual_state = State.RISE
		
		State.RISE:
			rotation_degrees = lerp(rotation_degrees, -45.0, 10.0*delta)
			if velocity.y >= 0:
				actual_state = State.FALL
	
	velocity.y += gravity * delta
	move_and_slide()


# Detecta el evento de salto
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump") and actual_state != State.JUMP:
		actual_state = State.JUMP
