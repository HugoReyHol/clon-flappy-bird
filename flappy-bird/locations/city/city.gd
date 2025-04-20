extends Sprite2D


var _day: bool = true

@onready var anim_player: AnimationPlayer = $AnimationPlayer


# Por defecto inicia con el fondo de día
func _ready() -> void:
	reset()


func reset() -> void:
	_day = true
	anim_player.play("RESET")

# Cambia el fondo por el contrario
func change_time() -> void:
	if _day:
		anim_player.play("change_time")
		
	else:
		anim_player.play_backwards("change_time")
	
	_day = !_day
