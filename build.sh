#!/bin/bash -v
mkdir -p build
go tool compile -p main -o build/main.o main.go
go tool objdump build/main.o &> build/main.o.s
go tool nm build/main.o &> build/main.o.nm

go build -gcflags="-l -N" -ldflags="-w -s" -o build/main main.go
go tool objdump build/main &> build/main.1.s
go tool nm build/main &> build/main.1.nm

objdump -D -M intel build/main &> build/main.2.s
nm build/main &> build/main.2.nm
readelf -a build/main &> build/info

# dlv-dap debug --check-go-version=false --build-flags="-ldflags='-w -s' -gcflags='-l -N'" main.go