module cmp

pub enum Ordering {
	// less than
	// sort: `a` is before `b`
	lt = -1
	// equal to
	// sort: unchange
	eq = 0 
	// greater than
	// sort: `a` is after `b`
	gt = 1
}
