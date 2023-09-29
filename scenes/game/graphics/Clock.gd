extends TextureRect

signal time_over

var time_mins := 10
var time_seconds := 0

var running := false
var enabled := true

func init(total_time_mins: int, total_time_seconds: int) -> void:
	$Label.text = int_to_str(total_time_mins) + ":" + int_to_str(total_time_seconds)
	time_mins = total_time_mins
	time_seconds = total_time_seconds
	if time_mins == time_seconds and time_seconds == 0:
		hide()

# Called when the node enters the scene tree for the first time. foo
func timeout() -> void:
	if time_seconds == 0 and time_mins == 0 and running == true  and enabled == true:
		print("time over!")
		time_over.emit()
		running = false
	elif time_seconds == 0 and running == true  and enabled == true:
		time_mins -= 1
		time_seconds = 59
		update()
	elif running == true  and enabled == true:
		time_seconds -= 1
		update()
	
	if time_mins <= 5:
		Music.switch_tracks(Music.tracks.TIME)
		

func int_to_str(i: int) -> String:
	var prefix
	if i < 10:
		prefix = "0"
	else:
		prefix = ""
	return prefix + str(i)

func update() -> void:
	$Label.text = int_to_str(time_mins) + ":" + int_to_str(time_seconds)
	$Timer.start(1)

func start() -> void:
	running = true
	$Timer.start(1)
