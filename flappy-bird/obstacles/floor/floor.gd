extends Area2D

signal player_hitted

const MIN_OFFSET: float = 0
const MAX_OFFSET: float = -48

@export var sprite: Sprite2D
@export var speed: float = 2.0

var move: bool = true 


# Al cargar la escena empieza en offset 0
func _ready() -> void:
	sprite.offset.x = MIN_OFFSET


# Si el juego continua se mueve infinitamente el sprite de der. a izq.
func _process(delta: float) -> void:
	if not move:
		return
	
	sprite.offset.x -= speed * delta
	sprite.offset.x = fmod(sprite.offset.x, MAX_OFFSET)


# Al detectar una colision con el player se emite fin del juego
func _on_body_entered(_body: Node2D) -> void:
	player_hitted.emit()
