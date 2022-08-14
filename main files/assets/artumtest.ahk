#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir% 

 Doer()
 {
    jton := A_ScriptDir "\artum.json"
    Colon := ":"
ReturnJson:=[]
Loop, Read, %jton%
{
    if !InStr(A_LoopReadLine,"{")
    {
        if !InStr(A_LoopReadLine,"}")
        {
            jsonarray := StrSplit(A_LoopReadLine, Colon, ",") ; Omits periods.  
            A1:=jsonarray[1]
            B1:=jsonarray[2]
            ReturnJson[A_Index] := B1  
        }
        }
    }  
	return ReturnJson
 }