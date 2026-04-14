;@Ahk2Exe-SetMainIcon Right_Click_Scroll.ico
;@Ahk2Exe-SetDescription Right Click Scroll
;@Ahk2Exe-SetVersion 1.1.0
;@Ahk2Exe-SetProductName Right Click Scroll
;@Ahk2Exe-SetProductVersion 1.1.0
;@Ahk2Exe-SetCompanyName ArtLife Software
;@Ahk2Exe-SetCopyright © 2026 林彥丞
;@Ahk2Exe-SetLanguage 0x0404

; ==============================================================================
; Right Click Scroll
; 版本1.1.0
; 1.1.0版 2026/04/14
; 1.0.0版 2026/04/10
; 初建 2026/04/10
;
; 正體中文版
; 開源軟體　GPL-3.0 license
;
; 由林彥丞設計
; lin.yancheng@outlook.com
; https://github.com/ArtLife-Software
; 中華民國台灣
;
; 基於 AutoHotkey 2.0.23 創建
; 以 Windows 10 測試通過
; ==============================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force      ; 重複執行時自動覆蓋，不跳警告
SetWorkingDir(A_ScriptDir)  ; 確保腳本在正確的路徑執行

if !A_IsAdmin {
    try {
        Run('*RunAs "' A_ScriptFullPath '"')
    }
    ExitApp()
}

; --- 設定區 ---
ScrollSensitivity := 0.8
ScrollThreshold := 5

RButton:: {
    MouseGetPos(&startX, &startY)
    isScrolling := false
    
    while GetKeyState("RButton", "P") {
        MouseGetPos(&curX, &curY)
        deltaX := curX - startX
        deltaY := curY - startY
        
        ; 只要任一方向移動超過門檻，就進入捲動模式
        if (!isScrolling && (Abs(deltaX) > ScrollThreshold || Abs(deltaY) > ScrollThreshold)) {
            isScrolling := true
        }
        
        if (isScrolling) {
            multiplier := GetKeyState("LButton", "P") ? 2.5 : 1
            
            ; --- 處理垂直捲動 (Y軸) ---
            if (Abs(deltaY) > 10) {
                scrollCountY := Round((Abs(deltaY) / 10) * ScrollSensitivity * multiplier)
                Loop (scrollCountY || 1) {
                    Send(deltaY > 0 ? "{Blind}{WheelDown}" : "{Blind}{WheelUp}")
                }
                startY := curY ; 更新 Y 起點
            }
            
            ; --- 處理水平捲動 (X軸) ---
            if (Abs(deltaX) > 10) {
                scrollCountX := Round((Abs(deltaX) / 10) * ScrollSensitivity * multiplier)
                Loop (scrollCountX || 1) {
                    ; WheelLeft 和 WheelRight 是系統標準的水平捲動訊號
                    Send(deltaX > 0 ? "{Blind}{WheelRight}" : "{Blind}{WheelLeft}")
                }
                startX := curX ; 更新 X 起點
            }
        }
        Sleep(10)
    }
    
    if (!isScrolling && !GetKeyState("LButton", "P")) {
        Click("Right")
    }
}