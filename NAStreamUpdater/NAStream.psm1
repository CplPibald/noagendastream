<# 
 .Synopsis
  Polls RSS feeds for inclusion in the No Agenda stream
  Version 2.0 implementation using podcastindex.org

 .Description
  Exports a function Get-NewPodcasts which will poll the RSS feeds for several podcasts.  When it finds a new
  episode, it displays the download URL and the metadata formatted for the No Agenda stream

 .Example
   # Poll all podcasts for updates
   Get-NewPodcasts

#>
# Root location for module stored data
$SCRIPT:configDir = $PSScriptRoot

# Path to file containing latest episode timestamps
$SCRIPT:latestDataFile = join-path $configDir 'latestTimestamps.txt'

. (join-path $PSScriptRoot 'Shows.ps1')
. (join-path $PSScriptRoot 'podcastindex.ps1')

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Get-NewPodcasts {

    param(
        [string]$filter = $null,
        [switch]$download,
        [switch]$debug,
        [switch]$batch
    )

    if ($debug) { $DebugPreference = 'SilentlyContinue' }
    
    "======================================"
    "New podcast report for $(Get-Date)"
    ""
    
    loadLatest

    foreach($show in $shows) {

        if ($show.name -notmatch $filter) { continue; }
        if ($show.disabled) { continue; }

        $lastTimestamp = [int]$SCRIPT:latestTimestamps[$show.id]
        if ($debug) { $lastTimestamp = 0 }

        $latest = Get-LatestPodcastEpisode -id $show.id -since $lastTimestamp

        if ($latest) {

            $title = $latest.title
            $link = $latest.enclosureUrl

            $datePublished = [DateTimeOffset]::FromUnixTimeSeconds($latest.datePublished).DateTime
            $dateText = $datePublished.ToString('ddd, dd MMM yyyy')

            if ($show.parse) {
                $showNumber, $showTitle = & $show.parse
            } else {
                $showNumber, $showTitle = $latest.episode, $latest.title
            }

            # silly podcasters using MS Word to corrupt their show titles
            $showTitle = $showTitle -replace '–','-' -replace "’", "'" -replace '”', '"'

            if ($showNumber) {
                $headline = '{0} #{1}: "{2}" - {3} - {4}' -f $show.name, $showNumber, $showTitle, $dateText, $show.tagline
            } else {
                $headline = '{0}: "{1}" - {2} - {3}' -f $show.name, $showTitle, $dateText, $show.tagline
            }
            if ($batch) {
                $fname = if ($showNumber) { $showNumber } else { $datePublished.ToString('yyyyMMdd') }
                $folder = ($show.name -replace '\W','').ToLower()
                Write-Host ("{0}/{1}.mp3" -f $folder, $fname) -ForegroundColor Yellow
                $headline
                $link
            } else {
                # Pretty output
                Write-Host "New episode for $($show.name):" -ForegroundColor Yellow
                $headline
                $link
                ""
            }
            
            $SCRIPT:latestTimestamps[$show.id] = $latest.datePublished

        } else {
            if (-not $batch) {
                Write-Host "No new episodes for $($show.name)" -ForegroundColor Gray
                ""
            }
        }
    }
    ""

    # Debug runs are repeatable, so don't save them
    if (-not $debug) { saveLatest }
}

function loadLatest {
    $SCRIPT:latestTimestamps = @{}
    if (test-path $SCRIPT:latestDataFile) {
        gc $latestDataFile | % {
            $id, $num = $_ -split '='
            $SCRIPT:latestTimestamps[[int]$id] = [int]$num
        }
    }
}

function saveLatest {
    $SCRIPT:latestTimestamps.GetEnumerator() | % {
        "{0}={1}" -f $_.Key, $_.Value
    } | Out-File $SCRIPT:latestDataFile

}

Export-ModuleMember Get-NewPodcasts
Export-ModuleMember Find-Podcast
Export-ModuleMember Get-LatestPodcastEpisode
Export-ModuleMember Call-Podcastindex
