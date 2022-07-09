carray: array.c
	gcc -o carray -fno-stack-protector array.c

darray: array.d
	dmd array.d

slice: slice.d
	dmd slice.d

array_setting: array_setting.d
	dmd array_setting.d

array_concat: array_concat.d
	dmd array_concat.d

vector: vector.d
	dmd vector.d

clean:
	rm -rf *.o carray array sice array_setting array_concat vector
