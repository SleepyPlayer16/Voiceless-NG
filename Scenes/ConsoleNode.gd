extends Node

var console = preload("res://objects/Console.tscn")

func open_console():
	var id = console.instance()
	add_child(id)
	