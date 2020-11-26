<#
This file creates an array called $shows containing one or more show entries.

Each show entry is a hashmap containing the following fields
  name:      The title of the podcast.  This is used as a key in data files
  rssUri:      The URL to the rss feed for the podcast
  tagline:   Author string for the podcast.  Used for Creative Commons attribution
  parse:     PS scriptblock which returns an array (episode_number, episode_title)
  parseDate: (OPTIONAL) PS scriptblock returning a [datetime] object.  
             If omitted, then [datetime]($latest.pubDate) is used.
#>

$shows = @(
    @{
        name = "No Agenda"
        rssUri = 'http://feed.nashownotes.com/rss.xml'
        tagline = 'Adam Curry & John C. Dvorak'
        parse = { parseRssTitle $rssTitle '^(?<num>\d+).*\"(?<title>.+)\"$' }
    }
    @{
        name = "Congressional Dish"
        rssUri = 'http://congressionaldish.libsyn.com/rss'
        tagline = 'Jennifer Briney'
    }
    @{
        name = "DH Unplugged"
        rssUri = 'http://www.dhunplugged.com/feed/podcast/'
        tagline = 'Andrew Horowitz & John C. Dvorak'
        parse = { parseRssTitle $rssTitle '^DHUnplugged #(?<num>\d+)\: (?<title>.+)$' }
    }
    @{
        name = "Airline Pilot Guy"
        rssUri = 'http://airlinepilotguy.com/podcast.xml'
        tagline = 'airlinepilotguy.com'
        parse = { parseRssTitle $rssTitle '^APG (?<num>\d+) . (?<title>.+)$' }
        disabled = $true
    }
    @{
        name = "The OO Top Ten"
        rssUri = 'http://rynothebearded.com/category/that-show/feed/'
        tagline = 'ryno.cc'
        parse = { (([datetime]$latest.pubDate).toString('yyyyMMdd'), $rssTitle) }
    },
    @{
        name = "Nick the Rat"
        rssUri = 'http://nicktherat.com/radio/rss.xml'
        tagline = 'nicktheratradio.com'
        parse = { parseRssTitle $rssTitle '^EPISODE (?<num>\d+) : (?<title>.+)$' }
        # Nick hand-edits his date strings use non-standard TZ code "EST", which is ambiguous.
        # Strip the time zone to avoid a parsing error, since we're discarding the time portion anyway
        parseDate = { [datetime]($latest.pubDate -replace ' EST') }
    }
    @{
        name = "Cordkillers"
        rssUri = 'https://feeds.feedburner.com/CordkillersOnlyAudio'
        tagline = 'Brian Brushwood & Tom Merritt'
        parse = { parseRssTitle $rssTitle '^Cordkillers (?<num>\d+) . (?<title>.+)$' }
        disabled = $true
    }
    @{
        name = "Grimerica"
        rssUri = 'http://grimerica.libsyn.com/rss'
        tagline = 'grimerica.ca'
    }
    @{
        name = "Rock and Roll Geek Show"
        rssUri = 'http://www.americanheartbreak.com/rnrgeekwp/feed/podcast/'
        tagline = 'Michael Butler'
        parse = {  
            if ($link -match '(\d+)\.mp3$') { $matches[1] } else { 'UNKNOWN' }
            ($rssTitle.split("–-").trim() | where { $_ -notmatch '(?:Show|Episode)\s+\d+' }) -join ' - '
        }
        disabled = $true
    }
    @{
        name = "On the Odd"
        rssUri = 'http://feeds.feedburner.com/OnTheOdd'
        tagline = 'ontheodd.com'
        parse = { 
            if ($link -match 's(\d+)e(\d+)\.mp3$') { 100 * $matches[1] + $matches[2] } else { -1 }
            if ($rssTitle -match '^On the Odd - (.+)$') { $matches[1] } else { 'title:UNKNOWN' }
        }
        disabled = $true
    }
    @{
        name = "TPO"
        rssUri = 'http://feeds.soundcloud.com/users/soundcloud:users:34774199/sounds.rss'
        tagline = 'tpo.nl'
        parse = { 
            if ($rssTitle -match 'aflevering (.+)$') { $matches[1] } else { -1 }
            "Sir Roderick Veelo & Bert Brussen"
        }
        disabled = $true
    }
    @{
        name = "Randumb Thoughts"
        rssUri = 'http://randumbthoughts.com/index.php/feed/podcast/'
        tagline = 'randumbthoughts.com'
    }
    @{
        name = "The Mark and George Show"
        rssUri = 'https://www.markandgeorgeshow.com/feed'
        tagline = 'markandgeorgeshow.com'
        parse = { parseRssTitle $rssTitle '^(?<title>.+) \| Ep\. (?<num>\d+)$' }
        disabled = $true;
    }
    @{
        name = "That Larry Show"
        rssUri = 'http://thatlarryshow.com/feed/podcast/'
        tagline = 'thatlarryshow.com'
        parse = { parseRssTitle $rssTitle '^Episode (?<num>\d+)\: (?<title>.+)$' }
    }
    @{
        name = "Shire News Network Archive"
        rssUri = 'https://brianoflondon.me/feed/podcast/shire-network-news-archive'
        tagline = 'brianoflondon.me'
        parse = { parseRssTitle $rssTitle '^(?<num>\d+) (?<title>.+) from (?<date>.+)$' }
        disabled = $true
    }
    @{
        name = "Hog Story"
        rssUri = 'http://www.hogstory.net/feed/'
        tagline = 'hogstory.net'
    }
    @{
        name = "Grumpy Old Bens"
        rssUri = 'http://grumpyoldbens.com/feed/podcast'
        tagline = 'grumpyoldbens.com'
    }
    @{
        name = "Moe Factz"
        rssUri = 'http://feed.nashownotes.com/mfrss.xml'
        tagline = 'moefactz.com'
        parse = { parseRssTitle $rssTitle '^(?<num>\d+)\: (?<title>.+)$' }
    }
    @{
        name = "With Adam Curry"
        rssUri = 'http://feed.nashownotes.com/wacrss.xml'
        tagline = 'withadamcurry.com'
        parse = { 
            if ($link -match 'WAC-(\d+)-') { $matches[1] } else { -1 }
            $rssTitle
        }
    }
    @{
        name = "Who Are These Podcasts?"
        rssUri = 'http://whoarethese.com/rss'
        tagline = 'whoarethese.com'
    }
    @{
        name = "Up is Down"
        rssUri = 'https://www.spreaker.com/show/3564656/episodes/feed'
        tagline = 'deanreiner.com'
        parse = { parseRssTitle $rssTitle '^Ep (?<num>\d+) (?<title>.+)$' }
    }
    @{
        name = "A Walk Through the Mind"
        rssUri = 'http://billybon3s.libsyn.com/rss'
        tagline = 'billybon3s.com'
        parse = { $latest.episode, $rssTitle }
    }
    @{
        name = "SmashCast"
        rssUri = 'https://smashcast.squarespace.com/smashcast?format=rss'
        tagline = 'smashcast.squarespace.com'
    }
    @{
        name = "Fun Fact Friday"
        rssUri = 'http://funfactfriday.com/index.php/feed/podcast/'
        tagline = 'funfactfriday.com'
        #parse = { parseRssTitle $rssTitle 'Episode (?<num>\d+) . (?<title>.+)$' }
    }
    @{
        name = "Bowl After Bowl"
        rssUri = 'https://feed.podbean.com/bowlafterbowl/feed.xml'
        tagline = 'Sir Spencer and Dame Laurien'
        parse = { parseRssTitle $rssTitle 'Episode (?<num>\d+) . (?<title>.+)$' }
    }
    @{
        name = "Rare Encounter"
        rssUri = 'https://rareencounter.net/feed.xml'
        tagline = 'rareencounter.net'
        parse = { parseRssTitle $rssTitle 'Encounter \#(?<num>\d+)\: (?<title>.+)$'}
    }
    @{
        name = "ABS n' a 6-Pack"
        rssUri = 'https://www.absna6pack.com/podcast?format=rss'
        tagline = 'absna6pack.com'
        parse = { parseRssTitle $rssTitle 'Episode (?<num>\d+) . (?<title>.+)$' }
    }
    @{
        name = "Back From The Future"
        rssUri = 'https://www.backfromthefutureshow.com/feed/podcast'
        tagline = 'backfromthefutureshow.com'
        parse = { parseRssTitle $rssTitle 'Ep\. (?<num>\d+) . (?<title>.+)$' }
    }
    @{
        name = "Our Big Dumb Mouth"
        rssUri = 'https://ourbigdumbmouth.libsyn.com/RSS'
        tagline = 'ourbigdumbmouth.com'
        parse = { parseRssTitle $rssTitle 'OBDM(?<num>\d+) . (?<title>.+)$' }
    }
    @{
        name = "2030 Podcast"
        rssUri = 'https://2030podcast.com/category/2030-podcast/feed/'
        tagline = '2030podcast.com'
        parse = { parseRssTitle $rssTitle '^(?<num>\d+).+ (?<title>.+)$' }
    }
    @{
        name = "Informed Dissent"
        rssUri = 'https://feeds.buzzsprout.com/1213430.rss'
        tagline = 'leonydusjohnson.com'
        parse = { parseRssTitle $rssTitle '^Episode (?<num>\d+)\: (?<title>.+)$' }
    }
)


# Helper function taking a regex to parse a string into episode number and episode name
# The regex must contain named capture groups "num" and "title".
# Example syntax : "(?<num>\d+)"

function parseRssTitle([string]$t, [string]$rgx) {
    # Returns (number, title)
    if ($t -match $rgx) {
        $matches['num', 'title']
    } else {
        (0, "CANNOT PARSE TITLE: {{$rssTitle}}")
    }
}
