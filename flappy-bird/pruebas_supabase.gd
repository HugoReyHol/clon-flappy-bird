extends Node


func _ready() -> void:
	#_cargar_user()
	pass

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
	var auth := Supabase.auth.user("eyJhbGciOiJIUzI1NiIsImtpZCI6ImdtaElXZThYNld0Vmt0eWMiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3Rqa2xpa2l2ZWJ0cG5ybHJ0ZmRzLnN1cGFiYXNlLmNvL2F1dGgvdjEiLCJzdWIiOiJkNTFlZjU1Mi00YmNlLTRkOTctYTFjMi1mNWYyZmQ0ZGQwNzMiLCJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzQ2NjQ1MDA4LCJpYXQiOjE3NDY2NDE0MDgsImVtYWlsIjoidGVzdEB0ZXN0LmNvbSIsInBob25lIjoiIiwiYXBwX21ldGFkYXRhIjp7InByb3ZpZGVyIjoiZW1haWwiLCJwcm92aWRlcnMiOlsiZW1haWwiXX0sInVzZXJfbWV0YWRhdGEiOnsiZW1haWwiOiJ0ZXN0QHRlc3QuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInBob25lX3ZlcmlmaWVkIjpmYWxzZSwic3ViIjoiZDUxZWY1NTItNGJjZS00ZDk3LWExYzItZjVmMmZkNGRkMDczIn0sInJvbGUiOiJhdXRoZW50aWNhdGVkIiwiYWFsIjoiYWFsMSIsImFtciI6W3sibWV0aG9kIjoicGFzc3dvcmQiLCJ0aW1lc3RhbXAiOjE3NDY2NDE0MDh9XSwic2Vzc2lvbl9pZCI6ImY2ODE5OWNlLTA4NWQtNDVkZi05OGM2LTEyMTkxYjllNTlmMyIsImlzX2Fub255bW91cyI6ZmFsc2V9.dj4Y55LgI3FKYM5TCqWyDE1OL2yJvLdI1g2W7nTqpPU")
	auth.completed.connect(_hecho)
	pass

func _hecho(task: BaseTask) -> void:
	print(task.data)
	print(task.error)
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
