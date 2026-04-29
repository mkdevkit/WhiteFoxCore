class_name Event
extends RefCounted

var objectManager: ObjectManager = null
var data: Dictionary = {}


func _init(inObjectManager: ObjectManager, inData: Dictionary = {}) -> void:
	objectManager = inObjectManager
	data = inData if not inData.is_empty() else {}
	data["listeners"] = data.get("listeners", [])
	data["pendingAddListeners"] = data.get("pendingAddListeners", [])
	data["pendingRemoveListeners"] = data.get("pendingRemoveListeners", [])
	data["isDispatching"] = false


func AddListener(objectId: int, methodName: String) -> void:
	if bool(data["isDispatching"]):
		var pendingRemove: Array = data["pendingRemoveListeners"]
		for i in pendingRemove.size():
			var l: Dictionary = pendingRemove[i]
			if int(l["objectId"]) == objectId and String(l["methodName"]) == methodName:
				pendingRemove.remove_at(i)
				data["pendingRemoveListeners"] = pendingRemove
				return
		var pendingAdd: Array = data["pendingAddListeners"]
		pendingAdd.append({"objectId": objectId, "methodName": methodName})
		data["pendingAddListeners"] = pendingAdd
		return
	var listeners: Array = data["listeners"]
	for l in listeners:
		if int(l["objectId"]) == objectId and String(l["methodName"]) == methodName:
			return
	listeners.append({"objectId": objectId, "methodName": methodName})
	data["listeners"] = listeners


func RemoveListener(objectId: int, methodName: String) -> void:
	if bool(data["isDispatching"]):
		var pendingAdd: Array = data["pendingAddListeners"]
		for i in pendingAdd.size():
			var l: Dictionary = pendingAdd[i]
			if int(l["objectId"]) == objectId and String(l["methodName"]) == methodName:
				pendingAdd.remove_at(i)
				data["pendingAddListeners"] = pendingAdd
				return
		var pendingRemove: Array = data["pendingRemoveListeners"]
		pendingRemove.append({"objectId": objectId, "methodName": methodName})
		data["pendingRemoveListeners"] = pendingRemove
		return
	var listeners: Array = data["listeners"]
	for i in listeners.size():
		var l: Dictionary = listeners[i]
		if int(l["objectId"]) == objectId and String(l["methodName"]) == methodName:
			listeners.remove_at(i)
			break
	data["listeners"] = listeners


func Dispatch(args: Array = []) -> void:
	var listeners: Array = data["listeners"]
	if listeners.is_empty():
		ProcessPendingListeners()
		return
	data["isDispatching"] = true
	for listenerInfo in listeners.duplicate():
		var objectId: int = int(listenerInfo["objectId"])
		var methodName: String = String(listenerInfo["methodName"])
		var obj = objectManager.GetObject(objectId)
		if obj != null and obj.has_method(methodName):
			obj.callv(methodName, args)
	data["isDispatching"] = false
	ProcessPendingListeners()


func ProcessPendingListeners() -> void:
	var pendingAdd: Array = data["pendingAddListeners"]
	while not pendingAdd.is_empty():
		var listener: Dictionary = pendingAdd.pop_front()
		var listeners: Array = data["listeners"]
		var exists := false
		for l in listeners:
			if int(l["objectId"]) == int(listener["objectId"]) and String(l["methodName"]) == String(listener["methodName"]):
				exists = true
				break
		if not exists:
			listeners.append(listener)
		data["listeners"] = listeners
	data["pendingAddListeners"] = pendingAdd

	var pendingRemove: Array = data["pendingRemoveListeners"]
	while not pendingRemove.is_empty():
		var listener: Dictionary = pendingRemove.pop_front()
		var listeners: Array = data["listeners"]
		for i in listeners.size():
			var l: Dictionary = listeners[i]
			if int(l["objectId"]) == int(listener["objectId"]) and String(l["methodName"]) == String(listener["methodName"]):
				listeners.remove_at(i)
				break
		data["listeners"] = listeners
	data["pendingRemoveListeners"] = pendingRemove
