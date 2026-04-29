class_name Component
extends GamePlayObject

var parent: GamePlayObject = null


func _init(objectManager: ObjectManager, data: Dictionary = {}, inParent: GamePlayObject = null) -> void:
	super._init(objectManager, data)
	parent = inParent


func GetParent() -> GamePlayObject:
	return parent
