module vec

import cmp {Ordering}

struct Goods {
	weight f64
mut:
	price f64
}

fn test_sort() ? {
	mut arr := with_cap<Goods>(5)
	arr.push(Goods{ price: 12.0, weight: 7.0 })
	arr.push(Goods{ price: 10.0, weight: 5.0 })
	arr.push(Goods{ price: 11.0, weight: 6.0 })
	arr.push(Goods{ price: 14.0, weight: 9.0 })
	arr.push(Goods{ price: 13.0, weight: 8.0 })
	arr.sort_by(fn (a &Goods, b &Goods) Ordering {
		return if a.price > b.price { .gt } else if a.price == b.price { .eq } else { .lt }
	})

	assert arr.get(0).price == 10.0
	assert arr.get(1).price == 11.0
	assert arr.get(2).price == 12.0
	assert arr.get(3).price == 13.0
	assert arr.get(4).price == 14.0
}