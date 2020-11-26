<#
Contains functions specific to calling a podcastindex.org API.  For API details, see
    https://podcastindex-org.github.io/docs-api/
#>

$SCRIPT:ApiBase = 'https://api.podcastindex.org/api/1.0/'

# secrets.ps1 must set the following three script variables: UserAgent, ApiKey, ApiSecret
. (join-path $PSScriptRoot 'secrets.ps1')

Add-Type -AssemblyName System.Web

<#
.SYNOPSIS
Gets data for most recent episode of a podcast

.DESCRIPTION
Returns info from podcastindex.org on the latest episode of podcast with given ID,
as long as the episode is later than -since parameter

.PARAMETER id
podcastindex feed ID.  Usually found using Find-Podcast function

.PARAMETER since
Optional
If provided, function returns $null if latest episode is at or before this timestamp
(unix time = seconds since 1970-01-01Z)
#>
function Get-NewestEpisode ([int]$id, [int]$since = 0) {
    $callUri = "episodes/byfeedid?id=$id&since=$since&max=1"
    $response = Call-Podcastindex $callUri
    if ($response.count -gt 0) { $response.items[0] }
}

<#
.SYNOPSIS
Searches podcastindex for feeds matching given search query

.DESCRIPTION
Returns podcastindex ID, author, title, and feed URL for any feeds that match the search terms

.PARAMETER terms
List of keywords to search on podcastindex.  Space-delimited
#>
function Find-Podcast ([string]$terms) {

    $callUri = "search/byterm?q=" + [System.Web.HTTPUtility]::UrlEncode($terms)
    $response = Call-Podcastindex $callUri
    ($response.feeds) | Select-Object -Property id,author,title,url
}

#######
# Internal functions below
#

function Call-Podcastindex ([string] $endpoint) {
    $unixDate = [string][int](Get-Date -date ([datetime]::UtcNow) -UFormat %s)
    $headers = @{
        'User-Agent' = $SCRIPT:UserAgent;
        'X-Auth-Date' = $unixDate;
        'X-Auth-Key' = $SCRIPT:ApiKey
        'Authorization' = (get-StringHashSHA1_native ($SCRIPT:ApiKey + $SCRIPT:ApiSecret + $unixDate))
    }

    $uri = $ApiBase + $endpoint

    $response = Invoke-WebRequest $uri -Headers $headers
    $response.content | ConvertFrom-Json
}

function get-StringHashSHA1_native([string]$textToHash) {
    # Using native crypto - faster but not available on all platforms
    # For maximum compatibility, use SHA1Managed instead of SHA1CryptoServiceProvider
    $hasher = [System.Security.Cryptography.SHA1CryptoServiceProvider]::new()
    $hashByteArray = $hasher.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($textToHash))
    foreach($byte in $hashByteArray)
    {
      $result += "{0:x2}" -f $byte
    }
    $result;
 }

