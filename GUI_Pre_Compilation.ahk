﻿/*
	This example, while named Simple, is not the most simplistic example.
	Instead, it is designed to demonstrate all of Neutron's built in behavior
	as a single custom page. It is meant to be simple by comparison to other
	examples like the Bootstrap example which demonstrate extending Neutron's
	functionality with third party web frameworks.
*/

#NoEnv
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1

; Include the Neutron library
#Include Neutron.ahk
#Include artumtest.ahk
global jton := A_ScriptDir "\artum.json"
global replace := A_ScriptDir "\replace.txt"
; Create a new NeutronWindow and navigate to our HTML page
neutron := new NeutronWindow()
neutron.Load("Simple.html")

FileInstall, bootstrap.min.css, bootstrap.min.css
FileInstall, jquery.min.js, jquery.min.js
FileInstall, bootstrap.min.js, bootstrap.min.js 
FileInstall, Untitled-3.png, Untitled-3.png
; Use the Gui method to set a custom label prefix for GUI events. This code is
; equivalent to the line `Gui, name:+LabelNeutron` for a normal GUI.
neutron.Gui("+LabelNeutron")
RunBat()
LoadJson()
; Show the GUI, with an initial size of 800 x 600. Unlike with a normal GUI
; this size includes the title bar area, so the "client" area will be slightly
; shorter vertically than if you were to make this GUI the normal way.
neutron.Show("w800 h800")
SetTimer, DynamicContent, 1000
return

; FileInstall all your dependencies, but put the FileInstall lines somewhere
; they won't ever be reached. Right below your AutoExecute section is a great
; location!
FileInstall, Simple.html, Simple.html 

; The built in GuiClose, GuiEscape, and  BrowseButton()GuiDropFiles event handlers will work
; with Neutron GUIs. Using them is the current best practice for handling these
; types of events. Here, we're using the name NeutronClose because the GUI was
; given a custom label prefix up in the auto-execute section.
NeutronClose:
ExitApp
return

DynamicContent()
{
    global neutron
	sleep, 100
	ReturnJson:=[]
    ReturnJson:=Doer()
	
    x:=ReturnJson[4]
    x:=x * 10
    y:=ReturnJson[5]
    y:=y * 10
    Dist:=ReturnJson[2]
    Scale:=ReturnJson[3] 


    DistCheck := neutron.qs("#dist").value
    scaleCheck := neutron.qs("#scale").value
    xCheck := neutron.qs("#x").value
    yCheck := neutron.qs("#y").value
	x:=Ceil(x)
	y:=Ceil(y)
	Dist:=Ceil(Dist)
	Scale:=Ceil(Scale)
 
	if (Dist!=DistCheck)
	{
		func:="distance" 
		values:=DistCheck
		values:=values ".0"
		Writeupdate(func,values)
		goto, done
	}
	if (Scale!=scaleCheck)
	{
		func:="scale"
		values:=scaleCheck
		values:=values ".0"
		Writeupdate(func,values)
		goto, done
	}
	if (x!=xCheck)
	{

		func:="x_curvature"
		values:=xCheck
		values:=values / 10
		values:=Round(values, 1)
		Writeupdate(func,values)
		goto, done
	}
	if (y!=yCheck)
	{

		func:="y_curvature"
		values:=yCheck
		values:=values / 10
		values:=Round(values, 1)
		Writeupdate(func,values)
		goto, done
	}
	done: 
	sleep, 100
}

LoadJson()
{  
    global neutron
    ReturnJson:=Doer()
 
    x:=ReturnJson[4]
    x:=x * 10
    y:=ReturnJson[5]
    y:=y * 10
    Dist:=ReturnJson[2]
    Scale:=ReturnJson[3] 
	;Trim(Scale) 
	;Round(Scale) 
	x:=Ceil(x)
	y:=Ceil(y)
	Dist:=Ceil(Dist)
	Scale:=Ceil(Scale)

	neutron.qs("#x").value:=x
	neutron.qs("#y").value:=y
	neutron.qs("#dist").value:=Dist
	neutron.qs("#scale").value:=Scale 
}

; --- Trigger AHK by page events ---

Example1_Button(neutron, event)
{
    ; event.target will contain the HTML Element that fired the event.
    ; Show a message box with its inner text.
    MsgBox, % "You clicked: " event.target.innerText
}

