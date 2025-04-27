优化了源码的多个小问题，
包括语法和功能上的
'''
project/
 ├── hdl/
 │     ├── axi2spi_bridge.v
 │     ├── spi_controller.v
 │     └── ...
 ├── tb/
 │     ├── test_bench.v
 │     └── eeprom_model/
 │          ├── M95XXX.v
 │          └── ...
 ├── rundir/    <== 仿真中间结果
 │     ├── work/    (ModelSim的编译库)
 │     ├── dump.vcd
 │     ├── transcript
 │     └── ...
 ├── wave.do
 └── sim.tcl   (你的脚本)
'''
那么 cd rundir 的意义就是：

保证你的 vlog, vsim, vcd file, run 等全部在 rundir/ 下运行，

不会污染你的 hdl/ 或 tb/ 文件夹，

让工程目录清爽又专业。
工程的结构：
'''
sys_clk + rst_n
    ↓
AXI Master 信号 (你手动模拟的)
    ↓
axi2spi_bridge (DUT)
    ↓ SPI线 (sclk, mosi, miso, spi_select)
M95xxx EEPROM 模型
'''
你通过 AXI 总线去驱动 axi2spi_bridge

axi2spi_bridge内部发SPI

SPI信号连到了M95xxx_Memory.v（通过M95xxx_Macro_mux.v选定AC时序）
🛠 QuestaSim 加载你的 AXI-SPI 工程步骤
1. 打开 QuestaSim
启动 vsim。一般是桌面上有个 QuestaSim 图标，或者你在终端里输入：
'''
vsim &

'''
如果你用的是 Windows，直接点击图标就行了。

2. 打开正确的工作路径
你的脚本和 wave.do 在 ./rundir 目录里，所以我们要切换到这个目录。
在 QuestaSim 的 Transcript窗口（底部那个黑框）里输入：
'''
cd "C:/Users/你的用户名/Downloads/AXI2SPI_verilog-master/rundir"
'''
3. 加载脚本（一次执行全部流程）
你的工程已经写好一个总脚本叫
mentor_compile.tcl，所以直接执行它即可。

在 Transcript 里输入：

do mentor_compile.tcl
这一步通常会：

vlog 编译 Verilog源代码

vsim 仿真启动 simulation_top

加载 wave.do，打开波形


![image](https://github.com/user-attachments/assets/91768759-2db0-4e04-b959-c6c26a13ea53)


源项目：
# AXI2SPI-bridge
Homework for Rendszerarchitekturak with Feher Béla &amp; Wacha Gabor :) 

Please read specification.txt
