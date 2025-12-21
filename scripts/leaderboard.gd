extends Control

var scoreline_scene = preload("res://scenes/leaderboard/scoreline.tscn")
var has_submitted := false

func _ready():
	#_reset_leaderboard()aw
	
	$PlayButton.pressed.connect(_submit_score)
	
	# Clear dummy data from editor
	#for child in $VBoxContainer.get_children():
	for child in $GridContainer.get_children():
		child.queue_free()

	populate_leaderboard()


func populate_leaderboard():
	SilentWolf.Scores.get_scores(10)
	SilentWolf.Scores.sw_get_scores_complete.connect(_finish_populate_leaderboard)


func _add_scoreline(pos, name, score):
	var scoreline_pos = scoreline_scene.instantiate()
	var scoreline_name = scoreline_scene.instantiate()
	var scoreline_score = scoreline_scene.instantiate()
	scoreline_pos.text = '#' + str(pos) + " "
	scoreline_name.text = name + " "
	scoreline_score.text = str(int(score))
	$GridContainer.add_child(scoreline_pos)
	$GridContainer.add_child(scoreline_name)
	$GridContainer.add_child(scoreline_score)


func _finish_populate_leaderboard(sw_result):
	print("_finish_populate_leaderboard")
	$LoadingLabel.hide()
	#for child in $VBoxContainer.get_children():
	for child in $GridContainer.get_children():
	
		child.queue_free()
	await get_tree().process_frame
	
	print("Scores: " + str(SilentWolf.Scores.scores))
	# Fill leadecrboard with user data
	var idx = 1
	for score in SilentWolf.Scores.scores:
		_add_scoreline(idx, score.player_name, score.score)
		idx += 1
	# Fill remainder with nothing
	for voo in range(SilentWolf.Scores.scores.size(), 10):
		_add_scoreline(idx, "----------------", "---")
		idx += 1
	
	SilentWolf.Scores.sw_get_scores_complete.disconnect(_finish_populate_leaderboard)


func _submit_score():
	if $LineEdit.text != "" and not has_submitted:
		has_submitted = true
		var score_id = await SilentWolf.Scores.save_score($LineEdit.text, Global.player_score())
		print("Score saved successfully: " + str(Global.player_score()))
		SilentWolf.Scores.sw_save_score_complete.connect(_finish_submit_score)
		_finish_submit_score(null)
		$LineEdit.text = ""


func _finish_submit_score(sw_result):
	print("_finish_submit_score")
	SilentWolf.Scores.sw_save_score_complete.disconnect(_finish_submit_score)
	populate_leaderboard()


func _reset_leaderboard():
	await SilentWolf.Scores.wipe_leaderboard()
