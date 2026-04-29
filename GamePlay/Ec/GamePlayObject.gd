class_name GamePlayObject
extends RefCounted

var eventBinders: Dictionary = {}
var events: Dictionary = {}
var data: Dictionary = {}
var objectManager: ObjectManager = null
var mode: Variant = null


func _init(inObjectManager: ObjectManager, inData: Dictionary = {}) -> void:
	data = inData if not inData.is_empty() else {}
	objectManager = inObjectManager
	mode = objectManager.mode


func OnPreInit(args: Array = []) -> void:
	pass


func PreInit(args: Array = []) -> void:
	OnPreInit(args)


func OnInit(args: Array = []) -> void:
	pass


func Init(args: Array = []) -> void:
	PreInit()
	OnInit(args)
	PostInit()


func OnPostInit(args: Array = []) -> void:
	pass


func PostInit(args: Array = []) -> void:
	OnPostInit(args)


func GetId() -> int:
	return int(data.get("objectId", 0))


func GetEvent(eventType: String) -> Event:
	return events.get(eventType, null)


func CreateEvent(eventType: String) -> Event:
	if events.has(eventType):
		return events[eventType]
	data["events"] = data.get("events", {})
	var eventData: Dictionary = data["events"].get(eventType, {})
	data["events"][eventType] = eventData
	var eventObj := Event.new(objectManager, eventData)
	events[eventType] = eventObj
	return eventObj


func GetDefaultEventTypes() -> Array:
	return []


func CreateAllEvents(defaultEventTypes: Array) -> void:
	for eventType in defaultEventTypes:
		CreateEvent(String(eventType))


func BindEvent(objectId: int, eventType: String, callback: String) -> void:
	var targetObject = objectManager.GetObject(objectId)
	if targetObject == null:
		return
	var key := "%d_%s_%s" % [objectId, eventType, callback]
	eventBinders[key] = {"objectId": objectId, "eventType": eventType, "methodName": callback}
	var eventObj: Event = targetObject.GetEvent(eventType)
	if eventObj != null:
		eventObj.AddListener(GetId(), callback)


func UnBindEvent(objectId: int, eventType: String, callback: String) -> void:
	var targetObject = objectManager.GetObject(objectId)
	if targetObject == null:
		return
	var key := "%d_%s_%s" % [objectId, eventType, callback]
	if not eventBinders.has(key):
		return
	eventBinders.erase(key)
	var eventObj: Event = targetObject.GetEvent(eventType)
	if eventObj != null:
		eventObj.RemoveListener(GetId(), callback)


func UnbindAllEvent() -> void:
	for key in eventBinders.keys():
		var info: Dictionary = eventBinders[key]
		var targetObject = objectManager.GetObject(int(info["objectId"]))
		if targetObject == null:
			continue
		var eventObj: Event = targetObject.GetEvent(String(info["eventType"]))
		if eventObj != null:
			eventObj.RemoveListener(GetId(), String(info["methodName"]))
	eventBinders.clear()


func DispatchEvent(eventType: String, args: Array = []) -> void:
	var eventObj: Event = GetEvent(eventType)
	if eventObj != null:
		eventObj.Dispatch(args)


func GetData() -> Dictionary:
	return data


func OnPreDisable() -> void:
	pass


func PreDisable() -> void:
	OnPreDisable()


func OnPostDisable() -> void:
	pass


func PostDisable() -> void:
	OnPostDisable()


func Disable() -> void:
	PreDisable()
	PostDisable()


func OnPreDestroy() -> void:
	pass


func PreDestroy() -> void:
	OnPreDestroy()


func OnPostDestroy() -> void:
	pass


func PostDestroy() -> void:
	OnPostDestroy()


func Destroy() -> void:
	PreDestroy()
	UnbindAllEvent()
	PostDestroy()
