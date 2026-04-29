class_name Schedule
extends RefCounted

var heap: Heap = null
var map: Dictionary = {}


func _init() -> void:
	heap = Heap.new(func(a: Variant, b: Variant) -> bool: return int(a) < int(b))
	map = {}


func Add(sign: int, expireFrame: int) -> void:
	map[sign] = expireFrame
	if heap.Find(sign).is_empty():
		heap.Push(sign, expireFrame)
	else:
		heap.Update(sign, expireFrame)


func Remove(sign: int) -> bool:
	if not map.has(sign):
		return false
	heap.Remove(sign)
	map.erase(sign)
	return true


func Exists(sign: int) -> bool:
	return map.has(sign)


func Update(sign: int, expireFrame: int) -> bool:
	if not map.has(sign):
		return false
	map[sign] = expireFrame
	heap.Update(sign, expireFrame)
	return true


func CollectExpired(frameIndex: int) -> Array:
	var expired: Array = []
	while true:
		var top: Dictionary = heap.Peek()
		if top.is_empty():
			break
		if int(top["value"]) <= frameIndex:
			heap.Pop()
			map.erase(int(top["sign"]))
			expired.append(int(top["sign"]))
			continue
		break
	return expired


func ActiveCount() -> int:
	return map.size()
