class_name CRDict

class Result:
	var key: String
	var value: Variant
	
	func _init(key: String, value: Variant):
		self.key = key
		self.value = value


var _signals: Dictionary = {}
var _id_count := 0

func to_signal(cr_proxy: Callable) -> Signal:
	var signal_id := _id_count
	_id_count += 1  
	var finished := Signal(self, str(signal_id))
	self.add_user_signal(str(signal_id))
	
	var complete := func _complete():
		var result: Variant = await cr_proxy.call()
		finished.emit(result)
	
	complete.call()
	return finished

func add_cr(key: String, cr_proxy: Callable):
	var sig = to_signal(cr_proxy)
	_signals[key] = sig

func add_signal(key: String, sig: Signal):
	_signals[key] = sig

func await_all() -> Dictionary:
	var results := {}
	for key in _signals.keys():
		var res = await _signals[key]
		results[key] = res
	return results

func await_any() -> Result:
	var result: Result
	
	var signal_id := _id_count
	_id_count += 1  
	var finished := Signal(self, str(signal_id))
	self.add_user_signal(str(signal_id))
	
	var wait_on := func _wait_on(key: String, sig: Signal):
		var res: Variant = await sig
		finished.emit(Result.new(key, res))
		
	for key in _signals.keys():
		wait_on.call(key, _signals[key])
	
	result = await finished
	
	return result
	
