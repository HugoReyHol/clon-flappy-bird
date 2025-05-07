class_name VolumeSlider
extends Control


signal value_changed(value: float)
signal muted_pressed(muted: bool)
signal drag_ended()

const SPEAKER_ON = preload("res://ui/volume_sliders/sprites/speaker_on.png")
const SPEAKER_MUTE = preload("res://ui/volume_sliders/sprites/speaker_mute.png")

@export var slider: HSlider
@export var muteButton: TextureButton

var muted: bool


# Le asigan un nuevo valor al slider
func set_values(sound: float, mute: bool) -> void:
	slider.value = sound
	muted = mute
	set_muted()


# Cambia el valor del botón para silenciar
func set_muted() -> void:
	muteButton.texture_normal = SPEAKER_MUTE if muted else SPEAKER_ON


# Emite la señal para pasar el valor al padre
func _on_sound_slider_value_changed(value: float) -> void:
	value_changed.emit(value)


# Emite la señal para pasar el valor al padre
func _on_mute_button_up() -> void:
	muted = !muted
	set_muted()
	muted_pressed.emit(muted)


func _on_sound_slider_drag_ended(_value_changed: bool) -> void:
	drag_ended.emit()
