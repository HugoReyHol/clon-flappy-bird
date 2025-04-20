extends Node2D


enum GameState {
	WAIT,
	PLAY,
	DEAD,
}

const PIPES = preload("res://obstacles/pipes/pipes.tscn")

@export var initial_speed: int = 60
@export var speed_add: int = 10
@export var pipe_spawn: int = 320
@export var score_diff_add: int = 15

var speed: int = initial_speed
var pipes: Array[Pipe] = []
var score: int = 0
var game_state: GameState = GameState.WAIT

@onready var game_floor: Area2D = $Floor
@onready var player: Player = $Player
@onready var score_label: ScoreLabel = $UI/ScoreLabel
@onready var city: Sprite2D = $City
@onready var lose_ui: Control = $UI/LoseUI
@onready var fake_player: AnimatedSprite2D = $FakePlayer


# Crea las tuberías y posiciona al jugador
func _ready() -> void:
	game_floor.player_hitted.connect(_on_player_hitted)
	lose_ui.game_restarted.connect(reset)
	
	reset()


# Detecta las acciones del jugador
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump") and game_state == GameState.WAIT:
		# Muestra el player
		player.position = fake_player.position
		player.set_physics_process(true)
		player.visible = true
		
		# Oculta el fake player y para sus procesos
		fake_player.visible = false
		fake_player.set_process(false)
		fake_player.stop()
		
		# Cambia en estado de la escena
		game_state = GameState.PLAY
		_spawn_pipe()


func reset() -> void:
	lose_ui.show_ui(false)
	game_state = GameState.WAIT
	
	# Muestra el fake player y empieza sus procesos
	fake_player.position = Vector2i(72, 200)
	fake_player.visible = true
	fake_player.set_process(true)
	fake_player.play("wait_loop")
	
	# Oculta el player
	player.visible = false
	player.set_physics_process(false)
	player.actual_state = Player.State.JUMP
	player.rotation_degrees = 0
	
	speed = initial_speed
	
	game_floor.speed = speed
	game_floor.move = true
	
	for pipe in pipes:
		if pipe != null:
			pipe.queue_free()
	
	pipes.clear()
	
	score = 0
	score_label.reset()
	
	city.reset()

# Genera las tuberias en el mapa
func _spawn_pipe():
	var pipe: Pipe = PIPES.instantiate()
	
	pipe.player_scored.connect(_on_point_scored)
	pipe.player_hitted.connect(_on_player_hitted)
	pipe.pipe_entered.connect(_on_pipe_screen_entered)
	pipe.pipe_exited.connect(_on_pipe_screen_exited)
	
	pipe.spawn = pipe_spawn
	pipe.speed = speed
	pipes.append(pipe)
	add_child(pipe)


# La funcion que aumenta la puntuacion
func _on_point_scored() -> void:
	score += 1
	score_label.set_numbers(score)
	
	if score % score_diff_add == 0:
		speed += speed_add
		
		for pipe in pipes:
			if pipe != null:
				pipe.speed = speed
	
		game_floor.speed = speed
		city.change_time()


# La funcion que reinicia el juego
func _on_player_hitted() -> void:
	if game_state != GameState.PLAY:
		return
	
	game_state = GameState.DEAD
	  
	game_floor.move = false
	for pipe in pipes:
		if pipe != null:
			pipe.move = false
	
	player.kill()
	lose_ui.show_ui()


# La funcion que genera las tuberias cuando una entra en pantalla
func _on_pipe_screen_entered() -> void:
	_spawn_pipe()


# Funcion para eliminar una tuberia de la lista de tuberias
func _on_pipe_screen_exited() -> void:
	pipes[0].queue_free()
	pipes.remove_at(0)
