class_name Pipe
extends Node2D

signal player_hitted
signal player_scored

@export var speed: float = 20.0
@export_category("Pipe height")
@export var min_height: int = 30
@export var max_height: int = 150
@export_category("Pipe space")
@export var min_space: int = 30
@export var max_space: int = 70

var move: bool = true

@onready var upper_pipe: Area2D = $UpperPipe
@onready var lower_pipe: Area2D = $LowerPipe


func _ready() -> void:
	_set_pipes()


func _process(delta: float) -> void:
	pass


# Separa las tuberías entre si y cambia su altura
func _set_pipes() -> void:
	var space: int = randi_range(min_space, max_space)
	


# Emite la señal cuando el jugador cruza las tuberias
func _on_score_body_exited(body: Node2D) -> void:
	player_hitted.emit()


# Emite la señal cuando el jugador choca con las tuberias
func _on_pipe_body_entered(body: Node2D) -> void:
	move = false
	player_hitted.emit()
