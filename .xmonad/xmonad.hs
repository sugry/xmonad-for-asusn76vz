-- author idea https://github.com/tlatsas
import XMonad
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys, additionalMouseBindings)
import System.IO
import System.Exit
import Graphics.X11.ExtraTypes.XF86

import qualified XMonad.StackSet    as W
import qualified Data.Map           as M

-- action
-- import XMonad.Actions.DwmPromote
import Control.Monad (liftM2)

-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageHelpers

-- xmonad prompt and scratchpad and utils
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Scratchpad
import XMonad.Util.NamedScratchpad
import XMonad.Util.WorkspaceCompare
import XMonad.Util.Cursor
import qualified XMonad.Prompt as P
import XMonad.Prompt.Shell
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Man
import XMonad.Prompt.AppendFile
import XMonad.Prompt.Layout

-- layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.Reflect
import XMonad.Layout.IM
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Grid
import XMonad.Layout.Circle
import XMonad.Layout.LayoutHints
import XMonad.Layout.Gaps

import XMonad.Layout.Spacing

import Data.Ratio ((%))
import Data.List (isInfixOf)
import XMonad.Actions.CycleWS (findWorkspace, nextScreen, prevScreen, swapNextScreen, swapPrevScreen, toggleOrDoSkip, WSType(..))
import XMonad.Actions.CycleWS (nextWS,prevWS)
import XMonad.Actions.GridSelect
import qualified XMonad.Actions.DynamicWorkspaceOrder as DO
-- import XMonad.Actions.DynamicWorkspaces (addWorkspace) -- for gridselectWorkspace only

-- Java workarounds
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName

-- classic alt-tab
--import XMonad.Actions.CycleWindows
role                 =  stringProperty "WM_WINDOW_ROLE"

getWsCompare' :: X WorkspaceCompare
getWsCompare' = do
    wsIndex <- getWsIndex
    return $ \a b -> f (wsIndex a) (wsIndex b) `mappend` compare a b
  where
    f Nothing Nothing   = EQ
    f (Just _) Nothing  = LT
    f Nothing (Just _)  = GT
    f (Just x) (Just y) = compare x y

getSortByIndex' :: X WorkspaceSort
getSortByIndex' = mkWsSort getWsCompare'

myStartupHook = setWMName "LG3D" <+> setDefaultCursor xC_left_ptr <+> do  spawn "~/.xmonad/getvolume.sh >> /tmp/.volume-pipe && echo >> /tmp/.getpkg-pipe && /home/s-adm/.scripts/get-weather-reload.sh"

{-main = do
    spawn "feh --bg-center /usr/share/backgrounds/003.jpg"
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
    xmonad  =<< xmobar def {
    manageHook = myManageHook <+> manageDocks
            , modMask = mod4Mask
            , layoutHook = myLayoutHook
            , logHook = myLogHook xmproc
            , terminal = myTerminal
            , workspaces = myWorkspaces
            , borderWidth = myBorderWidth
            , normalBorderColor = myNormalBorderColor
            , focusedBorderColor = myFocusedBorderColor
            , keys = myKeys
            , startupHook = myStartupHook
            }-}

main = do
    spawn "feh --bg-center /usr/share/backgrounds/003.jpg"
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
    xmonad $ withUrgencyHook NoUrgencyHook $ ewmh $ def { 
              manageHook = myManageHook <+> manageDocks
            , modMask = mod4Mask
            , layoutHook = myLayoutHook
            , logHook = myLogHook xmproc
            , terminal = myTerminal
            , workspaces = myWorkspaces
            , borderWidth = myBorderWidth
            , normalBorderColor = myNormalBorderColor
            , focusedBorderColor = myFocusedBorderColor
            , keys = myKeys
            , mouseBindings = myMouseBindings
            , startupHook = myStartupHook
            }

-- workspaces
xmobarEscape = concatMap doubleLts
    where doubleLts '<' = "<<"
          doubleLts x = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape) $ ["1:\62056", "2:\62048", "3:\61728", "4:\61443", "5:\61448", "6:\61659", "7:\61659", "8:\61659", "9:\61659"]
    where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                            (i,ws) <- zip [1..9] l,
                            let n = i ]

-- terminal
myTerminal :: String
myTerminal = "urxvtc"

-- launcher
--myLauncher :: String
--myLauncher = "dmenu_run -nb '#232323' -nf '#9fbc00' -sb '#9fbc00' -sf '#141414' -p '$'"

