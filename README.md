# Acer_Z3-605_ROM_image_spliter  
  
For Windows only, source code is self explanatory  
https://github.com/xiaolaba/Acer_Z3-605_ROM_image_spliter/blob/master/xiaolaba_Split_SPI_IMAGE/split_Z3-605_rom_xiaolaba.ASM  

exe  
https://github.com/xiaolaba/Acer_Z3-605_ROM_image_spliter/blob/master/xiaolaba_Split_SPI_IMAGE/split_Z3-605_rom_xiaolaba_EXE  
rename 
from
split_Z3-605_rom_xiaolaba_EXE  
to
split_Z3-605_rom_xiaolaba.EXE  
or you can assembly from source code by youself.  


根據以前用 INTEL的工具FPT, 輸出顯示這個機器的 FLASH ROM 是 8MB.  
所以得到的 IMAGE 也是 8MB, 0x800000 長度為 0x000000 - 0x7FFFFF.  
0x0-0xfff, Descriptor, 長度1K  
0x1000 - 0x4fffff, ME, 長度 5M 減去 上面那個 1K  
0x50000 - 0x7fffff, BIOS, 長度 3MB (8MB -5MB)  

有次出差等飛機沒事, 想要分割出來看看, Linux 有工具, 但是 WINDOWS 底下很麻煩, 所以實驗抄寫了一個小工具, 先把 ROM IMAGE 按照上面寫的那些地址和長度分割成3個檔案, 再用 copy/b 組合起來, 比對過原始的檔案無誤, 確認這個小工具可以用, 源碼一起提供, 有需要就自己改寫其他用途, 測試就用版主給的那個z3-605.bin, 改了一下名字, 方便人眼觀看.  
  
  
至於ACER原廠網站提供的 BIOS, 現在有兩個版本, 後來發現只有 3MB 大小, 就只是 BIOS 的那部分.  
https://www.acer.com/ac/zh/TW/content/support-product/4728?b=1&pn=DQ.SQQTA.001  
P11-A2.CAP  
P11-A3.CAP  
BIOS_Acer_P11.A2_A_A.zip  
BIOS_Acer_P11.A3_A_A.zip  
裡面的內容應該是不包含 WINDOWS KEY, 應該也沒有 LAN MAC 等資料, 所以沒辦法直拼裝一個 ROM IMAGE 來用, 除非有工具自己合成一個 ROM 或 BIOS IMAGE.  
  
估計 ME 和 DESCRIPTOR 那兩個部分不會隨便改變, 除非 INTEL 作怪, 其實它裡面真的有作怪的, 外國人有研究,  
https://www.slideshare.net/codeblue_jp/igor-skochinsky-enpub  
不過非專業也非找飯吃, 也沒有工具或時間來研究. 至於怎樣做出 BIOS IMAGE, 暫時不清楚也沒資料.  
  
  
source code listing,
```


; Split a ROM image to be sections
; by xiaolaba, 2019-APR-30

; Acer Z3-605
; 8MB flash ROM image, 0 - 0x7fffff
; 8MB = 0x800000, = 8 x 1024 x 1024 = 8,388,608 bytes

; FPT, intel Flash Programming Tool (8.1.10.1286) for visual, load ROM file and displayed as following,
; HM77 Express Chipset
; Descriptor, 0x000000 - 0x000fff
; ME,         0x001000 - 0x4fffff
; BIOS,       0x500000 - 0x7fffff
; GbE, Not Present
; PDR, Not Present

; assembler : fasm 1.73.09
; https://flatassembler.net/download.php

; REF:
; https://board.flatassembler.net/topic.php?t=5900
; http://www.betamaster.us/blog/?p=439

format pe console 4.0
include 'WIN32AX.INC'

; data
  FileIn   db 'z3-605.bin.pigoo',0
  FileOut  db 'z3-605_8MB_ROM_xiaolaba.bin',0
  FileDESC db 'z3-605_DESC.bin',0
  FileME   db 'z3-605_ME.bin',0
  FileBIOS db 'z3-605_BIOS.bin',0

  hFile         dd 0
  BytesRead     dd 0
  BytesWritten  dd 0
  nSize         dd 0

  lpMemory      dd 0

  lpBytesRead   dd ?

;  lpBuffer rb 0x800000
  Buffer.size equ ($ - lpBuffer) ; Calculates the size at compile time
  NULL equ 0

  MessageBoxCaption db 'Z3-605, 8MB ROM file spliter, xiaolaba, 2019-APR-30',0
  MsgOK db 'Done',0
  MsgNG db 'GlobalAlloc Failed',0

; code
main:

  ;read
  ; Read-only; other apps can read too; file must exist
  invoke  CreateFile, FileIn, GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0 ; Open the file (to get its handle)
  ; TODO: TestApiError
  mov [hFile], eax ; Save the file's handle to hFile
  invoke  GetFileSize, [hFile], 0 ; Determine the file size
  ; TODO: TestApiError
  mov [nSize], eax ; Save the file size given by EAX

  ;request buffer to hold file content
  ;invoke GlobalAlloc, GMEM_FIXED | GMEM_ZEROINIT, InitAllocSize
  invoke GlobalAlloc, (GMEM_FIXED + GMEM_ZEROINIT), [nSize] ;GMEM_FIXED, will return a handle in eax
  mov [lpMemory],eax    ; save return value anyway
  cmp eax,0             ; if return =0, failed
  jnz read_file
    ; error, no buffer to hold file content, nothing done
    invoke MessageBox, NULL, addr MsgNG, addr MessageBoxCaption, MB_OK
    invoke CloseHandle, [hFile] ; Handle should be closed
    invoke  ExitProcess, 0

read_file:
  ;invoke  ReadFile, [hFile], lpBuffer, [nSize], lpBytesRead, 0 ; Now read the full file
  invoke  ReadFile, [hFile], [lpMemory], [nSize], lpBytesRead, 0 ; Now read the full file
  ; TODO: TestApiError
  invoke CloseHandle, [hFile] ; Handle should be closed after the file has been read



;write to other file = copy a file
  ; write only; if the file doesn't exist, create it
  invoke CreateFile, FileOut, GENERIC_WRITE, NULL, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
  mov [hFile],eax
  invoke WriteFile, [hFile], [lpMemory], [nSize], BytesRead, NULL
  invoke CloseHandle,[hFile] ; done

  ;write to DESC.bin
  invoke CreateFile, FileDESC, GENERIC_WRITE, NULL, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
  mov [hFile],eax
  invoke WriteFile, [hFile], [lpMemory], 0x1000, BytesRead, NULL
  invoke CloseHandle,[hFile] ; done

  ;write to ME.bin
  invoke CreateFile, FileME, GENERIC_WRITE, NULL, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
  mov [hFile],eax
  mov eax,[lpMemory]
  add eax,0x1000
  invoke WriteFile, [hFile], eax, 0x500000-0x1000, BytesRead, NULL
  invoke CloseHandle,[hFile] ; done

  ;write to BIOS.bin
  invoke CreateFile, FileBIOS, GENERIC_WRITE, NULL, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
  mov [hFile],eax
  mov eax,[lpMemory]
  add eax,0x500000
  invoke WriteFile, [hFile], eax, 0x300000, BytesRead, NULL
  invoke CloseHandle,[hFile] ; done

  ;signal user, job done
  invoke MessageBox, NULL, addr MsgOK, addr MessageBoxCaption, MB_OK

  ;release used buffer
  invoke GlobalAlloc,[lpMemory]

finish:
  invoke  ExitProcess, 0
 
.end main


```
