class_name DataBase
extends RefCounted

var datas: Dictionary = {}


func _init() -> void:
	datas = {}


func InsertData(key: Variant, data: Variant) -> void:
	datas[key] = data


func DeleteData(key: Variant) -> void:
	datas.erase(key)


func SetData(key: Variant, data: Variant) -> void:
	if datas.has(key):
		return
	datas[key] = data


func GetData(key: Variant) -> Variant:
	return datas.get(key, null)
