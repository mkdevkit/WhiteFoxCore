class_name AbstractProxy
extends RefCounted

var scheme: Dictionary = {}
var mode: AbstractMode = null
var aiMode: AbstractAiMode = null
var frameGenerator: FrameGenerator = null
var handler: Variant = null


func _init(inScheme: Dictionary) -> void:
	scheme = inScheme
	frameGenerator = FrameGenerator.new()


func CreateBattle() -> void:
	var modeCls = scheme.get("mode", null)
	if modeCls != null:
		mode = modeCls.new(scheme, frameGenerator)
		mode.Init()
	var aiModeCls = scheme.get("aiMode", null)
	if aiModeCls != null:
		aiMode = aiModeCls.new(scheme)
		aiMode.Init()


func Start() -> void:
	if mode != null:
		mode.Start()
	if aiMode != null:
		aiMode.Start()


func PushCmd(cmd: Variant) -> void:
	frameGenerator.PushCmd(cmd)


func Tick() -> void:
	if aiMode != null:
		aiMode.Tick()
	if mode != null:
		mode.Tick()
	frameGenerator.Tick()
	if handler != null and "Tick" in handler:
		handler.Tick(frameGenerator)


func SetHandler(inHandler: Variant) -> void:
	handler = inHandler
