# AXI4 Interconnect

可配置 AXI4 interconnect RTL 生成与验证工程。

## 当前内容

- `CodeGen.exe`：当前发布版配置工具，等同于 `tools/CodeGen.exe` 和 `bin/CodeGen.exe`。
- `rtl/`：由当前配置工具生成的一组可综合 RTL 示例。
- 根目录 `axi_interconnect*.v`：保留与旧仓库兼容的扁平 RTL 文件。
- `rtl_templates/`：CodeGen 使用的 RTL 模板源文件。
- `CodeGenV/`：CodeGen.exe 的 C# 源码工程。
- `verify/`：ModelSim 仿真回归脚本和定向用例。
- `board/`：XDMA/上板冒烟测试辅助脚本。
- `docs/`：需求规格、概要设计、详细设计、验证方案和验证报告。

## RTL 功能

- 支持每个 AXI4 slave/master 接口独立配置 ADDR/ID/DATA 位宽。
- 支持 N 个 slave 到 M 个 master 的地址译码与路由。
- 支持接口侧数据位宽转换，包括 `DN > DM`、`DN = DM`、`DN < DM`。
- 支持 slave/master 接口独立时钟域，通过异步 FIFO 做 CDC。
- 当前版本不支持乱序返回。

## 使用 CodeGen.exe

GUI 模式：

```powershell
.\CodeGen.exe
```

批处理示例：

```powershell
.\CodeGen.exe --batch --out .\generated --slaves 1 --masters 1 `
  --s-addr 32 --s-id 4 --s-data 256 `
  --m-addr 32 --m-id 4 --m-data 512 `
  --s-clock 0 --m-clock 1 `
  --m-base 0x00000000 --m-high 0x0fffffff
```

安装到其他电脑通常需要：

- Windows。
- .NET Framework 4.7.2 或更高版本。
- `CodeGen.exe`。
- 与 exe 同目录的 `rtl_templates/`，如果需要从模板重新生成 RTL。仓库中 `bin/CodeGen.exe` 与 `bin/rtl_templates/` 已配套放置。

## 仿真验证

运行完整回归：

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\verify\run_regression.ps1
```

验证依赖：

- ModelSim 10.5，默认路径 `E:\Modelsim_10_5\win64\vsim.exe`。
- Python，默认优先使用 `E:\python\python.exe`，不存在时使用 PATH 中的 `python`。

当前回归包含 GitHub issue #1 定向场景：`1S/1M`、S_DATA=256、M_DATA=512、250MHz/200MHz 独立时钟，并使用满足 AXI4 4KB 边界的最大合法写突发 `AWLEN=127`。

## 最近验证结果

本地最新完整回归：

- 日期：2026-08-19
- 日志：`verify_out\regression_20260819_1425.log`
- 结果：全部用例 `Errors: 0, Warnings: 0`

`verify_out/` 为本地仿真输出目录，不提交到仓库。
