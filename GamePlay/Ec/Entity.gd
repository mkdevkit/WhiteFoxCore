class_name GameplayEntity
extends RefCounted


var comps: Dictionary = {}


func Comp(compName: String) -> Variant:
	return comps.get(compName, null)


func AddComponent(compName: String, component: Variant) -> void:
	comps[compName] = component
