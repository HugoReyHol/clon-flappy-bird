extends Control


@export var list: VBoxContainer


func _ready() -> void:
	Supabase.database.selected.connect(_update_leaderboard)
	Supabase.database.query(SupabaseQuery.new()
		.from("games")
		.select(["score", "user(email)"])
		.order("score", SupabaseQuery.Directions.Descending)
		.order("duration")
		.range(0, 2)
	)


func _update_leaderboard(result: Array) -> void:
	print("Longitud: ", len(result))
	print(result)
	
	for score in result:
		var lab: Label = Label.new()
		lab.text = str(score["score"]) + " " + score["user"]["email"]
		list.add_child(lab)
