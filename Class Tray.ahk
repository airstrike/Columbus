Class Tray {
	__New() {
		this.fade := 65
		this.timeout := 6
		this.IsVisible := false
	}
	
	Tip(message, title := "") {
		this.title := title
		this.message := message
		if WinExist("ahk_id" this.hwnd)
			this.Destroy()
		Gui 7: +AlwaysOnTop +ToolWindow -SysMenu -Caption +Border hwndhwnd
		this.hwnd := hwnd
		Gui 7: Color, 0x464646
		Gui 7: Font, c0x999999 s16 wBold, Segoe UI
		if title
			Gui 7: Add, Text, % " x" 12 " y" 9, % title
		Gui 7: Font, cWhite s12 wRegular
		Gui 7: Add, Text, % " x" 12 " y" (title ? 45 : 9), % message
		Gui 7: Show, hide
		DetectHiddenWindows on
		WinGetPos,,, w, h, % "ahk_id" this.hwnd
		DetectHiddenWindows off
		Gui 7: Show, % "x" A_ScreenWidth - w - 20 " y" A_ScreenHeight - h - 50 " NoActivate hide"
		DllCall("AnimateWindow", "UInt", this.hwnd, "Int", this.fade, "UInt", "0x80000")
		Gui 7: Show, NoActivate
		SetTimer, NotifyDestroy, % this.timeout * 1000
		this.IsVisible := true
		return
		
		NotifyDestroy:
		SetTimer, NotifyDestroy, off
		Tray.Destroy()
		return
	}
	
	Destroy() {
		DllCall("AnimateWindow", "UInt", this.hwnd, "Int", this.fade, "UInt", "0x90000")
		Gui 7: Destroy
		this.IsVisible := false, this.title := "", this.message := "", this.fade := 65, this.timeout := 6
		return
	}
	
	SetTimeout(timeout) {
		return this.timeout := timeout
	}
	
	SetFade(fade) {
		return this.fade := fade
	}
	
	Click() {
		Tray.Destroy()
	}
}