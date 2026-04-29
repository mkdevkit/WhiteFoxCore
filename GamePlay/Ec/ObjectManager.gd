class_name ObjectManager
extends RefCounted

var objs: Dictionary = {}
var objectIdIndex: int = 0
var dataBase: DataBase = null
var mode: Variant = null


func _init(inDataBase: DataBase, inMode: Variant) -> void:
	dataBase = inDataBase
	mode = inMode


func Size() -> int:
	return objs.size()


func GetObject(id: int) -> GamePlayObject:
	return objs.get(id, null)


func GenObjectId() -> int:
	objectIdIndex += 1
	return objectIdIndex


func Exist(id: int) -> bool:
	return objs.has(id)


func Add(obj: GamePlayObject) -> GamePlayObject:
	var objectId := obj.GetId()
	var prev: GamePlayObject = objs.get(objectId, null)
	objs[objectId] = obj
	return prev


func Get(id: int) -> GamePlayObject:
	return objs.get(id, null)


func Remove(id: int) -> bool:
	if not objs.has(id):
		return false
	objs.erase(id)
	return true


func CreateObject(type: Variant, data: Dictionary, args: Array = []) -> GamePlayObject:
	var objectId := GenObjectId()
	data["objectId"] = objectId
	var obj: GamePlayObject = type.new(self, data, args[0] if args.size() > 0 else null, args[1] if args.size() > 1 else null)
	Add(obj)
	return obj


func CreateEntity(scheme: Dictionary, parent: GamePlayObject = null) -> GameplayEntity:
	var data: Dictionary = {}
	var obj: GameplayEntity = GameplayEntity.new(self, data, scheme, parent)
	data["objectId"] = GenObjectId()
	objs[data["objectId"]] = obj
	dataBase.InsertData(data["objectId"], data)
	obj.Init()
	return obj


func DestroyObject(obj: GamePlayObject) -> void:
	if obj == null:
		return
	Remove(obj.GetId())
	obj.Destroy()