-- window border size
myBorderWidth :: Dimension
myBorderWidth = 1

-- window border colors
myNormalBorderColor, myFocusedBorderColor :: String
myNormalBorderColor = "#141414"
myFocusedBorderColor = "#9a9a9a"

-- nameScratchpad
mynameScratchpads = [ NS "ncmpcpp"      "urxvtc -name ncmpcpp -e ncmpcpp"     (appName    =? "ncmpcpp")      (customFloating $ W.RationalRect 0.15 0.2 0.7 0.6)
                    , NS "htop"         "urxvtc -name htop -e htop"           (appName    =? "htop")         (customFloating $ W.RationalRect 0.05 0.05 0.9 0.9)
                    , NS "gpick"        "gpick"                               (appName    =? "gpick")        (customFloating $ W.RationalRect 0.2 0.2 0.6 0.6)
                    , NS "pavucontrol"  "pavucontrol"                         (appName    =? "pavucontrol")  (customFloating $ W.RationalRect 0.2 0.2 0.6 0.6)
                    , NS "update"       "urxvtc -name update -e yaourt -Syua" (appName    =? "update")       (customFloating $ W.RationalRect 0.15 0.2 0.7 0.6)

                    , NS "Mirage"       "mirage"                              (className  =? "Mirage")       (customFloating $ W.RationalRect 0.05 0.05 0.9 0.9)
                    , NS "font-manager" "font-manager"                        (className  =? "Font-manager") (customFloating $ W.RationalRect 0.2 0.2 0.6 0.6)

                    , NS "Organizer"    "Organizer"                           (role       =? "Organizer")    (customFloating $ W.RationalRect 0.1 0.1 0.8 0.8)
                    , NS "Orage"        "orage"                               (title  =? "Календарь Orage")  (customFloating $ W.RationalRect (8/10) (1/30) (1/8) (5/22))
                    , NS "Weather"      "Weather"                             (role       =? "pop-up")       (customFloating $ W.RationalRect 0.15 0.2 0.7 0.6)
                    ]

-- hooks --
-- switch apps to workspace
-- and view to switch
-- for more information see https://wiki.haskell.org/Xmonad/General_xmonad.hs_config_tips

myManageHook :: ManageHook
myManageHook = scratchpadManageHook ( W.RationalRect 0.25 0.25 0.5 0.5 ) <+> namedScratchpadManageHook mynameScratchpads <+> ( composeAll . concat $
      [
      [ isDialog --> doCenterFloat ]
    , [ isFullscreen --> doFullFloat ]
    , [manageDocks]
    , [(className =? c <||> title =? c <||> resource =? c) --> doIgnore                       | c <- bars   ]
    , [(className =? c <||> title =? c <||> resource =? c) --> doFloat                        | c <- float  ]
    , [(className =? c <||> title =? c <||> resource =? c) --> doCenterFloat                  | c <- cfloat ]
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 0) <+> viewShift (myWorkspaces !! 0)   | c <- web    ]    -- i
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 1) <+> viewShift (myWorkspaces !! 1)   | c <- text   ]    -- ii
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 2) <+> viewShift (myWorkspaces !! 2)   | c <- term   ]    -- iii
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 3) <+> viewShift (myWorkspaces !! 3)   | c <- mail   ]    -- iv
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 4) <+> viewShift (myWorkspaces !! 4)   | c <- movi   ]    -- v
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 5) <+> viewShift (myWorkspaces !! 5)   | c <- docs   ]    -- vi
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 6) <+> viewShift (myWorkspaces !! 6)   | c <- graph  ]    -- vii
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 7) <+> viewShift (myWorkspaces !! 7)   | c <- media  ]    -- vii
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 8) <+> viewShift (myWorkspaces !! 8)   | c <- chat   ]    -- ix
    , [role =? c --> doFloat | c <- im ]     -- place roles on im
      ] )
    where    
        bars      = ["dzen2","desktop_window"]
        float     = ["feh","Oblogout","Найти"]
        cfloat    = ["Xmessage","Gxmessage","Eog","Xscreensaver-demo","Brasero","xclock","Xscreensaver-demo","xfreerdp"]
            ++ ["SimpleScreenRecorder","Evolution-alarm-notify","Evolution","Gns3","Mtpaint","Leafpad","Запустить файл","Gpicview"]
            ++ ["pamac-manager","pamac-updater","Deadbeef","Orage","Globaltime","Настройки мирового времени","Настройки Thunderbird"]
            ++ ["Cpu-g","galculator","Xarchiver","Lxappearance","Grsync","gcolor2"]
        web       = ["Chromium","Opera"]
        text      = ["Geany","Atom","Pcmanfm"]
        term      = ["urxvt"]
        mail      = ["Thunderbird","Notecase"]
        movi      = ["Pithos","Ario","Vlc","Ncmpcpp","mpv"]
        docs      = ["libreoffice-calc","libreoffice-writer","VirtualBox","libreoffice"]
        graph     = ["Gimp"]
        media     = ["Wine"]
        chat      = ["Pidgin","Skype"]
        im        = ["nothing"]
        --role      = stringProperty "WM_WINDOW_ROLE"
        viewShift = doF . liftM2 (.) W.greedyView W.shift

