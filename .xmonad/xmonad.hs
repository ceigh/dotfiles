-- IMPORTS
import XMonad
import XMonad.Util.SpawnOnce          -- start hook
import XMonad.Actions.SpawnOn         -- pin windows to workspaces
import XMonad.Util.EZConfig           -- configure keys
import XMonad.Hooks.DynamicLog        -- bar
import XMonad.Layout.Spacing          -- layout spacing
import XMonad.Layout.Spiral           -- spiral layout
import XMonad.Layout.Grid             -- grid layout
import XMonad.Layout.NoBorders        -- hide lonely window border
import XMonad.Hooks.EwmhDesktops      -- steam games
import qualified XMonad.StackSet as W -- attach windows to workspaces

-- CONST
fontDefault = "'Iosevka Medium-12'"

colorWhite  = "#B2B2B2"
colorBlack  = "#080808"
colorRed    = "#FF5454"
colorYellow = "#E3C78A"
colorGreen  = "#8CC85F"

-- COMMON
-- terminal
myTerminal = "st"

-- open terminal and run command
term :: String -> String
term command = myTerminal ++ " -e sh -c \"" ++ command ++ "\" &"

-- commands
runDmenu = "dmenu_run" ++
  " -fn " ++ fontDefault ++
  " -nf " ++ "'" ++ colorWhite ++ "'" ++
  " -nb " ++ "'" ++ colorBlack ++ "'" ++
  " -sb " ++ "'" ++ colorRed ++ "' &"
runNewsboat = term "newsboat --refresh-on-start"
runMutt     = term "neomutt"

-- workspaces
ws1 = "WWW"
ws2 = "ZSH"
ws3 = "IRC"
ws4 = "VID"
ws5 = "DOC"
ws6 = "GAM"
myWorkspaces = [ws1, ws2, ws3, ws4, ws5, ws6] ++ map show [7..9]

-- bar
myBar = "xmobar"
myPP  = xmobarPP
  { ppCurrent = xmobarColor colorRed    "" . wrap "<" ">"
  , ppLayout  = xmobarColor colorYellow ""
  , ppTitle   = xmobarColor colorGreen  "" . shorten 50
  , ppSep     = " | "
  }

-- border
myBorderWidth        = 5
myNormalBorderColor  = colorWhite
myFocusedBorderColor = colorRed

-- KEYS
m = mod4Mask
myModMask = m
myToggleStruts XConfig { XMonad.modMask = m } = (m, xK_b)

-- HOOKS
myStartupHook = do
  spawnOnce       "picom &"
  spawnOnce       "slock &"
  spawnOnce       "dunst &"
  spawnOnce       "wallpaper-unsplash &"
  spawnOnce       "nts run &"
  spawnOnce       "firefox &"
  spawnOnce       runNewsboat
  spawnOnce       runMutt
  spawnOnOnce ws3 "discord &"
  spawnOnOnce ws3 "telegram-desktop &"

myLayoutHook = smartBorders $
  spacingRaw True (Border 10 10 10 10) True (Border 10 10 10 10) True $
  layoutTall ||| layoutMirrorTall ||| Grid ||| layoutSpiral ||| Full
    where
      layoutTall       = Tall 1 (5 / 100) (2 / 3)
      layoutMirrorTall = Mirror (Tall 1 (5 / 100) (2 / 3))
      layoutSpiral     = spiral (6 / 7)

myHandleEventHook = fullscreenEventHook

myManageHook = manageSpawn <+> composeAll
  [ className =? "mpv"              --> doFloat
  , title     =? "Media viewer"     --> doFloat    -- telegram media
  , className =? "firefox"          --> moveTo ws1
  , appName   =? "discord"          --> moveTo ws3
  , appName   =? "telegram-desktop" --> moveTo ws3
  ] where moveTo = doF . W.shift

-- ADDITIONAL KEYS
myAdditionalKeys =
  [ ((m, xK_p),               spawn runDmenu)        -- dmenu
  , ((m, xK_a),               spawn runNewsboat)     -- newsboat
  , ((m, xK_f),               spawn "firefox &")     -- firefox
  , ((m, xK_z),               spawn $ term "ranger") -- ranger
  , ((m .|. shiftMask, xK_m), spawn runMutt)         -- mutt

  -- radio
  , ((m, xK_r),               spawn "nts run &")
  , ((m .|. shiftMask, xK_r), spawn "nts run 2 &")
  , ((m, xK_e),               spawn "nts end &")

  -- volume
  , ((m, xK_equal), spawn "pulsemixer --change-volume +10 &")
  , ((m, xK_minus), spawn "pulsemixer --change-volume -10 &")
  , ((m, xK_0),     spawn "pulsemixer --toggle-mute &")

  -- lock screen
  -- , ((m .|. shiftMask, xK_l), spawn "xscreensaver-command -lock &")
  , ((m .|. shiftMask, xK_l), spawn "slock")

  -- power
  , ((m, xK_End),               spawn $ term "sudo shutdown now")
  , ((m .|. shiftMask, xK_End), spawn $ term "sudo reboot")

  -- screenshots
  , ((m, xK_Print), spawn "import -window root $HOME/pictures/screenshots/`date +%d-%m-%H:%M`.png &")

  -- change wallpaper
  , ((m, xK_d), spawn "wallpaper-unsplash once &")

  -- htop
  , ((m, xK_F9), spawn $ term "htop")
  ]

-- CONFIG
myConfig = def
  { terminal = myTerminal
  , workspaces = myWorkspaces
  , borderWidth = myBorderWidth
  , normalBorderColor = myNormalBorderColor
  , focusedBorderColor = myFocusedBorderColor

  -- keys
  , modMask = myModMask

  -- hooks
  , startupHook = myStartupHook
  , layoutHook = myLayoutHook
  , handleEventHook = myHandleEventHook
  , manageHook = myManageHook
  } `additionalKeys` myAdditionalKeys

main = xmonad =<< statusBar myBar myPP myToggleStruts (ewmh myConfig)
