#!/usr/bin/sh

# pacman -S $MINGW_PACKAGE_PREFIX-{gcc,fxc2}

set -uex

# TODO: -O3 -WX -Qstrip_reflect -Qstrip_debug -Qstrip_priv
fxc -nologo -Tcs_5_0 -EComputeMain -VnReftermCSShaderBytes -Fhrefterm_cs.h refterm.hlsl
sed -i 's/ComputeMain/ReftermCSShaderBytes/' refterm_cs.h

fxc -nologo -Tps_5_0 -EPixelMain -VnReftermPSShaderBytes -Fhrefterm_ps.h refterm.hlsl
sed -i 's/PixelMain/ReftermPSShaderBytes/' refterm_ps.h

fxc -nologo -Tvs_5_0 -EVertexMain -Fhrefterm_vs.h -VnReftermVSShaderBytes refterm.hlsl
sed -i 's/VertexMain/ReftermVSShaderBytes/' refterm_vs.h

CFLAGS="-g -mno-stack-arg-probe -maes"
CFLAGS+=" -DNTDDI_VERSION=NTDDI_WIN10_RS4 -DWINVER=_WIN32_WINNT_WIN10"
CFLAGS+=" -DSTRSAFE_NO_DEPRECATE"

LDFLAGS="-mwindows -nostdlib -lkernel32 -luser32 -lgdi32"
LDFLAGS+=" -ld2d1 -ld3d11 -ldwrite -ldxguid -luuid -lusp10"

BASE_FILES="refterm.c refterm_example_dwrite.cpp"

clang $CFLAGS $BASE_FILES $LDFLAGS -o refterm_debug_clang.exe
clang -O3 -NDEBUG $CFLAGS $BASE_FILES $LDFLAGS -o refterm_release_clang.exe

gcc $CFLAGS $BASE_FILES $LDFLAGS -o refterm_debug_gcc.exe
gcc -O3 -NDEBUG $CFLAGS $BASE_FILES $LDFLAGS -o refterm_release_gcc.exe
