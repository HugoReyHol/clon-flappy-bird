extends Sprite2D


var _day: bool = true
var mat: ShaderMaterial

@onready var anim_player: AnimationPlayer = $AnimationPlayer


# Por defecto inicia con el fondo de día
func _ready() -> void:
	mat = material
	mat.set_shader_parameter("mix_amount", 0.0)


# Cambia el fondo por el contrario
func change_time() -> void:
	if _day:
		anim_player.play("change_time")
		
	else:
		anim_player.play_backwards("change_time")
	
	_day = !_day
