class_name CRArr


var _signals: Array[Signal] = []
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

func add_cr(cr_proxy: Callable):
	var sig = to_signal(cr_proxy)
	_signals.push_back(sig)

func add_signal(sig: Signal):
	_signals.push_back(sig)

func await_all() -> Array:
	var results := []
	results.resize(_signals.size())
	for i in _signals.size():
		var res = await _signals[i]
		results[i] = res
	return results

func await_any() -> Variant:
	var result: Variant
	
	var signal_id := _id_count
	_id_count += 1  
	var finished := Signal(self, str(signal_id))
	self.add_user_signal(str(signal_id))
	
	var wait_on := func _wait_on(sig: Signal):
		var res: Variant = await sig
		finished.emit(res)
		
	for sig in _signals:
		wait_on.call(sig)
	
	result = await finished
	
	return result			
	
