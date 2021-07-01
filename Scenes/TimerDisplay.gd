extends RichTextLabel


var ms = 10
var s = 30
var m = 0
var enabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	rect_clip_content = false
	if enabled == true:
		visible = true
		if ms < 1:
				s -= 1
				ms = 10
		if s < 1:
			if m != 0:
				m-=1
				s = 60
			else:
				s = 0
				m = 0
				ms = 0

		set_text(str(m)+":"+str(s)+":"+str(ms))
	else:
		visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_ms_timeout() -> void:
	if enabled == true:
		ms-=1
