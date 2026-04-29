class_name FrameGenerator
extends RefCounted

var frameIdIndex: int = 0
var cmds: Dictionary = {}
var acts: Dictionary = {}
var actStack: Array = []


func GenFrameId() -> int:
	var ret := frameIdIndex
	frameIdIndex += 1
	return ret


func GetFrameId() -> int:
	return frameIdIndex


func Tick() -> void:
	GenFrameId()


func PushCmd(cmd: Variant) -> void:
	var frameId := GetFrameId()
	if not cmds.has(frameId):
		cmds[frameId] = []
	cmds[frameId].append(cmd)


func GetCmds(frameId: int) -> Array:
	return cmds.get(frameId, [])


func GetAllCmds() -> Dictionary:
	return cmds


func GetActs(frameId: int) -> Array:
	return acts.get(frameId, [])


func GetAllActs() -> Dictionary:
	return acts


func PushAction(act: Variant) -> void:
	var frameId := GetFrameId()
	if not acts.has(frameId):
		acts[frameId] = []
		actStack = []
	if actStack.is_empty():
		actStack.append(acts[frameId])
	actStack[actStack.size() - 1].append(act)


func PushContainer() -> Dictionary:
	var container: Array = []
	var act := {"acts": container}
	PushAction(act)
	actStack.append(container)
	return act


func PopContainer() -> void:
	if not actStack.is_empty():
		actStack.pop_back()
