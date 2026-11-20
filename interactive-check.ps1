$ErrorActionPreference='Stop'
Add-Type -AssemblyName UIAutomationClient,UIAutomationTypes,WindowsBase
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class InputCheck {
[DllImport("user32",CharSet=CharSet.Unicode)] public static extern int GetWindowText(IntPtr h,System.Text.StringBuilder b,int n);
[DllImport("user32")] public static extern bool SetForegroundWindow(IntPtr h);
[DllImport("user32")] public static extern IntPtr GetForegroundWindow();
[DllImport("user32")] public static extern IntPtr SetThreadDpiAwarenessContext(IntPtr c);
[DllImport("user32")] public static extern bool SetCursorPos(int x,int y);
[DllImport("user32")] public static extern void mouse_event(uint f,uint x,uint y,uint d,UIntPtr e);
[DllImport("user32")] public static extern void keybd_event(byte k,byte s,uint f,UIntPtr e);
[DllImport("ntdll")] static extern int NtQueryInformationProcess(IntPtr h,int c,IntPtr[] b,int n,out int r);
[DllImport("kernel32")] static extern bool ReadProcessMemory(IntPtr h,IntPtr a,byte[] b,int n,out IntPtr r);
static byte[] Read(IntPtr h,long a,int n){var b=new byte[n];IntPtr r;if(!ReadProcessMemory(h,new IntPtr(a),b,n,out r))throw new Exception("ReadProcessMemory");return b;}
public static string Directory(IntPtr h){var b=new IntPtr[6];int r;if(NtQueryInformationProcess(h,0,b,48,out r)!=0)throw new Exception("query");long p=BitConverter.ToInt64(Read(h,b[1].ToInt64()+32,8),0);var u=Read(h,p+56,16);return System.Text.Encoding.Unicode.GetString(Read(h,BitConverter.ToInt64(u,8),BitConverter.ToUInt16(u,0)));}
}
"@
[void][InputCheck]::SetThreadDpiAwarenessContext(-4)
$dir=Join-Path $env:TEMP ("Mouse Test "+[guid]::NewGuid())
[void][IO.Directory]::CreateDirectory($dir)
$shell=New-Object -ComObject Shell.Application
Start-Process explorer.exe -ArgumentList ('/n,"'+$dir+'"')
Start-Sleep -Seconds 3
try {
for($i=0;$i -lt 35;$i++){Start-Sleep -Milliseconds 300
$w=@($shell.Windows()) | Where-Object {$_.Document.Folder.Self.Path -eq $dir} | Select-Object -First 1
if($w){break}}
if(!$w){throw 'Window missing'}

$hw=[InputCheck]::GetForegroundWindow()
$title=[Text.StringBuilder]::new(1024)
[void][InputCheck]::GetWindowText($hw,$title,1024)
"Foreground: $hw ($title), shell: $($w.HWND)"
if(!$title.ToString().Contains((Split-Path $dir -Leaf))){throw "Test tab is not foreground"}
function FocusView {
[void][InputCheck]::SetForegroundWindow($hw)
Start-Sleep -Milliseconds 700
$root=[Windows.Automation.AutomationElement]::FromHandle($hw)
$view=$root.FindFirst([Windows.Automation.TreeScope]::Descendants,[Windows.Automation.PropertyCondition]::new([Windows.Automation.AutomationElement]::ClassNameProperty,'UIItemsView'))
$r=$view.Current.BoundingRectangle
$x=[int]($r.Left+$r.Width*.68)
$y=[int]($r.Top+$r.Height*.72)
$hit=[Windows.Automation.AutomationElement]::FromPoint([Windows.Point]::new($x,$y))
if($hit.Current.ClassName -notin 'UIItemsView','UIGroupItem' -or [InputCheck]::GetForegroundWindow() -ne $hw){throw "Unexpected focus or hit: $($hit.Current.ClassName)"}
[void][InputCheck]::SetCursorPos($x,$y)
}
function DoubleClick {foreach($n in 1..2){[InputCheck]::mouse_event(2,0,0,0,0);[InputCheck]::mouse_event(4,0,0,0,0);Start-Sleep -Milliseconds 70}}
FocusView
$before=@(Get-Process cmd -ErrorAction SilentlyContinue).Id
[InputCheck]::keybd_event(17,0,0,0)
try {DoubleClick} finally {[InputCheck]::keybd_event(17,0,2,0)}
Start-Sleep -Seconds 2
$new=@(Get-Process cmd -ErrorAction SilentlyContinue | Where-Object {$_.Id -notin $before -and [InputCheck]::Directory($_.Handle).TrimEnd('\') -eq $dir})
"CMDs with expected directory: $($new.Count); Explorer location: $($w.Document.Folder.Self.Path)"
if($new.Count -ne 1 -or $w.Document.Folder.Self.Path -ne $dir){throw 'Ctrl double click failed'}
$new[0].Kill()
FocusView
DoubleClick
Start-Sleep -Seconds 1
if($w.Document.Folder.Self.Path -ne (Split-Path $dir)){throw 'ordinary double click failed'}
'PASS ordinary double click'
$w.Navigate2('shell:MyComputerFolder')
Start-Sleep -Seconds 1
if($w.Document.Folder.Self.Path -notmatch '20D04FE0'){throw 'This PC navigation failed'}
FocusView
$before=@(Get-Process cmd -ErrorAction SilentlyContinue).Id
[InputCheck]::keybd_event(17,0,0,0)
try {DoubleClick} finally {[InputCheck]::keybd_event(17,0,2,0)}
Start-Sleep -Seconds 1
if(@(Get-Process cmd -ErrorAction SilentlyContinue | Where-Object Id -notin $before).Count -or $w.Document.Folder.Self.Path -notmatch '20D04FE0'){throw 'This PC check failed'}
'PASS virtual folder'
} finally {;[IO.Directory]::Delete($dir)}
