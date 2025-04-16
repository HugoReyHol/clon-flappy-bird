class_name Pipe
extends Node2D


signal player_hitted
signal player_scored

@export var speed: float = 20.0
@export_category("Pipe height")
@export var min_height: int = -40
@export var max_height: int = 40
@export_category("Pipe space")
@export var min_space: int = 30
@export var max_space: int = 70

var move: bool = true

@onready var upper_pipe: Area2D = $UpperPipe
@onready var lower_pipe: Area2D = $LowerPipe


# Configura los valores por defecto cuando cargan todos sus nodos
func _ready() -> void:
	position.y = 200
	_set_pipe()


# Mueve las tuberias de der. a izq.
func _process(delta: float) -> void:
	if not move:
		return
	
	position.x -= speed * delta

# Separa las tuberías entre si y cambia su altura
func _set_pipe() -> void:
	position.x = 350
	upper_pipe.position.y = 0
	lower_pipe.position.y = 0
	
	var space: int = randi_range(min_space, max_space)
	upper_pipe.position.y -= space
	lower_pipe.position.y += space 
	print("space: " + str(space))
	
	var height: int = randi_range(min_height, max_height)
	position.y += height
	print("height: " + str(height))
	
	print("position: " + str(position))


# Emite la señal cuando el jugador cruza las tuberias
func _on_score_body_exited(body: Node2D) -> void:
	player_hitted.emit()


# Emite la señal cuando el jugador choca con las tuberias
func _on_pipe_body_entered(body: Node2D) -> void:
	move = false
	player_hitted.emit()


# Detecta cuando una tuberia ha salido de pantalla
func _on_screen_exit_detected() -> void:
	if position.x <= 0:
		print("salido")
		_set_pipe()
