module vec

import math

struct Goods {
	weight f64
mut:
	price f64
}

fn test_vec_push_pop() {
	mut arr := with_cap<Goods>(5)
	arr.push(Goods{ price: 10.0, weight: 5.0 })
	{
		good := arr.get(0)
		assert good.price == 10.0
		assert good.weight == 5.0
	}
	arr.push(Goods{ price: 11.0, weight: 6.0 })
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
	arr.push(Goods{ price: 19.0, weight: 5.0 })
	for i in 0 .. 3 {
		arr.insert(0, Goods{ price: 10.0 + i, weight: 5.0 + i })
	}
	assert arr.len() == 4
	assert arr.get(0).price == 12.0
	assert arr.get(1).price == 11.0
	assert arr.get(2).price == 10.0
	assert arr.get(3).price == 19.0
}

fn test_vec_swap_remove() {
	mut arr := with_cap<Goods>(5)
	arr.set_zero()
	for i in 0 .. 7 {
		arr.push(Goods{ price: 10.0 + i, weight: 5.0 + i })
	}
	{
		elem := arr.swap_remove(2)
		assert elem.price == 12.0
		assert arr.get(2).price == 16.0
	}
	{
		elem := arr.swap_remove(0)
		assert elem.price == 10.0
		assert arr.get(0).price == 15.0
	}
	{
		elem := arr.swap_remove(1)
		assert elem.price == 11.0
		assert arr.get(1).price == 14.0
	}
	{
		elem := arr.swap_remove(1)
		assert elem.price == 14.0
		assert arr.get(1).price == 13.0
	}
	{
		elem := arr.swap_remove(1)
		assert elem.price == 13.0
		assert arr.get(1).price == 16.0
	}
	{
		elem := arr.swap_remove(0)
		assert elem.price == 15.0
		assert arr.get(0).price == 16.0
	}
	{
		elem := arr.swap_remove(0)
		assert elem.price == 16.0
		assert arr.len() == 0
		// assert arr.get(0).price == 15.0
	}
}

fn test_vec_remove() {
	mut arr := with_cap<Goods>(5)
	arr.set_zero()
	for i in 0 .. 7 {
		arr.push(Goods{ price: 10.0 + i, weight: 5.0 + i })
	}
	{
		elem := arr.remove(2)
		assert elem.price == 12.0
		assert arr.get(2).price == 13.0
	}
	{
		assert arr.get(5).price == 16.0
		assert arr.get(4).price == 15.0
		assert arr.get(3).price == 14.0
		assert arr.get(2).price == 13.0
		assert arr.get(1).price == 11.0
		assert arr.get(0).price == 10.0
	}
}

fn test_vec_remove2() {
	{
		mut arr := with_cap<Goods>(2)
		arr.set_zero()
		for i in 0 .. 2 {
			arr.push(Goods{ price: 10.0 + i, weight: 5.0 + i })
		}
		elem := arr.remove(1)
		assert elem.price == 11.0
		assert arr.get(0).price == 10.0
		assert arr.len() == 1
	}
	{
		mut arr := with_cap<Goods>(2)
		arr.set_zero()
		for i in 0 .. 2 {
			arr.push(Goods{ price: 10.0 + i, weight: 5.0 + i })
		}
		elem := arr.remove(0)
		assert elem.price == 10.0
		assert arr.get(0).price == 11.0
		assert arr.len() == 1
	}
	{
		mut arr := with_cap<Goods>(2)
		for i in 0 .. 1 {
			arr.push(Goods{ price: 10.0 + i, weight: 5.0 + i })
		}
		elem := arr.remove(0)
		assert elem.price == 10.0
		assert arr.len() == 0
	}
}

fn test_vec_set_len() {
	mut arr := with_cap<Goods>(5)
	arr.set_zero()
	unsafe { arr.set_len(5) }
	assert arr.len() == 5
	assert arr.get(0).price == 0.0
	assert arr.get(0).weight == 0.0
	arr.free()
	// arr.free() // double free
}

