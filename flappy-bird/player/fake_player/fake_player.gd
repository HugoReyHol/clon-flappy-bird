extends AnimatedSprite2D


enum FakePlayerState {
	RISE,
	FALL,
}

var fake_player_state: FakePlayerState = FakePlayerState.RISE


func _ready() -> void:
	position.y = 200
	play("wait_loop")


# Funcion que calcula la animacion cada frame
func _process(delta: float) -> void:
	match fake_player_state:
		FakePlayerState.RISE:
			rotation_degrees = lerp(rotation_degrees, -5.0, 3.5*delta)
			position.y = move_toward(position.y, 190, 25*delta)
			if position.y <= 190:
				fake_player_state = FakePlayerState.FALL
		
		FakePlayerState.FALL:
			rotation_degrees = lerp(rotation_degrees, 5.0, 3.5*delta)
			position.y = move_toward(position.y, 210, 25*delta)
			if position.y >= 210:
				fake_player_state = FakePlayerState.RISE
