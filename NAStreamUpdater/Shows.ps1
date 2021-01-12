<#
This file creates an array called $shows containing one or more show entries.

Each show entry is a hashmap containing the following fields
  name:      The title of the podcast.  This is used as a key in data files
  rssUri:      The URL to the rss feed for the podcast
  tagline:   Author string for the podcast.  Used for Creative Commons attribution
  parse:     PS scriptblock which returns an array (episode_number, episode_title)
#>

$shows = @(
    @{
        name = "No Agenda"
        id = 41504
        rssUri = 'http://feed.nashownotes.com/rss.xml'
        tagline = 'Adam Curry & John C. Dvorak'
        parse = { parseTitle $title '^(?<num>\d+).*\"(?<title>.+)\"$' }
    }
    @{
        name = "Congressional Dish"
        id = 167137
        rssUri = 'http://congressionaldish.libsyn.com/rss'
        tagline = 'Jennifer Briney'
    }
    @{
        name = "DH Unplugged"
        id = 650774
        rssUri = 'http://www.dhunplugged.com/feed/podcast/'
        indexRssUri = 'http://feeds.dhunplugged.com/DHUnplugged'
        tagline = 'Andrew Horowitz & John C. Dvorak'
        parse = { parseTitle $title '^DHUnplugged #(?<num>\d+)\: (?<title>.+)$' }
    }
    @{
        name = "Airline Pilot Guy"
        id = 387814
        rssUri = 'http://airlinepilotguy.com/podcast.xml'
        tagline = 'airlinepilotguy.com'
        parse = { parseTitle $title '^APG (?<num>\d+) . (?<title>.+)$' }
        disabled = $true
    }
    @{
        name = "The OO Top Ten"
        id = 1332231
        rssUri = 'http://rynothebearded.com/category/that-show/feed/'
        tagline = 'ryno.cc'
        parse = { ($null, $title) }
    },
    @{
        name = "Nick the Rat"
        id = 873788
        rssUri = 'http://nicktherat.com/radio/rss.xml'
        indexRssUri = 'http://feeds.feedburner.com/nicktherat/ejbV'
        tagline = 'nicktheratradio.com'
        parse = { parseTitle $title '^EPISODE (?<num>\d+) : (?<title>.+)$' }
    }
    @{
        name = "Cordkillers"
        id = 1053273
        rssUri = 'https://feeds.feedburner.com/CordkillersOnlyAudio'
        tagline = 'Brian Brushwood & Tom Merritt'
        parse = { parseTitle $title '^Cordkillers (?<num>\d+) . (?<title>.+)$' }
        disabled = $true
    }
    @{
        name = "Grimerica"
        id = 745270
        rssUri = 'http://grimerica.libsyn.com/rss'
        tagline = 'grimerica.ca'
    }
    @{
        name = "Rock and Roll Geek Show"
        id = 1065409
        rssUri = 'http://www.americanheartbreak.com/rnrgeekwp/feed/podcast/'
        indexRssUri = 'https://www.americanheartbreak.com/rnrgeekwp/?feed=podcast'
        tagline = 'Michael Butler'
        parse = {  
            if ($link -match '(\d+)\.mp3$') { $matches[1] } else { 'UNKNOWN' }
            ($title.split("–-").trim() | where { $_ -notmatch '(?:Show|Episode)\s+\d+' }) -join ' - '
        }
        disabled = $true
    }
    @{
        name = "On the Odd"
        id = 1050591
        rssUri = 'http://feeds.feedburner.com/OnTheOdd'
        tagline = 'ontheodd.com'
        parse = { 
            if ($link -match 's(\d+)e(\d+)\.mp3$') { 100 * $matches[1] + $matches[2] } else { -1 }
            if ($title -match '^On the Odd - (.+)$') { $matches[1] } else { 'title:UNKNOWN' }
        }
        disabled = $true
    }
    @{
        name = "TPO"
        id = 663165
        rssUri = 'http://feeds.soundcloud.com/users/soundcloud:users:34774199/sounds.rss'
        tagline = 'tpo.nl'
        parse = { 
            if ($title -match 'aflevering (.+)$') { $matches[1] } else { -1 }
            "Sir Roderick Veelo & Bert Brussen"
        }
        disabled = $true
    }
    @{
        name = "Randumb Thoughts"
        id = 573761
        rssUri = 'http://randumbthoughts.com/index.php/feed/podcast/'
        tagline = 'randumbthoughts.com'
    }
    @{
        name = "The Mark and George Show"
        id = 1161075
        rssUri = 'https://www.markandgeorgeshow.com/feed'
        indexRssUri = 'https://www.markandgeorgeshow.com/feed/podcast/'
        tagline = 'markandgeorgeshow.com'
        parse = { parseTitle $title '^(?<title>.+) \| Ep\. (?<num>\d+)$' }
        disabled = $true;
    }
    @{
        name = "That Larry Show"
        id = 1028304
        rssUri = 'http://thatlarryshow.com/feed/podcast/'
        tagline = 'thatlarryshow.com'
        parse = { parseTitle $title '^Episode (?<num>\d+)\: (?<title>.+)$' }
    }
    @{
        name = "Shire News Network Archive"
        id = 685191
        rssUri = 'https://brianoflondon.me/feed/podcast/shire-network-news-archive'
        tagline = 'brianoflondon.me'
        parse = { parseTitle $title '^(?<num>\d+) (?<title>.+) from (?<date>.+)$' }
        disabled = $true
    }
    @{
        name = "Hog Story"
        id = 787405
        rssUri = 'http://www.hogstory.net/feed/'
        indexRssUri = 'https://www.hogstory.net/feed/podcast/'
        tagline = 'hogstory.net'
    }
    @{
        name = "Grumpy Old Bens"
        id = 574891
        rssUri = 'http://grumpyoldbens.com/feed/podcast'
        indexRssUri = 'https://grumpyoldbens.com/index.php/feed/podcast/'
        tagline = 'grumpyoldbens.com'
    }
    @{
        name = "Moe Factz"
        id = 207356
        rssUri = 'http://feed.nashownotes.com/mfrss.xml'
        tagline = 'moefactz.com'
        parse = { parseTitle $title '^(?<num>\d+)\: (?<title>.+)$' }
    }
    @{
        name = "With Adam Curry"
        id = 1332230
        rssUri = 'http://feed.nashownotes.com/wacrss.xml'
        tagline = 'withadamcurry.com'
        parse = { 
            if ($link -match 'WAC-(\d+)-') { $matches[1] } else { -1 }
            $title
        }
    }
    @{
        name = "Who Are These Podcasts?"
        id = 217722
        rssUri = 'http://whoarethese.com/rss'
        indexRssUri = 'https://watps.libsyn.com/rss'
        tagline = 'whoarethese.com'
    }
    @{
        name = "Up is Down"
        id = 1046833
        rssUri = 'https://www.spreaker.com/show/3564656/episodes/feed'
        tagline = 'deanreiner.com'
        parse = { parseTitle $title '^Ep (?<num>\d+) \: (?<title>.+)$' }
    }
    @{
        name = "A Walk Through the Mind"
        id = 1002701
        rssUri = 'http://billybon3s.libsyn.com/rss'
        tagline = 'billybon3s.com'
        parse = { $latest.episode, $title }
    }
    @{
        name = "SmashCast"
        id = 210301
        rssUri = 'https://smashcast.squarespace.com/smashcast?format=rss'
        tagline = 'smashcast.squarespace.com'
    }
    @{
        name = "Fun Fact Friday"
        id = 288180
        rssUri = 'http://funfactfriday.com/index.php/feed/podcast/'
        tagline = 'funfactfriday.com'
        #parse = { parseTitle $title 'Episode (?<num>\d+) . (?<title>.+)$' }
    }
    @{
        name = "Bowl After Bowl"
        id = 946122
        rssUri = 'https://feed.podbean.com/bowlafterbowl/feed.xml'
        tagline = 'Sir Spencer and Dame Laurien'
        parse = { parseTitle $title 'Episode (?<num>\d+) . (?<title>.+)$' }
    }
    @{
        name = "Rare Encounter"
        id = 937170
        rssUri = 'https://rareencounter.net/feed.xml'
        tagline = 'rareencounter.net'
        #parse = { parseTitle $title 'Encounter \#(?<num>\d+)\: (?<title>.+)$'}
    }
    @{
        name = "ABS n' a 6-Pack"
        id = 946748
        rssUri = 'https://www.absna6pack.com/podcast?format=rss'
        indexRssUri = 'https://www.absna6pack.com/?format=rss'
        tagline = 'absna6pack.com'
        parse = { parseTitle $title 'Episode (?<num>\d+) . (?<title>.+)$' }
    }
    @{
        name = "Back From The Future"
        id = 31769
        rssUri = 'https://www.backfromthefutureshow.com/feed/podcast'
        tagline = 'backfromthefutureshow.com'
        parse = { parseTitle $title 'Ep\. (?<num>\d+) . (?<title>.+)$' }
    }
    @{
        name = "Our Big Dumb Mouth"
        id = 907769
        rssUri = 'https://ourbigdumbmouth.libsyn.com/RSS'
        tagline = 'ourbigdumbmouth.com'
        parse = { parseTitle $title 'OBDM(?<num>\d+) . (?<title>.+)$' }
    }
    @{
        name = "2030 Podcast"
        id = 1007020
        rssUri = 'https://2030podcast.com/category/2030-podcast/feed/'
        indexRssUri = 'https://2030podcast.com/feed/'
        tagline = '2030podcast.com'
        parse = { parseTitle $title '^(?<num>\d+). (?<title>.+)$' }
    }
    @{
        name = "Informed Dissent"
        id = 1011495
        rssUri = 'https://feeds.buzzsprout.com/1213430.rss'
        tagline = 'leonydusjohnson.com'
        parse = { parseTitle $title '^Episode (?<num>\d+)\: (?<title>.+)$' }
    }
    @{
        name = "Behind the Sch3m3s"
        id = 150842
        rssUri = 'https://www.podserve.fm/series/rss/2202/behind-the-schms.rss'
        tagline = 'behindthesch3m3s.com'
        parse = { parseTitle $title '^S01E(?<num>\d+)\: (?<title>.+)$' }
    }
    @{
        name = "Daddycast Rewind"
        id = 1330022
        rssUri = 'https://anchor.fm/s/307f9da8/podcast/rss'
        tagline = 'P.D. Love'
        parse = { parseTitle $title '^(?<num>\d+) .+ \- (?<title>.+)$' }
    }
    @{
        name = "The Privacy, Security, & OSINT Show"
        id = 556715
        rssUri = 'https://feeds.soundcloud.com/users/soundcloud:users:261098918/sounds.rss'
        tagline = 'Michael Bazzell'
        parse = { parseTitle $title '^(?<num>\d+)\-(?<title>.+)$' }
    }
    @{
        name = "Origins of Things and Stuff"
        id = 1366465
        rssUri = 'http://originsofthingsandstuff.com/rss.xml'
        tagline = 'Illuminadia and Nick the Rat'
        parse = { $null, $title }
    }
)


# Helper function taking a regex to parse a string into episode number and episode name
# The regex must contain named capture groups "num" and "title".
# Example syntax : "(?<num>\d+)"

function parseTitle([string]$t, [string]$rgx) {
    # Returns (number, title)
    if ($t -match $rgx) {
        $matches['num', 'title']
    } else {
        (0, "CANNOT PARSE TITLE: {{$title}}")
    }
}
