# Explorer Mouse Actions Plus

在 Windhawk 设置中添加鼠标规则。每条规则指定点击位置（空白处或文件项目）、修饰键、手势和动作。文件项目包括文件夹。动作作用于点击所在的标签页；现代 Explorer 仍会处理项目的原生点击。

默认双击空白处返回上一级，Ctrl + 双击空白处在当前目录打开 CMD。可以修改或关闭这两条规则，也可以添加 Shift + 双击打开 PowerShell、中键复制标签页等组合。相同条件取第一条启用的规则；如果同一位置和修饰键同时配置了单击、双击或三击，等待系统双击时间后执行匹配的最长手势。

“动作参数”可填写自定义快捷键（如 Ctrl+Shift+N）或文件夹背景菜单的名称或动词。CMD 和 PowerShell 需要文件系统目录；CMD 跳过 UNC 路径。

在 Windhawk 的“创建新模组”编辑器中导入 `explorer-mouse-actions-plus.wh.cpp` 并编译。使用支持 CLI 的 Windhawk 也可运行：

```powershell
D:\Windhawk\windhawk-cli.exe mod install --file .\explorer-mouse-actions-plus.wh.cpp
```

本项目由 momoca 维护，采用 GPL-3.0，沿用了 LiHua81 的 Explorer 钩子、命中检测及部分动作实现。[上游源码](https://github.com/ramensoftware/windhawk-mods/blob/main/mods/click-on-empty-explorer.wh.cpp)
