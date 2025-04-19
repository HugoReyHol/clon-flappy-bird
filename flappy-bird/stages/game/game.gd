extends Node2D


const PIPES = preload("res://obstacles/pipes/pipes.tscn")

@export var speed: int = 20
@export var speed_add: int = 10
@export var pipe_spawn: int = 320
@export var score_diff_add: int = 15

var pipes: Array[Pipe] = []
var score: int = 0
var playing: bool = false

@onready var game_floor: Area2D = $Floor
@onready var player: CharacterBody2D = $Player
@onready var score_label: ScoreLabel = $UI/ScoreLabel
@onready var city: Sprite2D = $City
@onready var lose_ui: Control = $UI/LoseUI


# Crea las tuberías y posiciona al jugador
func _ready() -> void:
	game_floor.speed = speed
	game_floor.player_hitted.connect(_on_player_hitted)
	player.position = Vector2i(72, 200)
	score_label.score = score


# Detecta las acciones del jugador
func _input(event: InputEvent) -> void:
	if event.is_action_released("Jump") and not playing:
		playing = true
		_spawn_pipe()


# Genera las tuberias en el mapa
func _spawn_pipe():
	var pipe: Pipe = PIPES.instantiate()
	
	pipe.player_scored.connect(_on_point_scored)
	pipe.player_hitted.connect(_on_player_hitted)
	pipe.pipe_entered.connect(_on_pipe_screen_entered)
	pipe.pipe_exited.connect(_on_pipe_screen_exited)
	
	pipe.spawn = pipe_spawn
	pipe.speed = speed
	add_child(pipe)
	pipes.append(pipe)


# La funcion que aumenta la puntuacion
func _on_point_scored() -> void:
	score += 1
	score_label.score = score
	
	if score % score_diff_add == 0:
		speed += speed_add
		for pipe in pipes:
			pipe.speed = speed
		game_floor.speed = speed
		city.change_time()


# La funcion que reinicia el juego
func _on_player_hitted() -> void:
	if not playing:
		return
	
	playing = false
	 
	game_floor.move = false
	for pipe in pipes:
		pipe.move = false
	
	player.kill()
	lose_ui.show_ui()


# La funcion que genera las tuberias cuando una entra en pantalla
func _on_pipe_screen_entered() -> void:
	_spawn_pipe()


# Funcion para eliminar una tuberia de la lista de tuberias
func _on_pipe_screen_exited() -> void:
	pipes.remove_at(0)
