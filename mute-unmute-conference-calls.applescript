-- An Applescript that mutes/unmutes Google Meet and Zoom meetings

-- get the currently active application so we can return focus to it
tell application "System Events"
	set frontApp to name of first application process whose frontmost is true
end tell

tell application "System Events"

	-- Google Meet
	if (exists (process "Google Chrome")) then
		tell application "Google Chrome"

			-- if there are multiple windows, find the one with the active tab that says "Meet - "
			-- this will fail if Meet is not the active tab, but that's fine. the alternative is
			-- searching through all tabs for "Meet - ". What if there are two or more? Blurgh.
			repeat with win in windows
				set activeTabTitle to title of active tab of win
				if activeTabTitle starts with "Meet - " then
					activate
					set index of win to 1

					-- Google meet's mute hotkey is ⌘+d
					tell application "System Events" to keystroke "d" using {command down}

					-- Give System Events a moment to pass the command to the application
					delay 0.1
					exit repeat
				end if
			end repeat
		end tell
	end if

	-- Zoom
	-- Notes:
	-- 1. You have to check for a window named Zoom Meeting, i.e., an active meeting.
	--    Otherwise, muting Zoom emits an error click.
	-- 2. The Zoom Meeting window does not need to be frontmost for to send the mute
	--    command. Zoom needs to be activate to receive the hotkey, but any window can
	--    be front most.
	-- 3. This would be easier if Zoom would release an AppleScript dictionary.

	if (exists (process "zoom.us")) then
		-- if Zoom is open, look for a Zoom Meeting window
		set foundZoomMeetingWindow to false
		repeat with theWindow in (every window of process "zoom.us")
			if (name of theWindow starts with "Zoom Meeting") then
				set foundZoomMeetingWindow to true
				exit repeat
			end if
		end repeat

		if foundZoomMeetingWindow then
			-- if a Zoom Meeting window was found, then tell the application to mute
			tell application "zoom.us" to activate
			delay 0.1
			-- Send keystroke to mute/unmute in Zoom
			keystroke "a" using {command down, shift down}
		end if
	end if
end tell

-- return focus to whatever was in front
tell application frontApp to activate