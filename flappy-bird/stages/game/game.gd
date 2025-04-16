extends Node2D


const PIPES = preload("res://obstacles/pipes/pipes.tscn")

@export var speed: int = 20
@export var speed_add: int = 10
@export var initial_wait_time: float = 6.5

var pipes: Array[Pipe] = []
var pipe_spawn: int = 320
var score: int = 0

@onready var game_floor: Area2D = $Floor
@onready var timer: Timer = $PipeSpawnTimer


# Crea las tuberías y posiciona al jugador
func _ready() -> void:
	timer.wait_time = initial_wait_time
	game_floor.speed = speed
	game_floor.player_hitted.connect(_on_player_hitted)


# Detecta las acciones del jugador
func _input(event: InputEvent) -> void:
	if event.is_action_released("Jump"):
		if timer.is_stopped():
			timer.start()
			_spawn_pipe()


# Genera las tuberias en el mapa
func _spawn_pipe():
	var pipe: Pipe = PIPES.instantiate()
	pipe.player_scored.connect(_on_point_scored)
	pipe.player_hitted.connect(_on_player_hitted)
	pipe.spawn = pipe_spawn
	pipe.speed = speed
	add_child(pipe)
	pipes.append(pipe)


# El timer acaba y se genera otra tuberia
func _on_pipe_spawn_timer_timeout() -> void:
	_spawn_pipe()


# La funcion que aumenta la puntuacion
func _on_point_scored() -> void:
	score += 1


# La funcion que reinicia el juego
func _on_player_hitted() -> void:
	get_tree().reload_current_scene()
