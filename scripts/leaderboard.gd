extends Control

var scoreline_scene = preload("res://scenes/leaderboard/scoreline.tscn")

func _ready():
	# Clear dummy data from editor
	for child in $VBoxContainer.get_children():
		child.queue_free()

	populate_leaderboard()
	# Everytime update_leaderboard is signaled, update leaderboard
	#update_leaderboard.connect(populate_leaderboard)
	
	
func populate_leaderboard():
	SilentWolf.Scores.get_scores(10)
	SilentWolf.Scores.sw_get_scores_complete.connect(_finish_populate_leaderboard)

func _finish_populate_leaderboard(sw_result):
	$LoadingLabel.hide()
	for child in $VBoxContainer.get_children():
		child.queue_free()
	print("Scores: " + str(SilentWolf.Scores.scores))
	var idx = 1
	for score in SilentWolf.Scores.scores:
		var scoreline = scoreline_scene.instantiate()
		scoreline.get_node("PositionLabel").text = '#' + str(idx)
		scoreline.get_node('NameLabel').text = score.player_name
		scoreline.get_node('ScoreLabel').text = str(int(score.score))
		$VBoxContainer.add_child(scoreline)
		idx += 1
	SilentWolf.Scores.sw_get_scores_complete.disconnect(_finish_populate_leaderboard)
