module vec

import cmp { Ordering }

pub fn (mut ar Vec<T>) sort_by<T>(cmp fn (a &T, b &T) Ordering) {
	// pub fn (mut ar Vec<T>) sort_by<T>(cmp fn (a &T, b &T) int) {
	C.qsort(ar.data, ar.len, usize(sizeof(T)), voidptr(cmp))
}
