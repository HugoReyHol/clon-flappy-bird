class_name ScoreLabel
extends HBoxContainer


const NUMBERS_TEXTURES: Dictionary[String, Resource] = {
	"0": preload("res://ui/numbers/0.png"),
	"1": preload("res://ui/numbers/1.png"),
	"2": preload("res://ui/numbers/2.png"),
	"3": preload("res://ui/numbers/3.png"),
	"4": preload("res://ui/numbers/4.png"),
	"5": preload("res://ui/numbers/5.png"),
	"6": preload("res://ui/numbers/6.png"),
	"7": preload("res://ui/numbers/7.png"),
	"8": preload("res://ui/numbers/8.png"),
	"9": preload("res://ui/numbers/9.png"),
}

var numbers: Array[TextureRect] = []


func reset() -> void:	
	for number in numbers:
		number.queue_free()
		numbers.erase(number)
	
	set_numbers(0)


# Actualiza los numeros mostrados en la label
func set_numbers(score: int) -> void:
	var value: String = str(score)
	
	for i in range(len(value)):
		if len(numbers) > i:
			var number: TextureRect = numbers[i]
			number.texture = NUMBERS_TEXTURES[value[i]]
		
		else:
			var number: TextureRect = TextureRect.new()
			number.texture = NUMBERS_TEXTURES[value[i]]
			numbers.append(number)
			add_child(number)
