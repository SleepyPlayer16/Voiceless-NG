extends Sprite


var particles1 = preload("res://Particles/Checkpoint.tres")
var particles2 = preload("res://Particles/Player.tres")
var materials = [
	particles1,
	particles2
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for material in materials:
		var particles_instance = Particles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_modulate(Color(1,1,1,0))
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)

func fuckingrip():
	remove_child($Camera2D)
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
