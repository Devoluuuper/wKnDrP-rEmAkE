Config = {}

-- require people to run steam
Config.RequireSteam = false

-- 'whitelist' only server
Config.PriorityOnly = false

-- disables hardcap, should keep this true
Config.DisableHardCap = true

-- will remove players from connecting if they don't load within: __ seconds; May need to increase this if you have a lot of downloads.
-- i have yet to find an easy way to determine whether they are still connecting and downloading content or are hanging in the loadscreen.
-- This may cause session provider errors if it is too low because the removed player may still be connecting, and will let the next person through...
-- even if the server is full. 10 minutes should be enough
Config.ConnectTimeOut = 600

-- will remove players from queue if the server doesn't recieve a message from them within: __ seconds
Config.QueueTimeOut = 90

-- will give players temporary priority when they disconnect and when they start loading in
Config.EnableGrace = false

-- how much priority power grace time will give
Config.GracePower = 5

-- how long grace time lasts in seconds
Config.GraceTime = 480

Config.AntiSpam = false
Config.AntiSpamTimer = 30
Config.PleaseWait = 'Palun oodake %f sekundit. Ühendamine algab peadselt!'

-- on resource start, players can join the queue but will not let them join for __ milliseconds
-- this will let the queue settle and lets other resources finish initializing
Config.JoinDelay = 30000

-- will show how many people have temporary priority in the connection message
Config.ShowTemp = false

-- simple localization
Config.Language = {
    joining = 'Ühendumine...',
    connecting = 'Järjekorraga liitumine...',
    idrr = '[VIGA]: Teilt ei leitud ühtegi IDt!',
    err = '[VIGA]: Tekkis probleem!',
    pos = 'Olete järjekorras %d/%d; %s',
    connectingerr = '[VIGA]: Tekkis probleem järjekorda lisamisel!',
    timedout = '[JÄRJEKORD] Error: Timed out.',
    steam = '[JÄRJEKORD] Error: Steam peab töötama, et ühineda.'
}