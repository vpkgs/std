module vec

import strings

pub fn (ar &Vec<T>) str<T>() string {
	if ar.len == 0 {
		return 'Vec<$T.name>[]'
	}
	mut b := strings.new_builder(1024)
	b.write_string('Vec<')
	b.write_string(T.name)
	b.write_string('>[')
	mut i := usize(0)
	for {
		unsafe { b.write_string(ar.data[i].str()) }
		i++
		if i == ar.len {
			break
		}
		b.write_u8(`,`)
		b.write_u8(` `)
	}
	b.write_u8(`]`)
	return b.str()
}

// pub fn (ar &Vec<T>) str() string {
// 	return '${@STRUCT}{
// 	data: &${T.name}
// 	cap: $ar.cap
// 	len: $ar.len
// }'
// }
