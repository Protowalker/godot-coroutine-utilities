extends GutTest

func wait_and_return(frames: int, value: Variant):
	await wait_frames(frames)
	return value
	
func test_no_result_await_all():
	var cr_dict := CRDict.new()
	cr_dict.add_cr("1", func(): return await wait_frames(1))
	cr_dict.add_cr("2", func(): return await wait_frames(2))
	cr_dict.add_cr("3", func(): return await wait_frames(3))
	
	var result := await cr_dict.await_all()
	assert_true(result == {
		"1": null,
		"2": null,
		"3": null
	})
	
func test_results_await_all():
	var cr_dict := CRDict.new()
	cr_dict.add_cr("1", func(): return await wait_and_return(1,1))
	cr_dict.add_cr("2", func(): return await wait_and_return(2,2))
	cr_dict.add_cr("3", func(): return await wait_and_return(3,3))
	
	var result := await cr_dict.await_all()
	assert_true(result == {
		"1": 1,
		"2": 2,
		"3": 3
	})

func test_no_result_await_any():
	var cr_dict := CRDict.new()
	cr_dict.add_cr("1", func(): return await wait_frames(1))
	cr_dict.add_cr("2", func(): return await wait_frames(2))
	cr_dict.add_cr("3", func(): return await wait_frames(3))
	
	var result := await cr_dict.await_any()
	
	assert_true(result.key == "1")
	assert_true(result.value == null)	
	
func test_result_await_any():
	var cr_dict := CRDict.new()
	cr_dict.add_cr("1", func(): return await wait_and_return(1,1))
	cr_dict.add_cr("2", func(): return await wait_and_return(2,2))
	cr_dict.add_cr("3", func(): return await wait_and_return(3,3))
	
	var result := await cr_dict.await_any()
	
	assert_true(result.key == "1")
	assert_true(result.value == 1)	
