# Explorer Mouse Actions Plus

Double-click empty space to go to the parent folder. Ctrl + double-click empty space to open CMD in the current tab's folder. Both defaults are editable entries under **Mouse rules**.

Each rule combines a gesture, a modifier and a target with an action. For example, assign Shift + double-click on empty space to Windows PowerShell, and the same gesture on an item to Refresh. The first enabled rule with matching conditions wins. When several click counts share a binding, the mod waits up to the system double-click interval for the longer gesture.

**Why a separate mod?** This GPL-3.0 fork reuses Explorer integration and actions from LiHua81's [Click on Empty Explorer](https://github.com/ramensoftware/windhawk-mods/blob/main/mods/click-on-empty-explorer.wh.cpp). Its settings are an ordered list that users can extend, including modifier combinations with double, triple and middle clicks. Maintaining this schema separately lets users choose it while existing upstream configurations keep their meaning.

**Choosing a target.** An item rule matches a file or folder under the pointer. Folder actions use the tab's directory when the action runs. In modern Explorer a folder double-click can also navigate, so the directory may already have changed. Use an empty-space rule when the directory matters. Classic list views can consume matched double or middle clicks. New, duplicate and close tab require Windows 11. CMD and PowerShell skip virtual locations; CMD also skips UNC paths.

**Action argument.** Enter a key combination such as Ctrl+Shift+N for Custom hotkey, or a menu label or verb for Folder background menu entry. Open in VS Code also accepts a menu label or verb. Set it explicitly if the default match for “Code” selects another entry.

## 简体中文

默认双击空白处返回上一级，Ctrl + 双击空白处在当前标签页目录打开 CMD。这两项都可以在“鼠标规则”里修改、禁用或删除。

每条规则可指定手势、修饰键、点击位置和动作。例如，同样是 Shift + 双击，点空白处可以打开 PowerShell，点文件项目可以刷新。条件相同时，第一条启用的规则生效。若同一组合配置了不同连击次数，模组会按系统双击间隔等待更长的手势。

本项目沿用 LiHua81 的 Explorer 集成和部分动作，以 GPL-3.0 发布。独立维护可增删、可排序的规则列表，让用户按位置和组合键扩展手势，也保留上游已有配置的含义。

文件项目包括文件和文件夹。目录动作使用执行时的标签页路径。现代 Explorer 双击文件夹时也会导航，动作可能读取到进入后的目录；需要准确使用当前目录时，请绑定空白处。经典列表视图可能接管匹配的双击或中键操作。新建、复制和关闭标签页需要 Windows 11。CMD 和 PowerShell 会跳过虚拟目录，CMD 还会跳过 UNC 路径。

“动作参数”可填写自定义快捷键（如 Ctrl+Shift+N），或文件夹背景菜单项的名称或动词。“在 VS Code 中打开”也支持指定菜单项，避免默认的 Code 匹配到其他条目。
