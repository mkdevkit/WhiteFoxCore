class_name BattleTimer
extends RefCounted

var map: Dictionary = {}
var signMap: Dictionary = {}
var schedule: Schedule = null
var mode: AbstractMode = null


func _init(inMode: AbstractMode) -> void:
	schedule = Schedule.new()
	map = {}
	signMap = {}
	mode = inMode


func AddTimer(key: String, delayFrame: int, objId: int, method: String) -> void:
	var entry: Dictionary
	if map.has(key):
		entry = map[key]
	else:
		entry = {"objId": objId, "method": method, "sign": objId}
		map[key] = entry
	signMap[int(entry["sign"])] = key
	var expireFrame := mode.GetFrameIndex() + delayFrame
	schedule.Add(int(entry["sign"]), expireFrame)


func RemoveTimer(key: String) -> void:
	var entry: Dictionary = map.get(key, {})
	if entry.is_empty():
		return
	signMap.erase(int(entry["sign"]))
	map.erase(key)
	schedule.Remove(int(entry["sign"]))


func Tick() -> void:
	var nowFrame := mode.GetFrameIndex()
	var expired: Array = schedule.CollectExpired(nowFrame)
	for sign in expired:
		var key: String = signMap.get(int(sign), "")
		if key != "" and map.has(key):
			var entry: Dictionary = map[key]
			var obj = mode.objectManager.GetObject(int(entry["objId"]))
			if obj != null and obj.has_method(String(entry["method"])):
				obj.call(String(entry["method"]), int(entry["objId"]))
			map.erase(key)
		signMap.erase(int(sign))