-- logHook
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ myPP { ppOutput = hPutStrLn h
    , ppSort = fmap (.scratchpadFilterOutWorkspace) getSortByTag
    }

-- custom theme for xmobar
myPP :: PP
myPP = def
    {
        ppCurrent   = xmobarColor "#ECECEC" "" . wrap "[" "]"
        , ppVisible = xmobarColor "#9CB1B1" "" . wrap "(" ")"
        , ppHidden  = xmobarColor "#66777F" ""
        , ppUrgent  = xmobarColor "#FF5230" "" . wrap "“" "”"
        , ppLayout  = xmobarColor "#455A64" ""
        , ppTitle   = xmobarColor "#4DB6AC" "" . shorten 60
        , ppSep     = xmobarColor "#4DB6AC" "" " :: "
    }

-- custom theme for shell
myXPConfig = def
    {
        font = "xft:Cantarell:size=11"
        , fgColor = "#4DB6AC"
        , bgColor = "#3E515A"
        , bgHLight = "#2A373E"
        , fgHLight = "#ECECEC"
        , promptBorderWidth = 0
        , position = Bottom
        , historySize = 512
        , showCompletionOnTab = True
        , historyFilter = deleteConsecutive
    }

-- custom theme for tabs
myTabConfig = def
    {
        fontName = "xft:Dejavu Sans:size=10"
        , inactiveColor = "#2A373E"
        , activeColor = "#2A373E"
        , activeBorderColor = "#78909C"
        , inactiveBorderColor = "#455A64"
        , activeTextColor = "#78909C"
        , inactiveTextColor = "#455A64"
    }

-- layout
{-myLayoutHook = spacing 1 $ gaps [(U,18)] $ toggleLayouts (noBorders Full)
    (smartBorders (OneBig (3/4) (3/4) ||| spiral (6/7) ||| Mirror tiled ||| mosaic 2 [3,2] ||| simpleCross ||| tabbed shrinkText myTabConfig))
    where
        tiled   = Tall nmaster delta ratio
        nmaster = 1
        delta   = 2/100
        ratio   = 1/2  -}

myLayoutHook =  avoidStruts 
                $ smartBorders
                $ gaps [(U,23)]
                $ onWorkspace (myWorkspaces !! 0) webL
                $ onWorkspace (myWorkspaces !! 1) textL
                $ onWorkspace (myWorkspaces !! 2) termL
                $ onWorkspace (myWorkspaces !! 4) fullL
                $ onWorkspace (myWorkspaces !! 5) imL
                $ onWorkspace (myWorkspaces !! 6) fullL
                $ onWorkspace (myWorkspaces !! 7) webL
                $ onWorkspace (myWorkspaces !! 8) gimpL
                $ standardLayouts
                
    where
        standardLayouts = (spacing 5 (tiled) ||| spacing 5 (reflectTiled) ||| spacing 5 (Mirror tiled) ||| Circle ||| spacing 5 (Grid) ||| Full ||| tabbed shrinkText myTabConfig)

        --Layouts
        --tiled = layoutHintsWithPlacement (0.5, 0.5) (Tall 1 (3/100) (1/2))
        
        tiled   = Tall nmaster ndelta nratio
        
        -- The default number of windows in the master pane
        nmaster = 1
        ndelta  = 3/100
        -- Default proportion of screen occupied by master pane
        nratio  = 1/2
        
        reflectTiled = (reflectHoriz tiled)
        --full = noBorders Full
        fullL = (noBorders Full)
        --tabs = tabbed shrinkText myTabConfig

        --Im Layout
        imL = withIM ratio pidginRoster $
              withIM ratio emeseneRoster $
              withIM ratio gajimRoster $
              reflectHoriz $ withIM skypeRatio skypeRoster (reflectTiled ||| Grid) where
                ratio = (1%9)
                -- pidgin
                pidginRoster = And (ClassName "Pidgin") (Role "buddy_list")
                -- skype
                skypeRatio = (1%8)
                skypeRoster = (And (ClassName "Skype") (Not (Role "ConversationsWindow")))
                -- emesene
                emeseneRoster = (Resource "emesene" `And` Title "emesene" `And` ClassName "Emesene")
                -- gajim
                gajimRoster = And (ClassName "Gajim.py") (Role "roster")


        webL  = (noBorders Full ||| tabbed shrinkText myTabConfig ||| Circle)
        
        textL = (tabbed shrinkText myTabConfig ||| spacing 5 (tiled))
        
        termL = (mouseResizableTile ||| spacing 5 (Mirror tiled) ||| spacing 5 (Grid) ||| spacing 5 (tiled) ||| spacing 5 (reflectTiled))

        gimpL = withIM (0.11) (Role "gimp-toolbox") $ reflectHoriz $ withIM (0.15) (Role "gimp-dock") (noBorders Full ||| tabbed shrinkText myTabConfig)

