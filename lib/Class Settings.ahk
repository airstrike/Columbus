Class Settings {
	__New() {
		pos := WinGetPos("ahk_class Shell_TrayWnd")
		task := GetTaskbarPos(pos)
		win := [{X:A_ScreenWidth-502, Y:A_ScreenHeight-357-pos.H, Width:500, Height:355} ; bottom
			, {X:A_ScreenWidth-502, Y:A_ScreenHeight-357, Width:500, Height:355} ; left
			, {X:A_ScreenWidth-502-pos.W, Y:A_ScreenHeight-357, Width:500, Height:355} ; right
			, {X:A_ScreenWidth-502, Y:A_ScreenHeight-357, Width:500, Height:355}] ; top
		for a, b in this.default := {   Hotkeys: 			{Main:"^!P", Fokus:"^!O"}
								, StartUp: 			true
								, UpdateCheck: 		true
								, Debug: 				false
								, ScanTime:			5
								, FreqSort:			true
								, Verify:				false
								, Prefix:				(A_ComputerName = "DARKNIGHT-PC" ? "." : "/")
								, UpdateExt: 			FileExt(A_ScriptFullPath)
								, LastUpdatePrompt: 	0
								, List:				"items"
								, Fade:				65
								, Rows:				11
								, RowSnap:			true
								, LargeIcons:			true 
								, Font:				{Type:"Candara", Size:13, Bold:false}
								, Color:				"3A3A3A"
								, Pos:				win[task]}
		{
			if IsObject(b) {
				for z, x in b
					if (xml.ea("//settings/" a)[z] = "") ; if attribute is empty, make it default
						xml.add("settings/" a).SetAttribute(z, x)
			} else if !xml.ssn("//settings/" a) ; if node doesn't exist, make it default
				xml.add("settings/" a).text := b
		}
	}
	
	action(key, value) {
		if (key = "StartUp") {
			if value
				RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run, Columbus, % A_ScriptFullPath
			else
				RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run, Columbus
		} if (key = "FreqSort")
			Items.FreqSort := value
		else if (key = "ScanTime")
			SetTimer, ScanTimer, % value * 1000
		else if (key = "List")
			ItemList.Lists[value].Refresh(), Main.SetText()
		else if (key = "Prefix") {
			if (value.length > 1)
				m("Prefix cannot be longer than 1 character.`n`nResetting Prefix to ""/"""), Settings.Prefix := "/"
		} else if (key = "Rows") {
			if value > 0
				Main.SetRows(value)
			else
				m("Value invalid: " value "`nKey: " key)
		}
	}
	
	__Get(key := "") {
		if key {
			if NumGet(&(g := xml.ea("//settings/" key)), 4*A_PtrSize)
				return g
			return xml.ssn("//settings/" key).text
		} for a, b in this.default ; Settings[] print thingy
			t := xml.ssn("//settings/" a), x .= "[" a "]" (t.text <> "" ? " => " t.text: "") . (NumGet(&(g := xml.ea(t)), 4*A_PtrSize) ? "`n" pa(g,, "   ") : "") . "`n"
		return x
	}
	
	__Set(key, value) {
		if (this.default[key] <> "") && (key <> "default") {
			if IsObject(value)
				X := xml.add("settings/" key, value)
			else
				x := xml.add("settings/" key).text := value
			this.action(key, value)
			return x
		}
	}
}