fn test_vec_iter_struct() ? {
	mut arr := with_cap<Goods>(5)
	for i in 0 .. 5 {
		arr.push(Goods{ price: 10.0 + i, weight: 5.0 + i })
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

fn test_vec_iter_mut_struct() ? {
	mut arr := with_cap<Goods>(5)
	for i in 0 .. 5 {
		arr.push(Goods{ price: 10.0 + i, weight: 5.0 + i })
	}
	for mut g in arr.iter() {
		g.price += 10.0
	}
	mut iter := arr.iter()
	assert iter.next()?.price == 20.0
	assert iter.next()?.price == 21.0
	assert iter.next()?.price == 22.0
	assert iter.next()?.price == 23.0
	assert iter.next()?.price == 24.0
	if _ := iter.next() {
		assert false
	}
}

fn test_vec_clone() ? {
	mut arr := with_cap<Goods>(5)
	for i in 0 .. 5 {
		arr.push(Goods{ price: 10.0 + i, weight: 5.0 + i })
	}
	for mut g in arr.iter() {
		g.price += 10.0
	}
	mut cloned := arr.clone()
	mut iter := cloned.iter()
	assert iter.next()?.price == 20.0
	assert iter.next()?.price == 21.0
	assert iter.next()?.price == 22.0
	assert iter.next()?.price == 23.0
	assert iter.next()?.price == 24.0
	if _ := iter.next() {
		assert false
	}
	cloned.free()
	arr.free()
}

fn test_vec_iter() ? {
	mut arr := with_cap<int>(5)
	mut expected := []&int{cap: 5}
	for i in 0 .. 5 {
		arr.push(i)
	}
	for g in arr.iter() {
		dump(*g)
		expected << g
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
	// assert *(iter.next()?) == 0
	assert iter.next()? == expected[0]
	assert iter.next()? == expected[1]
	assert iter.next()? == expected[2]
	assert iter.next()? == expected[3]
	assert iter.next()? == expected[4]
	if _ := iter.next() {
		assert false
	}
}

fn test_vec_new_grow_len() ? {
	mut arr := new<int>()
	// arr.grow_len(1)
	for i in 0 .. 5 {
		arr.push(i)
	}
}

fn test_vec_iter_rev_struct() ? {
	mut arr := with_cap<Goods>(5)
	for i in 0 .. 5 {
		arr.push(Goods{ price: 10.0 + i, weight: 5.0 + i })
	}
	mut iter_ := arr.iter()
	mut iter := iter_.rev()
	assert iter.next()?.price == 14.0
	assert iter.next()?.price == 13.0
	assert iter.next()?.price == 12.0
	assert iter.next()?.price == 11.0
	assert iter.next()?.price == 10.0
	if _ := iter.next() {
		assert false
	}
}

fn test_vec_str() ? {
	mut arr := with_cap<Goods>(5)
	for i in 0 .. 2 {
		arr.push(Goods{ price: 10.0 + i, weight: 5.0 + i })
	}
	assert arr.str() == 'Vec<vec.Goods>[vec.Goods{
    weight: 5
    price: 10
}, vec.Goods{
    weight: 6
    price: 11
}]'
	// 	assert arr.str() == 'Vec<T>{
	// 	data: &vec.Goods
	// 	cap: 5
	// 	len: 0
	// }'
}

fn test_vec_retain__greater_than() ? {
	mut arr := with_cap<Goods>(10)
	arr.set_zero()
	for i in 0 .. 10 {
		arr.push(Goods{ price: 10.0 + i, weight: 5.0 + i })
	}

	arr.retain(fn (g &Goods) bool {
		return g.price > 12.0
	})
	assert arr.len == 7

	assert arr.get(2).price == 15.0
	assert arr.get(2).weight == 10.0
	assert arr.get(1).price == 14.0
	assert arr.get(1).weight == 9.0
	assert arr.get(0).price == 13.0
	assert arr.get(0).weight == 8.0
}

fn test_vec_retain__mod_2_eq_0() ? {
	mut arr := with_cap<Goods>(10)
	arr.set_zero()
	for i in 0 .. 10 {
		arr.push(Goods{ price: 10.0 + i, weight: 5.0 + i })
	}

	arr.retain(fn (g &Goods) bool {
		return math.mod(g.price, 2) == 0
	})
	assert arr.len == 5

	assert arr.get(2).price == 14.0
	assert arr.get(2).weight == 9.0
	assert arr.get(1).price == 12.0
	assert arr.get(1).weight == 7.0
	assert arr.get(0).price == 10.0
	assert arr.get(0).weight == 5.0
}

fn test_vec_retain__except_last() ? {
	mut arr := with_cap<Goods>(10)
	arr.set_zero()
	for i in 0 .. 10 {
		arr.push(Goods{ price: 10.0 + i, weight: 5.0 + i })
	}

	arr.retain(fn (g &Goods) bool {
		return g.price != 19.0
	})
	assert arr.len == 9
	assert arr.get(8).price == 18.0
	assert arr.get(8).weight == 13.0
}
