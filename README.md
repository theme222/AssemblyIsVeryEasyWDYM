# AssemblyIsVeryEasyWDYM
> A repository on some assembly projects purely for practice and reference

`x86_64 assembly intel_sytax noprefix`

ok maybe it's a bit difficult xd

## How to compile
```sh
as filename.asm -o filename.o ; gcc filename.o -o filename -nostdlib -static ; ./filename
```

## How to view
```sh
objdump -d filename | less
```

## How to time
```sh
hyperfine -r 50000; ./filename
```