Example1_MouseMove(neutron, event)
{
    ; Some events, like MouseMove, have custom attributes that can be read.
    ; offsetX and offsetY contain the mouse position relative to the event that
    ; fired the event.
    event.target.innerText := Format("({:i}, {:i})", event.offsetX, event.offsetY)
}

Example1_MouseLeave(neutron, event)
{
    ; Reset the text of the MouseMove example when the mouse is no longer over
    ; it.
    event.target.innerText := "Mouse over this area!"
}

; --- Update page by Hotkey ---

; Limit this hotkey to only fire while our Neutron window is the active window.
#if WinActive("ahk_id" neutron.hWnd)

~1::UpdateKeyExample(neutron, "1", "active")
~2::UpdateKeyExample(neutron, "2", "active")
~3::UpdateKeyExample(neutron, "3", "active")
~4::UpdateKeyExample(neutron, "4", "active")
~1 Up::UpdateKeyExample(neutron, "1", "")
~2 Up::UpdateKeyExample(neutron, "2", "")
~3 Up::UpdateKeyExample(neutron, "3", "")
~4 Up::UpdateKeyExample(neutron, "4", "")

UpdateKeyExample(neutron, keyName, className) {
    ; Use the JavaScript function document.querySelectorAll to find elements
    ; based on a CSS selector.
    keyDivs := neutron.doc.querySelectorAll(".keys > div")

    ; Use Neutron's .Each() method to iterate through the HTMLCollection in a
    ; for loop.
    for i, div in neutron.Each(keyDivs)
    {
        ; Check if the div's innerText matches the key that was pressed
        if (div.innerText == keyName)
        {
            ; Update the div's className property to change its style on the fly
            div.className := className
        }
    }
}

#if

; --- Pass form data to AHK ---

Submit(neutron, event)
{
    ; Some events have a default action that needs to be prevented. A form will
    ; redirect the page by default, but we want to handle the form data ourself.
    event.preventDefault()

    ; Use Neutron's GetFormData method to process the form data into a form that
    ; is easily accessed. Fields that have a 'name' attribute will be keyed by
    ; that, or if they don't they'll be keyed by their 'id' attribute.
    formData := neutron.GetFormData(event.target)

    ; You can access all of the form fields by iterating over the FormData
    ; object. It will go through them in the order they appear in the HTML.
    out := "Access all fields by iterating:`n"
    for name, value in formData
        out .= name ": " value "`n"
    out .= "`n"

    ; You can also get field values by name directly. Use object dot notation
    ; with the field name/id.
    out .= "Or access individual fields directly:`n"
    out .= "Hello " formData.firstName " " formData.lastName "!`n"
    if formData.remember
        out .= ""
    else
        out .= "You forgot to check the 'Remember Me' box :("

    ; Show the output
    MsgBox, %out%
}

Launch(neutron, event)
{
    run, vr.bat, %A_ScriptDir%
}


; --- Dynamic Content Generation ---

Ex4_Submit1(neutron, event)
{
    event.preventDefault()
    formData := neutron.GetFormData(event.target)

    ; Generate the HTML we're going to add to the page. To do this, we use the
    ; FormatHTML static method, which will run the values through an HTML escape
    ; function before passing them on to the AHK Format function. This will
    ; take care of any special sequences such as angle brackets or quotes that
    ; exist in the data and keep them from breaking the page.
    html := neutron.FormatHTML("<tr><td>{}</td><td>{}</td>", formData.ex4_item1, formData.ex4_cost1)

    ; Add our HTML to the page, as part of the table body. To do this, we'll be
    ; using the element.insertAdjacentHTML function. However, if we wanted to
    ; replace the body contents instead of adding to them, we could instead use
    ; `.innerHTML := html`.
    ;
    ; Read more about element.insertAjacentHTML here:
    ; https://developer.mozilla.org/en-US/docs/Web/API/Element/insertAdjacentHTML
    neutron.qs("#ex4_table1>tbody").insertAdjacentHTML("beforeend", html)
}

Ex4_Submit2(neutron, event)
{
    event.preventDefault()
    formData := neutron.GetFormData(event.target)

    ; Create the row element to add cells to
    tr := neutron.doc.createElement("tr")

    ; Create the first column cell and add it to the row
    td := neutron.doc.createElement("td")
    td.innerText := formData.ex4_item2
    tr.appendChild(td)

    ; Create the second column cell and add it to the row
    td := neutron.doc.createElement("td")
    td.innerText := formData.ex4_cost2
    tr.appendChild(td)

    ; Add the row to the table
    neutron.qs("#ex4_table2>tbody").appendChild(tr)
}