# godot-coroutine-utilities
Await multiple coroutines or signals at once. Similar to `Promise.all` or `Promise.any` in Javascript, or `join` or `select_all` in rust.

# Usage
There are two classes, `CRArr` and `CRDict`.  
## CRArr
```gd
var cr_arr := CRArr.new()
cr_arr.add_signal(get_tree().create_timer(3).timeout)
cr_arr.add_signal(enemy_entered_area)
# will return the result of the first of these two that completes.
var result = await cr_arr.await_any()
# result in this case will be either null or Area2D.
# ...
var cr_arr := CRArr.new()
cr_arr.add_signal(get_tree().create_timer(3).timeout)
cr_arr.add_signal(enemy_entered_area)
# will return an array containing all of the values
# of the above coroutines/signals, in the order they
# were defined.
var result := await cr_arr.await_all()
# result in this case will be [null, Area2D]
```
## CRDict  
```gd
var cr_dict := CRDict.new()
cr_dict.add_signal("timer", get_tree().create_timer(3).timeout)
cr_dict.add_signal("area", enemy_entered_area)
# will return the result of the first of these two that completes.
var result = await cr_dict.await_any()
# result of await_any takes the shape { key: String, value: Variant}
# result.key here will be "timer" or "area", and result.value will be null or Area2D.
# ...
var cr_dict := CRDict.new()
cr_dict.add_signal("timer", get_tree().create_timer(3).timeout)
cr_dict.add_signal("area", enemy_entered_area)
# will return a dictionary of the result of each signal.
var result := await cr_dict.await_all()
# result in this case will be {"timer": null, "area": Area2D}
