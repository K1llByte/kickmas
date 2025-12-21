extends Control

@export var fade_duration := 1.0  # seconds
var fading := false

func _input(event):
	if fading:
		return
	if (event is InputEventKey or event is InputEventAction) and event.pressed and not event.echo:
		fading = true
		_fade_out()

func _fade_out():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_duration)
