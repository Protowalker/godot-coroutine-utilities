extends GutTest

func wait_and_return(frames: int, value: Variant):
	await wait_frames(frames)
	return value
	
func test_no_result_await_all():
	var cr_arr := CRArr.new()
	cr_arr.add_cr(func(): return await wait_frames(1))
	cr_arr.add_cr(func(): return await wait_frames(2))
	cr_arr.add_cr(func(): return await wait_frames(3))
	
	var result := await cr_arr.await_all()
	assert_true(result == [null, null, null])
	
func test_results_await_all():
	var cr_arr := CRArr.new()
	cr_arr.add_cr(func(): return await wait_and_return(1, 1))
	cr_arr.add_cr(func(): return await wait_and_return(2, 2))
	cr_arr.add_cr(func(): return await wait_and_return(3, 3))
	
	var result := await cr_arr.await_all()
	
	assert_true(result == [1,2,3])

func test_no_result_await_any():
	var cr_arr := CRArr.new()
	cr_arr.add_cr(func(): return await wait_frames(1))
	cr_arr.add_cr(func(): return await wait_frames(2))
	cr_arr.add_cr(func(): return await wait_frames(3))
	
	var result = await cr_arr.await_any()
	
	assert_true(result == null)
	
func test_result_await_any():
	var cr_arr := CRArr.new()
	cr_arr.add_cr(func(): return await wait_and_return(1, 1))
	cr_arr.add_cr(func(): return await wait_and_return(2, 2))
	cr_arr.add_cr(func(): return await wait_and_return(3, 3))
	
	var result = await cr_arr.await_any()
	
	assert_true(result == 1)
