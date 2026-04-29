class_name AbstractAiMode
extends RefCounted

var scheme: Dictionary = {}


func _init(inScheme: Dictionary) -> void:
	scheme = inScheme
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
