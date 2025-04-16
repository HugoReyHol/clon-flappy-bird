extends Node2D


const PIPES = preload("res://obstacles/pipes/pipes.tscn")

var pipes: Array[Pipe] = []


# Crea las tuberías y posiciona al jugador
func _ready() -> void:
	var pipe: Pipe = PIPES.instantiate()
	add_child(pipe)
	pipes.append(pipe)


func _process(_delta: float) -> void:
	pass
