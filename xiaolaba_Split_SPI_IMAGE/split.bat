@echo Acer Z3-605 8MB ROM file dump and spliter
@echo.
@Echo by xiaolab, 2019-APR-30
@echo.
@Echo off


:: copy / split /compare with original ROM file file
copy z3-605.bin z3-605.bin.pigoo

split_Z3-605_rom_xiaolaba.EXE

fc/b z3-605_8MB_ROM_xiaolaba.bin z3-605.bin.pigoo

:: assemble and compare with original ROM file
copy/b z3-605_DESC.bin + z3-605_ME.bin + z3-605_BIOS.bin z3-605_8MB_ROM_assembly_xiaolaba.bin

fc/b z3-605_8MB_ROM_assembly_xiaolaba.bin z3-605.bin.pigoo

::fc P11-A2.CAP P11-A3.CAP > P11_A1_A2_diff.txt
::fc/b P11-A2.CAP P11-A3.CAP > P11_A1_A2_diff.txt

pause