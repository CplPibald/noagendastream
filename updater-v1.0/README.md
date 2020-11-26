No Agenda Stream RSS reader v1.0

Usage: 
    Import-Module NAStream
    Get-NewPodcasts [-filter "regex"]

Retrieves RSS feeds listed in shows.ps1, and checks if there is a new episode since
last time script was run.  If so, outputs a noagendastream-formatted metadata tag, 
followed by download URL.  If -filter parameter is passed, only shows that match
will be checked.

Requires PowerShell v5.0 or better