
# Initialize configuration and $shows list
. (join-path $PSScriptRoot 'config.ps1')
. (join-path $PSScriptRoot 'Shows.ps1')

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

<# 
 .Synopsis
  Polls RSS feeds for inclusion in the No Agenda stream

 .Description
  Exports a function Get-NewPodcasts which will poll the RSS feeds for several podcasts.  When it finds a new
  episode, it displays the download URL and the metadata formatted for the No Agenda stream

 .Example
   # Poll all podcasts for updates
   Get-NewPodcasts

#>
function Get-NewPodcasts {

    param(
        [string]$filter = $null,
        [switch]$download,
        [switch]$debug
    )

    if ($debug) { $DebugPreference = 'SilentlyContinue' }
    
    "======================================"
    "New podcast report for $(Get-Date)"
    ""
    
    loadLatest

    foreach($show in $shows) {

        if ($show.name -notmatch $filter) { continue; }
        if ($show.disabled) { continue; }
    
        try {

        $page = Invoke-WebRequest $show.rssUri
        $xml = [xml]($page.content)
        $feed = $xml.rss.channel
        $latest = $feed.item[0]

        # The xml parser is picking up Apple's new proprietary <itunes:title> tag, which is turning the title into an array...
        $rssTitle = $latest.title | select -First 1
        Write-Debug "rssTitle = '$rssTitle'"

        $link = $latest.enclosure.url
        Write-Debug "link = '$link'"
        $pubDate = if ($show.containsKey('parseDate')) {
            (&$show.parseDate $latest.pubDate).toString('ddd, dd MMM yyyy')
        } else {
            ([datetime]$latest.pubDate).toString('ddd, dd MMM yyyy')
        }

        if ($show.parse) {
            $showNumber, $showTitle = & $show.parse
        } else {
            $showNumber = $latest.episode
            $showTitle = $latest.GetElementsByTagName('itunes:title')[0].'#text'
        }

        # silly podcasters using MS Word to corrupt their show titles grumble grumble
        $showTitle = $showTitle -replace '–','-' -replace "’", "'" -replace '”', '"'

        if ([int]$showNumber -gt $SCRIPT:latestEpisodes[$show.name]) {

            Write-Host "New episode for $($show.name):" -ForegroundColor Yellow
            '{0} #{1}: "{2}" - {3} - {4}' -f $show.name, $showNumber, $showTitle, $pubDate, $show.tagline
            $link
            ""
            
            $SCRIPT:latestEpisodes[$show.name] = $showNumber

        } else {
            Write-Host "No new episodes for $($show.name). Latest = $($SCRIPT:latestEpisodes[$show.name]); Current = $showNumber" -ForegroundColor Gray
            ""
        }

        } catch [Exception] {
            Write-Host "Error reading RSS for $($show.name)" -ForegroundColor Red
            write-host $_.Exception.GetType().FullName; 
            write-host $_.Exception.Message; 
        }
    }
    saveLatest
}

function loadLatest {
    $SCRIPT:latestEpisodes = @{}
    if (test-path $SCRIPT:latestDataFile) {
        gc $latestDataFile | % {
            $title, $num = $_ -split '='
            $SCRIPT:latestEpisodes[$title] = $num
        }
    }
}

function saveLatest {
    $SCRIPT:latestEpisodes.GetEnumerator() | % {
        "{0}={1}" -f $_.Key, $_.Value
    } | Out-File $SCRIPT:latestDataFile

}

Export-ModuleMember Get-NewPodcasts
