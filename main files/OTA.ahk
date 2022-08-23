#include JSON.ahk 
SetWorkingDir, %A_ScriptDir% 

global gh_repo = "artumino/VRScreenCap"
global file_to_download = "vr-screen-cap.exe"
global file_to_saving = "vr-screen-cap"


class OTA
{

    checkupd()
    {
        jsonStr := JSON.GetFromUrl("https://api.github.com/repos/" gh_repo "/releases/latest")
        if IsObject(jsonStr) 
        {
            MsgBox, % jsonStr[1]
            Return
        }
        if (jsonStr = "")
        Return
        obj := JSON.Parse(jsonStr)
        latest_tag := obj.tag_name
        change_log := obj.body
        if (version != latest_tag)
        {
            MsgBox, 68,, Re-downloading Artum VR Screen Cap for repair.`n`nLatest version: %latest_tag%`nChangelog:`n`n%change_log%`n`n`nDo you want to download?
            IfMsgBox, Yes 
                updater:=OTA.download(latest_tag)
        }
    }


    
    download(value)
    {
        global Logger
        global Logger1
        global DirLocal  
        download_url := "https://github.com/" gh_repo "/releases/download/" value "/" file_to_download 
        UrlDownloadToFile, %download_url%, %file_to_saving%-%value%.exe  
        FileCreateDir, %DirLocal%
        FileDelete, %Logger%
        FileAppend, 
(
%value%,
), %Logger1%
        FileMove, %Logger1%, %Logger%, 1
        FileMove, %file_to_saving%-%value%.exe, %file_to_download%, 1
        msgbox, Completed! 
    }


    currentvers()
    {
        global DirLocal
        global Logger
        if FileExist(Logger)
        {
        Loop, Read, %Logger%
            {   
                if (A_LoopReadLine="")
                    continue
                else
                {
                   A1:=StrSplit(A_LoopReadLine, ",") ;OTA.runcheck()
                   current:=A1[1]
                   OTA.runcheck(current)
                }
            }
        }
        else
            global updater := "never"
    }

    
    runcheck(version)
    { 
        jsonStr := JSON.GetFromUrl("https://api.github.com/repos/" gh_repo "/releases/latest")
        if IsObject(jsonStr) 
        {
            MsgBox, % jsonStr[1]
            Return
        }
        if (jsonStr = "")
        Return
        obj := JSON.Parse(jsonStr)
        latest_tag := obj.tag_name
        change_log := obj.body
        if (version != latest_tag)
        {
            MsgBox, 68,, A new version of Artum 'VR Screen Cap' is available.`n`nLatest version: %latest_tag%`nChangelog:`n`n%change_log%`n`n`nDo you want to download update?
            IfMsgBox, Yes
                OTA.download(latest_tag)
        }
        else
            {
                global updater:="no"
            } 
    }
}

