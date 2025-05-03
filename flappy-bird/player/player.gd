class_name Player
extends CharacterBody2D


enum State {
	FALL,
	JUMP,
	RISE,
	DEAD,
}

@export var sprite: AnimatedSprite2D
@export var audio_stream: AudioStreamPlayer2D
@export var jump_speed: int = -300

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var actual_state: State = State.JUMP


func _ready() -> void:
	#audio_stream.play()
	pass


# Calcula el movimiento del jugador en cada frame
func _physics_process(delta: float) -> void:
	match actual_state:
		# Rota el personaje cuando cae
		State.FALL:
			_handle_gravity(delta)
			rotation_degrees = lerp(rotation_degrees, 35.0, 3.5*delta)
		
		# Realiza el salto
		State.JUMP:
			sprite.play("jump")
			velocity.y = jump_speed
			actual_state = State.RISE
			move_and_slide()
		
		# Rota el personaje cuando vuela
		State.RISE:
			_handle_gravity(delta)
			rotation_degrees = lerp(rotation_degrees, -45.0, 10.0*delta)
			if velocity.y >= 0:
				actual_state = State.FALL
		
		# Mueve al jugador al suelo y lo rota
		State.DEAD:
			if position.y != 390:
				position.y = move_toward(position.y, 390, 350*delta)
			rotation_degrees = lerp(rotation_degrees, 90.0, 8.0*delta)


# Detecta el evento de salto
func _input(event: InputEvent) -> void:
	if actual_state == State.DEAD:
		return
	
	if event.is_action_pressed("Jump") and actual_state != State.JUMP:
		actual_state = State.JUMP
		
		# Cambia el tono ligeramente para que el sonido no sea repetitivo
		audio_stream.pitch_scale = randf_range(0.8, 1.2)
		audio_stream["parameters/switch_to_clip"] = "Jump"


# Funcion para cambiar el estado del player tras perder
func kill() -> void:
	actual_state = State.DEAD
	audio_stream.pitch_scale = 1.0
	audio_stream["parameters/switch_to_clip"] = "Die"


# Funcion para anadir la velocidad de la gravedad al player
func _handle_gravity(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()
