class_name Heap
extends RefCounted

var heap: Array = []
var compare: Callable = Callable()


func _init(comparator: Callable) -> void:
	heap = []
	compare = comparator


func GetParentIndex(index: int) -> int:
	return int(floor(float(index - 1) / 2.0))


func GetLeftChildIndex(index: int) -> int:
	return 2 * index + 1


func GetRightChildIndex(index: int) -> int:
	return 2 * index + 2


func Swap(index1: int, index2: int) -> void:
	var temp = heap[index1]
	heap[index1] = heap[index2]
	heap[index2] = temp


func HeapifyUp(index: int) -> void:
	if index == 0:
		return
	var parentIndex := GetParentIndex(index)
	if compare.call(heap[index]["value"], heap[parentIndex]["value"]):
		Swap(index, parentIndex)
		HeapifyUp(parentIndex)


func HeapifyDown(index: int) -> void:
	var leftChildIndex := GetLeftChildIndex(index)
	var rightChildIndex := GetRightChildIndex(index)
	var targetIndex := index
	if leftChildIndex < heap.size() and compare.call(heap[leftChildIndex]["value"], heap[targetIndex]["value"]):
		targetIndex = leftChildIndex
	if rightChildIndex < heap.size() and compare.call(heap[rightChildIndex]["value"], heap[targetIndex]["value"]):
		targetIndex = rightChildIndex
	if targetIndex != index:
		Swap(index, targetIndex)
		HeapifyDown(targetIndex)


func Push(sign: int, value: Variant) -> void:
	heap.append({"sign": sign, "value": value})
	HeapifyUp(heap.size() - 1)


func Pop() -> Dictionary:
	if IsEmpty():
		return {}
	if heap.size() == 1:
		return heap.pop_back()
	var top: Dictionary = heap[0]
	heap[0] = heap.pop_back()
	HeapifyDown(0)
	return top


func Peek() -> Dictionary:
	if heap.is_empty():
		return {}
	return heap[0]


func Size() -> int:
	return heap.size()


func IsEmpty() -> bool:
	return heap.is_empty()


func Clear() -> void:
	heap.clear()


func Remove(sign: int) -> bool:
	var index := -1
	for i in heap.size():
		if int(heap[i]["sign"]) == sign:
			index = i
			break
	if index == -1:
		return false
	var lastIndex := heap.size() - 1
	if index == lastIndex:
		heap.pop_back()
		return true
	heap[index] = heap.pop_back()
	var parentIndex := GetParentIndex(index)
	if index > 0 and compare.call(heap[index]["value"], heap[parentIndex]["value"]):
		HeapifyUp(index)
	else:
		HeapifyDown(index)
	return true


func Find(sign: int) -> Dictionary:
	for item in heap:
		if int(item["sign"]) == sign:
			return item
	return {}


func Update(sign: int, value: Variant) -> bool:
	var index := -1
	for i in heap.size():
		if int(heap[i]["sign"]) == sign:
			index = i
			break
	if index == -1:
		return false
	heap[index]["value"] = value
	var parentIndex := GetParentIndex(index)
	if index > 0 and compare.call(heap[index]["value"], heap[parentIndex]["value"]):
		HeapifyUp(index)
	else:
		HeapifyDown(index)
	return true
