Initial motivation of this repository is, to implement new array to debug its elements easily on "lldb".

### Vec
Currently, we need to add `vec.free()` at the end of its scope.
Otherwise, you'll suffer from lots of memory leaks...

Wish `-autofree` will be stabilized soon!!

See [tests](vec/vec_test.v) for the usage.