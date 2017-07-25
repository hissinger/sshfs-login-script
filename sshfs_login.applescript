set username to "esahn" as string
set hostname to "127.0.0.1" as string
set portnumber to "6000" as string
set volname to "next-dev"

set mount_folder to POSIX file "/Volumes" & ":" & volname as string
set mount_opt to "-oauto_cache,reconnect,defer_permissions,noappledouble,password_stdin,volname=" & volname as string

tell application "Finder"
	
	activate
	
	if not (exists disk volname) then
		
		display dialog "Enter Password" default answer "" buttons {"Cancel", "OK"} cancel button "Cancel" default button "OK" with hidden answer
		if button returned of result = "OK" then
			set passwd to the text returned of result
			
			if passwd is "" then
				quit
			end if
			
			if not (exists folder mount_folder) then
				do shell script "/bin/mkdir " & POSIX path of mount_folder
			end if
			
			try
				do shell script "/bin/echo " & passwd & " | /usr/local/bin/sshfs -p " & portnumber & " " & username & "@" & hostname & ": " & POSIX path of mount_folder & " " & mount_opt
			on error
				
				set mountedVolumes to do shell script "/sbin/mount"
				if (mountedVolumes contains POSIX path of mount_folder) then
					do shell script "/sbin/umount " & POSIX path of mount_folder
				end if
				
				display dialog "mount: " & volname & " Fail" buttons {"OK"} default button "OK" with icon 1
				
			end try
			
		end if
		
	else
		
		display dialog "mount: " & volname & " is already mounted" buttons {"OK"} with icon 1
	end if
end tell
