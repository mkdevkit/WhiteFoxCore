class_name AbstractMode
extends RefCounted

var scheme: Dictionary = {}
var entityScheme: Dictionary = {}
var dataBase: DataBase = null
var objectManager: ObjectManager = null
var frameGenerator: FrameGenerator = null


func _init(inScheme: Dictionary, inFrameGenerator: FrameGenerator) -> void:
	scheme = inScheme
	entityScheme = scheme.get("entityScheme", {})
	dataBase = DataBase.new()
	objectManager = ObjectManager.new(dataBase, self)
	frameGenerator = inFrameGenerator
	Init()


func OnInit() -> void:
	pass


func Init() -> void:
	OnInit()


func Start() -> void:
	OnStart()


func OnStart() -> void:
	pass


func Tick() -> void:
	OnTick()


func OnTick() -> void:
	pass


func GetFrameIndex() -> int:
	return frameGenerator.GetFrameId()
