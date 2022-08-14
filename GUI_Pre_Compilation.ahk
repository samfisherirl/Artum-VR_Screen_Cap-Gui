/*
	This example, while named Simple, is not the most simplistic example.
	Instead, it is designed to demonstrate all of Neutron's built in behavior
	as a single custom page. It is meant to be simple by comparison to other
	examples like the Bootstrap example which demonstrate extending Neutron's
	functionality with third party web frameworks.
*/

#NoEnv
SetBatchLines, -1

; Include the Neutron library
#Include ../../Neutron.ahk

; Create a new NeutronWindow and navigate to our HTML page
neutron := new NeutronWindow()
neutron.Load("Simple.html")

; Use the Gui method to set a custom label prefix for GUI events. This code is
; equivalent to the line `Gui, name:+LabelNeutron` for a normal GUI.
neutron.Gui("+LabelNeutron")


; Show the GUI, with an initial size of 800 x 600. Unlike with a normal GUI
; this size includes the title bar area, so the "client" area will be slightly
; shorter vertically than if you were to make this GUI the normal way.
neutron.Show("w800 h600")
SetTimer, DynamicContent, 5000
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


	msgboxer := neutron.qs("#myH2data").value
 
abc:=formData[1]
msgbox, reading DOM resolution field and displaying output : %out% %msgboxer% 
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

 