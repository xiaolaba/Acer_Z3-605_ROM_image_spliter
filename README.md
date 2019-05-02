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
xiaolaba_Split_SPI_IMAGE.zip  
  
  
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
