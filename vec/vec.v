module vec

pub struct Vec<T> {
mut:
	data &T    [required]
	cap  usize [required]
	len  usize [required]
}

pub fn new<T>() Vec<T> {
	return Vec<T>{
		data: unsafe { nil }
		cap: 0
		len: 0
	}
}

pub fn with_cap<T>(cap usize) Vec<T> {
	new_data := unsafe { C.malloc(cap * usize(sizeof(T))) }

	return Vec<T>{
		data: new_data
		cap: cap
		len: 0
	}
}

pub fn (ar &Vec<T>) iter() Iter<T> {
	return Iter<T>{
		v: unsafe { ar }
	}
}

pub fn (mut ar Vec<T>) grow_len(size usize) {
	if ar.len + size > ar.cap {
		mut new_cap := if ar.cap == 0 {
			2
		} else {
			ar.cap * 2
		}
		for new_cap < ar.len + size {
			new_cap *= 2
		}
		mut new_data := unsafe { C.malloc(new_cap * usize(sizeof(T))) }
		if !isnil(ar.data) {
			unsafe {
				C.memcpy(new_data, ar.data, ar.len * usize(sizeof(T)))
				C.free(ar.data)
			}
		}
		ar.data = new_data
		ar.cap = new_cap
	}
	ar.len += 1
}

[inline]
pub fn (ar &Vec<T>) len() usize {
	return ar.len
}

[inline]
pub fn (ar &Vec<T>) clone() Vec<T> {
	new_data := unsafe { C.malloc(ar.cap * usize(sizeof(T))) }
	unsafe { C.memcpy(new_data, ar.data, ar.len * usize(sizeof(T))) }
	return Vec<T>{
		cap: ar.cap
		len: ar.len
		data: new_data
	}
}

[inline]
pub fn (ar &Vec<T>) get(idx usize) &T {
	$if !prod {
		assert idx < ar.len
	}

	return unsafe { &ar.data[idx] }
}

pub fn (mut ar Vec<T>) pop() T {
	ar.len -= 1
	return unsafe { ar.data[ar.len] }
}

pub fn (mut ar Vec<T>) push(elm T) {
	ar.grow_len(1)
	unsafe {
		ar.data[ar.len - 1] = elm
	}
}

pub fn (mut ar Vec<T>) insert(pos usize, elm T) {
	$if !prod {
		assert pos < ar.len
	}

	count := ar.len - pos
	unsafe { ar.grow_len(1) }
	if count > 0 {
		unsafe { vmemmove(ar.data[pos + 1], ar.data[pos], isize(count * usize(sizeof(T)))) }
	}
	unsafe {
		ar.data[pos] = elm
	}
}

pub fn (mut ar Vec<T>) swap_remove(idx usize) T {
	$if !prod {
		assert idx < ar.len
	}

	elm := unsafe { ar.data[idx] }
	ar.len -= 1
	unsafe {
		ar.data[idx] = ar.data[ar.len]
	}
	return elm
}

pub fn (mut ar Vec<T>) remove(idx usize) T {
	$if !prod {
		assert idx < ar.len
	}

	elm := unsafe { ar.data[idx] }
	ar.len -= 1
	count := ar.len - idx
	if count > 0 {
		unsafe { vmemmove(ar.data[idx], ar.data[idx + 1], isize(count * usize(sizeof(T)))) }
	}
	return elm
}

pub fn (mut ar Vec<T>) clear() {
	ar.len = 0
}

// # Safety
//
// - must be `new_len <= cap`.
[unsafe]
pub fn (mut ar Vec<T>) set_len(new_len usize) {
	$if !prod {
		assert new_len <= ar.cap
	}

	ar.len = new_len
}

pub fn (mut ar Vec<T>) set_zero() {
	unsafe { C.memset(ar.data, 0, ar.cap * usize(sizeof(T))) }
}

pub fn (mut ar Vec<T>) free() {
	if !isnil(ar.data) {
		unsafe { C.free(ar.data) }
		ar.data = unsafe { nil }
	}
}
