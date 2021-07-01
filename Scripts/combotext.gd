extends RichTextLabel


var combo = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	bbcode_enabled = true

func _process(_delta):
	var combotext = "COMBO:"
	bbcode_text = "[center]%s[/center]" % combotext
	newline()
	var combonum = (str(combo))
	append_bbcode("[center]%s[/center]" % combonum )
