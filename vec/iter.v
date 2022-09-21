module vec

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
