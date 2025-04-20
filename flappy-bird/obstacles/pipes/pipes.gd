class_name Pipe
extends Node2D


signal player_hitted
signal player_scored
signal pipe_entered
signal pipe_exited()

@export var speed: float = 20.0
@export_category("Pipe height")
@export var min_height: int = -40
@export var max_height: int = 40
@export_category("Pipe space")
@export var min_space: int = 30
@export var max_space: int = 70

var move: bool = true
var spawn: int = 400
var upper_pipe_y: int
var lower_pipe_y: int

@onready var upper_pipe: CollisionShape2D = $UpperCollision
@onready var lower_pipe: CollisionShape2D = $LowerCollision


# Configura los valores por defecto cuando cargan todos sus nodos
func _ready() -> void:
	upper_pipe_y = upper_pipe.position.y
	lower_pipe_y = lower_pipe.position.y
	_set_pipe()


# Mueve las tuberias de der. a izq.
func _process(delta: float) -> void:
	if not move:
		return
	
	position.x -= speed * delta


# Separa las tuberías entre si y cambia su altura
func _set_pipe() -> void:
	position = Vector2i(spawn, 200)
	upper_pipe.position.y = upper_pipe_y
	lower_pipe.position.y = lower_pipe_y
	
	var space: int = randi_range(min_space, max_space)
	upper_pipe.position.y -= space
	lower_pipe.position.y += space 
	
	var height: int = randi_range(min_height, max_height)
	position.y += height


# Emite la señal cuando el jugador cruza las tuberias
func _on_score_body_exited(_body: Node2D) -> void:
	player_scored.emit()


# Emite la señal cuando el jugador choca con las tuberias
func _on_pipe_body_entered(_body: Node2D) -> void:
	player_hitted.emit()


# Detecta cuando una tuberia ha salido de pantalla
func _on_screen_exit_detected() -> void:
	if position.x <= 0:
		pipe_exited.emit()
		queue_free()


# Detecta cuando una tberia ha entrado en pantalla
func _on_screen_entered_detected() -> void:
	pipe_entered.emit()