button8 = 8 :: Button
button9 = 9 :: Button

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [
      ((modm, button5),\_-> nextWS)            -- go to next workspace
    , ((modm, button4),\_-> prevWS)            -- go to prev workspace
    , ((modm, button2),\_-> kill)  
    -- Set the window to floating mode and move by dragging
    , ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    , ((0, button8), (\w -> windows . W.greedyView =<< findWorkspace getSortByIndexNoSP Next HiddenNonEmptyWS 1)) -- go to next nonempty workspace
    , ((0, button9), (\w -> windows . W.greedyView =<< findWorkspace getSortByIndexNoSP Prev HiddenNonEmptyWS 1)) -- go to prev nonempty workspace
    ]
    where
      getSortByIndexNoSP =
          fmap (.namedScratchpadFilterOutWorkspace) getSortByIndex'
      shiftAndView' dir = findWorkspace getSortByIndexNoSP dir AnyWS 1
                          >>= \t -> (windows . W.shift $ t) >> (windows . W.greedyView $ t)

-- keybindings
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    ,((modm .|. controlMask, xK_Return), spawn "urxvt")
    
    , ((modm .|. controlMask, xK_t), sendMessage $ IncGap 5 U)  -- increment the top-hand gap
    , ((modm .|. controlMask, xK_g), sendMessage $ DecGap 5 U)  -- decrement the top-hand gap
    , ((0, xK_F11), sendMessage $ ToggleGap U) -- toggle the top gap

    -- launch dmenu
