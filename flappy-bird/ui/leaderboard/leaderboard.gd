extends Control


const MAX_USER: int = 3

@export var anim_player: AnimationPlayer


func _ready() -> void:
	Supabase.database.selected.connect(_update_leaderboard)
	Supabase.database.query(SupabaseQuery.new()
		.from("games")
		.select(["score", "user(email)"])
		.order("score", SupabaseQuery.Directions.Descending)
		.order("duration")
		.range(0, MAX_USER - 1)
	)


func _update_leaderboard(result: Array) -> void:
	print("Longitud: ", len(result))
	print(result)
	
	for index in range(MAX_USER):
		var player_lbl: Label = get_node("TextureRect/Player" + str(index+1))
		var score_lbl: Label = get_node("TextureRect/Score" + str(index+1))
		
		if result.size() > index:
			var score = result[index]
			player_lbl.text = score["user"]["email"].split("@")[0]
			score_lbl.text = str(score["score"] as int)
		
		else:
			player_lbl.text = "------------------"
			score_lbl.text = "------"
	
	anim_player.play("show_leaderboard")
