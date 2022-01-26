# 16-bit-processor-vhdl
   Recommended RTL level design, VHDL modeling, ModelSIM simulation and FPGA implementation of a simple 16-bit microprocessor. 

## Waveform
* How to test:
* Step 1: Compile all files
* Step 2: Run command vopt +acc cpu_tb -o cpu_tb_opt
* Step 3: In library, run cpu_tb in work
* Step 4: In DUT, click control unit -> controller -> select all -> add to wave
* Step 5: In data, click rf_u -> add RF to wave
* Step 6: Adjust 3000 ns and run

![Screenshot (768)](https://user-images.githubusercontent.com/81580234/150943877-0f37e0f9-d795-4963-a04f-9922df2a1a2b.png)

## Machine code:
  * X"3A58",   -- mov4 RF(10) = 58(hex)
  * X"8A10",   -- and RF(10) = RF(10) and RF(1)
  * X"3163",	-- mov4 RF(1) = 63(hex) 
  * X"4A10",    -- add RF(10) = RF(10) + RF(1)
  * X"5A10",   -- sub RF(10) = RF(10) - RF(1)
  * X"7210",    --or RF(2) = RF(2) or RF(1)
  * X"2210",   -- mov3 M((rm==1)) = (rn==2)  
  * X"0264",   -- mov1 rf(2) = M (64(hex));   
  * X"1164",   -- mov2 M(64(hex)) = RF(1);  
  * X"6302",   --jz RF(3) 
  * X"9003",   --jmp rn =9  addr = 3 

## FSM state machine model of the controller:

![Capture](https://user-images.githubusercontent.com/81580234/151125168-e683a38e-489b-4e2a-8d62-3453b8f253ac.PNG)

## Our team
* Thanh V.Nguyen
* Tuyen M.Vu
