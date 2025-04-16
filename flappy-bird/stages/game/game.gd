extends Node2D


const PIPES = preload("res://obstacles/pipes/pipes.tscn")

@export var pipe_count: int = 3
@export var pipe_distance: int = 45
@export var initial_speed: int = 20

var pipes: Array[Pipe] = []
var pipe_spawn: int = (pipe_distance + 52) * ceil(288.0 / (pipe_distance + 52)) + 26

@onready var floor: Area2D = $Floor


# Crea las tuberías y posiciona al jugador
func _ready() -> void:
	_spawn_pipes()
	floor.speed = initial_speed


# Genera las tuberias en el mapa
func _spawn_pipes():
	for i in range(pipe_count):
		var pipe: Pipe = PIPES.instantiate()
		pipe.spawn = pipe_spawn
		pipe.spawn_offset = pipe_distance * i
		pipe.speed = initial_speed
		add_child(pipe)
		pipes.append(pipe)


func _process(_delta: float) -> void:
	pass
