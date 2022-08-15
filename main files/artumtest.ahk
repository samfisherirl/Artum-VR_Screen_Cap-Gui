#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir% 

Doer()
{ 
    global jton
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

Writeupdate(func,values)
{
    global jton
    global replace 
    Colon := ":"
    Comma:=","
    if instr("y_curvature",func)
    {
        Comma:=""
    } 
    Loop, Read, %jton%
    { 
        jsonarray := StrSplit(A_LoopReadLine, Colon) 
        dis:="distance"
        A1:=jsonarray[1] 
        if instr(A1,dis)
        {
            if instr(A1,func)
            { 
                NewJson=
                ( 
{
     "%func%": %values%%Comma%
) 
                    continue
            }

                else 
                    {
                        NewJson=
(
{
%A_LoopReadLine%
)
continue
                        }
                    }

                    if instr(A1,func) 
                    {
                        NewJson=
(
%NewJson%
     "%func%": %values%%Comma%
)
                        continue
                    }

                else
                {
                    NewJson=
( 
%NewJson%
%A_LoopReadLine%
)
                }
            } 
            filedelete, %replace%
            FileAppend, %NewJson%, %replace%
            FileMove, %replace%, %jton%, 1
        }


RunBat()
{
    LauncherBat:= A_ScriptDir "\vr.bat"
    FileDelete, %LauncherBat%
    FileAppend,
(
@echo off
start "" "%A_ScriptDir%\vr-screen-cap.exe" --config-file="%A_ScriptDir%\artum.json"
timeout /t 2
), %LauncherBat%
}