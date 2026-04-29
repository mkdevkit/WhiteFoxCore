class_name GameplayEntity
extends GamePlayObject

var comps: Dictionary = {}
var children: Dictionary = {}
var parent: GamePlayObject = null
var scheme: Dictionary = {}


func _init(objectManager: ObjectManager, data: Dictionary = {}, inScheme: Dictionary = {}, inParent: GamePlayObject = null) -> void:
	super._init(objectManager, data)
	comps = {}
	parent = inParent
	scheme = inScheme
	children = {}


func Comp(compName: String) -> Variant:
	return comps.get(compName, null)


func OnInit(args: Array = []) -> void:
	super.OnInit(args)
	InstallEvents()
	InstallComponents()


func InstallComponents() -> void:
	if scheme.is_empty() or not scheme.has("comps"):
		return
	var compsArray: Array = scheme["comps"]
	for compScheme in compsArray:
		var compName: String = compScheme.GetCompName()
		AddComponent(compName, compScheme)


func InstallEvents() -> void:
	if scheme.is_empty() or not scheme.has("events"):
		return
	CreateAllEvents(scheme["events"])


func AddComponent(compName: String, comp: Variant) -> void:
	if comps.has(compName):
		RemoveComponent(compName)
	data["comps"] = data.get("comps", {})
	var compData: Dictionary = data["comps"].get(compName, {})
	var compObj: GamePlayObject = objectManager.CreateObject(comp, compData, self)
	compObj.Init()
	comps[compName] = compObj


func RemoveComponent(compName: String) -> void:
	if not comps.has(compName):
		return
	var compObj: GamePlayObject = comps[compName]
	objectManager.DestroyObject(compObj)
	comps.erase(compName)
	if data.has("comps") and data["comps"].has(compName):
		data["comps"].erase(compName)


func CreateChildEntity(inScheme: Dictionary) -> GameplayEntity:
	var child: GameplayEntity = objectManager.CreateEntity(inScheme, self)
	data["children"] = data.get("children", {})
	data["children"][child.GetId()] = child.GetId()
	children[child.GetId()] = child
	return child


func RemoveChildEntity(child: GameplayEntity) -> void:
	if not children.has(child.GetId()):
		return
	objectManager.DestroyObject(child)
	children.erase(child.GetId())
	if data.has("children") and data["children"].has(child.GetId()):
		data["children"].erase(child.GetId())


func OnPostDisable() -> void:
	for compName in comps.keys():
		var compObj: GamePlayObject = comps[compName]
		compObj.Disable()


func OnPostDestroy() -> void:
	for compName in comps.keys().duplicate():
		RemoveComponent(String(compName))
	for childId in children.keys().duplicate():
		RemoveChildEntity(children[childId])
