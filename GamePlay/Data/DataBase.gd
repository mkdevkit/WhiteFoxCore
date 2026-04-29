class_name DataBase
extends RefCounted


var datas: Dictionary = {}


func InsertData(key: Variant, data: Variant) -> void:
	datas[key] = data


func DeleteData(key: Variant) -> void:
	datas.erase(key)


func SetData(key: Variant, data: Variant) -> void:
	if not datas.has(key):
		datas[key] = data
