module vec

struct Goods {
	price f64
	weight f64
}

fn test_vec_push_pop() {
	mut arr := with_cap<Goods>(5)
	arr.push(Goods{price: 10.0, weight: 5.0})
	{
		good := arr.get(0)
		assert good.price == 10.0
		assert good.weight == 5.0
	}
	arr.push(Goods{price: 11.0, weight: 6.0})
	{
		good := arr.get(1)
		assert good.price == 11.0
		assert good.weight == 6.0
	}
	{
		good := arr.pop()
		assert good.price == 11.0
		assert good.weight == 6.0
	}
	{
		good := arr.get(0)
		assert good.price == 10.0
		assert good.weight == 5.0
	}
}

fn test_vec_insert() {
	mut arr := with_cap<Goods>(2)
	arr.push(Goods{price: 19.0, weight: 5.0})
	for i in 0..3 {
		arr.insert(0, Goods{price: 10.0 + i, weight: 5.0 + i})
	}
	assert arr.len() == 4
	assert arr.get(0).price == 12.0
	assert arr.get(1).price == 11.0
	assert arr.get(2).price == 10.0
	assert arr.get(3).price == 19.0
}

fn test_vec_remove() {
	mut arr := with_cap<Goods>(5)
	for i in 0..7 {
		arr.push(Goods{price: 10.0 + i, weight: 5.0 + i})
	}
	{
		elem := arr.swap_remove(2)
		assert elem.price == 12.0
		assert arr.get(2).price == 16.0
	}
	{
		elem := arr.remove(2)
		assert elem.price == 16.0
		assert arr.get(2).price == 13.0
	}
}

fn test_vec_set_len() {
	mut arr := with_cap<Goods>(5)
	arr.set_zero()
	unsafe {arr.set_len(5)}
	assert arr.len() == 5
	assert arr.get(0).price == 0.0
	assert arr.get(0).weight == 0.0
	arr.free()
	// arr.free() // double free
}

fn test_vec_iter_struct() ? {
	mut arr := with_cap<Goods>(5)
	for i in 0..5 {
		arr.push(Goods{price: 10.0 + i, weight: 5.0 + i})
	}
	mut iter := arr.iter()
	assert iter.next()?.price == 10.0
	assert iter.next()?.price == 11.0
	assert iter.next()?.price == 12.0
	assert iter.next()?.price == 13.0
	assert iter.next()?.price == 14.0
	if _ := iter.next() {
		assert false
	}
}

fn test_vec_iter() ? {
	mut arr := with_cap<int>(5)
	for i in 0..5 {
		arr.push(i)
	}
	for g in arr.iter() {
		dump(*g)
	}
	{
		mut iter := arr.iter()
		if a := iter.next() {
			assert *a == 0
		}
		if a := iter.next() {
			assert *a == 1
		}
		if a := iter.next() {
			assert *a == 2
		}
		if a := iter.next() {
			assert *a == 3
		}
		if a := iter.next() {
			assert *a == 4
		}
		if a := iter.next() {
			assert *a == 5
		}
	}

	mut iter := arr.iter()
	// iter.next()?
	assert *(iter.next()?) == 0
	assert *(iter.next()?) == 1
	assert iter.next()? == 2
	assert iter.next()? == 3
	assert iter.next()? == 4
	if _ := iter.next() {
		assert false
	}
}
