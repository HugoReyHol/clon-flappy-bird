extends Node


# Despues de obtener los datos depurarlos
# Buscar cómo hacer una segunda ordenación
func _prueba_select() -> void:
	Supabase.database.query(SupabaseQuery.new()
		.from("games")
		.select(["score", "user(email)"])
		.order("score", SupabaseQuery.Directions.Descending)
		.order("duration")
	)#.completed.connect(Callable)


func _prueba_sing_up() -> void:
	#Supabase.auth.signed_up.connect(callable)
	Supabase.auth.sign_up("test@test.com", "testtest")


func _prueba_sing_in() -> void:
	#Supabase.auth.signed_in.connect(callable)
	Supabase.auth.sign_in("test@test.com", "testtest")


func _cargar_user() -> void:
	# Obtener de la config
	#Supabase.auth.user(JWT)
	pass


func _log_out() -> void:
	#Supabase.auth.signed_out.connect(callable)
	Supabase.auth.sign_out()


func _prueba_insert() -> void:
	Supabase.database.query(SupabaseQuery.new()
		.from("games")
		.insert([
			{
				score = 100,
				duration = 200
			}
		])
	)#.completed.connect(callable)
