extends Sprite2D


const BACKGROUND_DAY = preload("res://locations/city/sprites/background-day.png")
const BACKGROUND_NIGHT = preload("res://locations/city/sprites/background-night.png")

var _day: bool = true


# Por defecto inicia con el fondo de día
func _ready() -> void:
	texture = BACKGROUND_DAY


# Cambia el fondo por el contrario
func change_time() -> void:
	_day = !_day
	
	texture = BACKGROUND_DAY if _day else BACKGROUND_NIGHT
