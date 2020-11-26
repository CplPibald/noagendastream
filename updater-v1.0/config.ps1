<#
 Configuration for NAStream module
#>

# Root location for module stored data
$SCRIPT:configDir = $PSScriptRoot

# Path to stored episode numbers
$SCRIPT:latestDataFile = join-path $configDir 'latestEpisodes.txt'

