module vec

pub struct Iter<T> {
mut:
	v   &Vec<T> [required]
	pos usize
}

pub fn (mut iter Iter<T>) rev() Rev<T> {
	return Rev<T>{
		iter: iter
	}
}

pub fn (mut iter Iter<T>) next() ?&T {
	if iter.pos >= iter.v.len {
		return none
	}
	defer {
		iter.pos++
	}
	return unsafe { &iter.v.data[iter.pos] }
}

pub struct Rev<T> {
mut:
	iter Iter<T> [required]
}

pub fn (mut iter Rev<T>) next() ?&T {
	if iter.iter.pos >= iter.iter.v.len {
		return none
	}
	defer {
		iter.iter.pos++
	}
	return unsafe { &iter.iter.v.data[iter.iter.v.len - iter.iter.pos - 1] }
}