--    , ((modm .|. shiftMask, xK_p     ), spawn myLauncher)

    -- launch gmrun
    , ((modm.|. shiftMask,  xK_r     ), spawn "gmrun")
    
    , ((modm,     xF86XK_Launch6     ), goToSelected defaultGSConfig)
    , ((0,        xF86XK_Launch6     ), spawnSelected defaultGSConfig ["pcmanfm","geany","chromium"
    ,"leafpad","thunderbird","notecase","xscreenshot","wps","et","pinta","gcolor2","gnome-calculator","vlc"])
    
    --, ((modm,               xK_w    ), gridselectWorkspace' defaultGSConfig
    --                     { gs_navigate   = navNSearch
    --                     , gs_rearranger = searchStringRearrangerGenerator id
    --                    }
    --                 addWorkspace)
    
    -- launch rofi (a program launcher, see https://davedavenport.github.io/rofi/)
    -- rofi-list-directores is a custom script to list commands to open each directory in home
    , ((modm,                xK_r    ), spawn "rofi -show run")

    , ((0,                 xK_F12    ), scratchpadSpawnActionTerminal "urxvt -name scratchpad")
    
    --Menu
    --, ((modm,                           0xff67),    spawn "menu")    --Mod4+Menu

    -- prompt
    , ((mod1Mask,            xK_F1),     manPrompt myXPConfig)
    , ((mod1Mask,            xK_F2),     runOrRaisePrompt myXPConfig) 
    
    , ((mod1Mask,            xK_F3 ),     shellPrompt myXPConfig)
    , ((mod1Mask,            xK_F5 ),     do 
                                            spawn ("date>>"++"/home/s-adm/NOTES")
                                            appendFilePrompt myXPConfig "/home/s-adm/NOTES"
                                            )
    -- в целом, этот модуль действительно более доказательство принципа, чем то, что вы можете реально использовать продуктивно.                                        
    --, ((mod1Mask,            xK_F6 ),     layoutPrompt myXPConfig)   
    
    , ((modm, xK_1), windows $ W.greedyView $ myWorkspaces !! 0) --focus workspace 1-4
    
    , ((modm,              xK_Right  ),     DO.moveTo Next HiddenNonEmptyWS)
    , ((modm,              xK_Left   ),     DO.moveTo Prev HiddenNonEmptyWS)

    -- close focused window
    , ((modm.|. shiftMask, xK_c      ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    --, ((modm,               xK_n     ), refresh)
    -- Open notes
    , ((modm,               xK_n     ), spawn "leafpad ~/NOTES")

    -- Move focus to the next window
    , ((mod1Mask,           xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Lock screen
    , ((modm .|. shiftMask, xK_l     ), spawn "~/bin/lock-screen")

    -- Screenshot using Scrot (desktop)
    , ((0,                  xK_Print ), spawn "scrot '/tmp/%Y-%m-%d-%H%M%S_$wx$h.png'")

    -- Screenshot using Scrot (selection)
    , ((modm,               xK_Print ), spawn "scrot -d 2 '/tmp/%Y-%m-%d-%H%M%S_$wx$h.png'")
    
    --, ((0,                             0xff61),     spawn "scrot -q 100 -e 'mv $f ~/Pictures/.Screenshots/ 2>/dev/null'")      --Print
    --, ((0        .|. shiftMask,        0xff61),     spawn "scrot -u -q 100 -e 'mv $f ~/Pictures/.Screenshots/ 2>/dev/null'")   --Shift+Print use the currently focused window
    --, ((mod1Mask,                      0xff61),     spawn "scrot -s -q 100 -e 'mv $f ~/Pictures/.Screenshots/ 2>/dev/null'")   --Alt+Print interactively choose a window or rectangle with the mouse
    --, ((0        .|. controlMask,      0xff61),     spawn "scrot -e 'mv $f ~/Pictures/.Screenshots/ 2>/dev/null'")             --Ctrl+Print

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)
    ,((modm .|. controlMask .|. shiftMask,xK_b),sendMessage $ SetStruts [U,L] [minBound .. maxBound])

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    
    -- to shutdown  
    --, ((modm .|. shiftMask, xK_F4    ), spawn "/home/s-adm/.scripts/poweroff.sh")
    -- to restart, shutdown, suspend or logout
    , ((mod1Mask .|. controlMask, xK_Delete), spawn "oblogout")
    -- to suspend
    --, ((modm .|. shiftMask, xK_BackSpace), spawn "/home/s-adm/.scripts/suspend.sh")

    -- play youtube videos
    , ((modm              , xK_y     ), spawn "~/bin/zenitube")

    -- Manage volume
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 10%- && ~/.xmonad/getvolume.sh >> /tmp/.volume-pipe")  
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 10%+ && ~/.xmonad/getvolume.sh >> /tmp/.volume-pipe")  
    , ((0, xF86XK_AudioMute), spawn "amixer set Master toggle && ~/.xmonad/getvolume.sh >> /tmp/.volume-pipe")
    -- Control MPD from ncmpcpp
    , ((0, xF86XK_AudioPlay),           spawn "deadbeef --play-pause")
    , ((0, xF86XK_AudioStop),           spawn "deadbeef --stop")
    , ((0, xF86XK_AudioPrev),           spawn "deadbeef --prev")
    , ((0, xF86XK_AudioNext),           spawn "deadbeef --next")
    
    -- Monitor backlight
    , ((0, xF86XK_MonBrightnessUp),     spawn "/home/s-adm/.scripts/bright_up.sh")
    , ((0, xF86XK_MonBrightnessDown),   spawn "/home/s-adm/.scripts/bright_down.sh")

    -- Keyboard backlight
    , ((0, xF86XK_KbdBrightnessDown),   spawn "~/.scripts/kbd-brightness-down.sh")
    , ((0, xF86XK_KbdBrightnessUp),     spawn "~/.scripts/kbd-brightness-up.sh")

    -- Toggle touchpad on/off
    , ((0, xF86XK_TouchpadToggle),      spawn "~/.scripts/touchpad-toggle.sh")

    -- focus urgent window
    , ((modm              , xK_BackSpace), focusUrgent)
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_a, xK_w, xK_d] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

