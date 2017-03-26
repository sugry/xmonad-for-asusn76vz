Config {
    font = "xft:SFN 
    display:size=11,FontAwesome:size=11" 
    , bgColor = "#2A373E"
    , fgColor = "#4DB6AC"
    , position = TopW L 97
  --  , position = Static { xpos = 0, ypos = 0, width = 1920, height = 18 },
    , lowerOnStart = True
    , iconOffset = -1
    --, textOffset = -1
    , iconRoot = "/home/s-adm/.xmonad/icons"

    -- refresh rate is in tenths of second
    , commands = [
        Run Weather "USRR" [
            "-t"
            , " <tempC><fc=#b4cdcd>°C</fc>"
            , "-L",         "12"
            , "-H",         "33"
            , "--normal",   "#85B400"
            , "--high",     "red"
            , "--low",      "#64FFE0"
        ] 36000
        --, Run Date "%a %b %d %H:%M" "date" 300
        , Run Network "wlp3s0" [
            "-t"    ,"<rx> <tx>"
            ,"-H"   ,"200"
            ,"-L"   ,"10"
            ,"-h"   ,"#FFB6B0"
            ,"-l"   ,"#CEFFAC"
            ,"-n"   ,"#FFFFCC"
            , "-c"  , " "
            , "-w"  , "2"
            ] 10
        , Run DynNetwork [
            "-S"
            ,"True"
            ,"-d"
            ,"1"
            ,"-t"
            ,"  <fc=#489FDF></fc> <rx> <fc=#1C9A71></fc> <tx>"] 10
        , Run Battery [ "--template" , "<acstatus>"
            , "--Low"      , "20"        -- units: %
            , "--High"     , "75"        -- units: %
            , "--low"      , "#FFA500"
            , "--normal"   , "#BDB76B"
            , "--high"     , "#4682B4"

            , "--" -- battery specific options
            -- discharging status
            , "-o"	, " <left>% (<timeleft>)"
            -- AC "on"  status
            , "-O"	, "<fc=#d2d4dc></fc> <left>%"
            -- charged status
            , "-i"	, "<fc=#d2d4dc></fc>"
        ] 50
        , Run Kbd [
            ("us", "us"), ("ru", "ru")
        ]
        , Run MultiCpu [
            "-L","3"
            , "-H","50"
            , "--normal","#AFFF5F"
            , "--high","red"
            , "-t", " <total><fc=#b4cdcd>%</fc>"
        ] 30
        , Run Memory [
            "-t", " <usedratio><fc=#b4cdcd>%</fc>"
            , "-L",         "20"
            , "-H",         "70"
            , "--high",     "red"
            , "--normal",   "#85B400"
        ] 50
        ,Run CoreTemp [ "--template" , "<core0> °C"
            , "--Low"      , "70"        -- units: °C
            , "--High"     , "80"        -- units: °C
            , "--low"      , "darkgreen"
            , "--normal"   , "darkorange"
            , "--high"     , "darkred"
        ] 50
        , Run Com "/home/s-adm/.scripts/xmdate" [] "xmdate" 10
        , Run Com "/home/s-adm/.scripts/xmtime" [] "xmtime" 10
        , Run Com "/home/s-adm/.scripts/logout.sh" [] "logout" 0
        , Run Com "/home/s-adm/.scripts/XMTraf" [] "traf" 50
        , Run PipeReader "/tmp/.volume-pipe" "vol"
        , Run PipeReader "/tmp/.getpkg-pipe" "pkg"
        , Run PipeReader "/tmp/.weather-pipe" "weather"
        , Run UnsafeStdinReader
    ]
    , sepChar = "%"
    , alignSep = "}{"
    , template = "<fc=#0080FF>λ</fc> %UnsafeStdinReader% }{ <action=`/home/s-adm/.scripts/XMVnstat-h` button=1><action=`/home/s-adm/.scripts/XMVnstat-d` button=3>%dynnetwork%</action></action> <action=`/home/s-adm/.scripts/XMVnstat` button=1><action=`/home/s-adm/.scripts/XMVnstat` button=3>%traf%</action></action> :: <action=`/home/s-adm/.scripts/XMKeybind` button=1> <fc=#b4cdcd>%kbd%</fc></action> ::  <fc=#b4cdcd>%vol%</fc> :: <action=`/home/s-adm/.scripts/XMTop-cpu` button=1>%multicpu%</action> <action=`/home/s-adm/.scripts/XMTop-mem` button=1>%memory%</action>  %coretemp% :: <action=`/home/s-adm/.scripts/XMBatt` button=1>%battery%</action> :: <fc=#b4cdcd><action=`/home/s-adm/.scripts/full-weather.sh` button=1><action=`chromium --app=http://www.accuweather.com/ru/ru/surgut/288459/current-weather/288459` button=3>%weather%</action></action></fc> ::  <action=`orage --toggle` button=3><action=`/home/s-adm/.scripts/XMCal` button=1>%xmdate%</action></action>   <fc=#cccccc><action=`/home/s-adm/.scripts/XMXClock` button=3><action=`/home/s-adm/.scripts/XMAnalize` button=1>%xmtime%</action></action></fc> :: <action=`oblogout` button=1>%logout%</action> :: <fc=#0080FF><action=`/home/s-adm/.scripts/run-pkg.sh`>%pkg%</action></fc>"
    
}
