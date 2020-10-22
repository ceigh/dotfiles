-- IMPORTS
import XMonad
import XMonad.Util.SpawnOnce -- for start hook
import XMonad.Actions.SpawnOn -- pin windows to workspaces
import XMonad.Util.EZConfig -- to configure keys
import XMonad.Hooks.DynamicLog -- for bar
import XMonad.Hooks.EwmhDesktops -- for chromium fullscreen
import XMonad.Layout.Spacing -- for layout spacing
import XMonad.Layout.NoBorders -- to hide lonely window border
import qualified XMonad.StackSet as W -- attach windows to workspaces

-- CONST
fontDefault = "'Iosevka Semibold-13'"
colorWhite = "#B2B2B2"
colorBlack = "#080808"
colorRed = "#FF5454"
colorYellow = "#E3C78A"
colorGreen = "#8CC85F"

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
runMutt     = term "mutt"
runUpgrade  = term "echo 'Trying to upgrade...' && sudo pacman -Syu; read"

-- workspaces
ws1 = "1:WWW"
ws2 = "2:ZSH"
ws3 = "3:IRC"
ws4 = "4:VID"
myWorkspaces = [ws1, ws2, ws3, ws4] ++ map show [5..9]

-- bar
myBar = "xmobar"
myPP = xmobarPP {
  ppCurrent = xmobarColor colorRed "" . wrap "<" ">",
  ppLayout = xmobarColor colorYellow "",
  ppTitle = xmobarColor colorGreen "" . shorten 70,
  ppSep = " | "
}

-- border
myBorderWidth = 5
myNormalBorderColor = colorWhite
myFocusedBorderColor = colorRed

-- KEYS
m = mod4Mask -- mod key
myModMask = m
myToggleStruts XConfig { XMonad.modMask = m } = (m, xK_b)

-- HOOKS
myStartupHook = do
  spawnOnce "picom --experimental-backends &"
  spawnOnce "dunst &"
  spawnOnce "wallpaper-unsplash &"
  spawnOnce "nts run &"
  spawnOnce "firefox &"
  spawnOnce runNewsboat
  spawnOnce runMutt
  spawnOnOnce ws2 runUpgrade
  spawnOnOnce ws3 "ripcord &"
  spawnOnOnce ws3 "telegram-desktop &"

myLayoutHook =
  smartBorders (
    spacingRaw True (Border 10 10 10 10) True (Border 10 10 10 10) True $
      layoutHook def
  )

myHandleEventHook = fullscreenEventHook

myManageHook = manageSpawn <+> composeAll
  [ className =? "mpv"              --> doFloat
  , className =? "firefox"          --> moveTo ws1
  , appName   =? "ripcord"          --> moveTo ws3
  , appName   =? "telegram-desktop" --> moveTo ws3
  ] where moveTo = doF . W.shift

-- ADDITIONAL KEYS
myAdditionalKeys =
  [
    -- dmenu
    ((m, xK_p), spawn runDmenu),
    -- newsboat
    ((m, xK_a), spawn runNewsboat),
    -- firefox
    ((m, xK_f), spawn "firefox &"),
    -- ranger
    ((m, xK_z), spawn (term "ranger")),
    -- upgrade
    ((m .|. shiftMask, xK_y), spawn runUpgrade),

    -- play radio
    ((m, xK_r), spawn "nts run &"),
    ((m .|. shiftMask, xK_r), spawn "nts run 2 &"),
    ((m, xK_e), spawn "nts end &"),

    -- volume
    ((m, xK_equal), spawn "pulsemixer --change-volume +10 &"),
    ((m, xK_minus), spawn "pulsemixer --change-volume -10 &"),
    ((m, xK_0), spawn "pulsemixer --toggle-mute &"),

    -- lock screen
    ((m .|. shiftMask, xK_l), spawn "xscreensaver-command -lock &"),

    -- power
    ((m, xK_End), spawn (term "sudo shutdown now")),
    ((m .|. shiftMask, xK_End), spawn (term "sudo reboot")),

    -- screenshots
    ((m, xK_Print),
      spawn "import -window root $HOME/pictures/`date +%d-%m-%H:%M`.png &"),

    -- change wallpaper
    ((m, xK_d), spawn "wallpaper-unsplash once &")
  ]

-- SUMMARY
myConfig = def {
  terminal = myTerminal,
  workspaces = myWorkspaces,
  borderWidth = myBorderWidth,
  normalBorderColor = myNormalBorderColor,
  focusedBorderColor = myFocusedBorderColor,

  -- keys
  modMask = myModMask,

  -- hooks
  startupHook = myStartupHook,
  layoutHook = myLayoutHook,
  handleEventHook = myHandleEventHook,
  manageHook = myManageHook
} `additionalKeys` myAdditionalKeys

main = xmonad =<< statusBar myBar myPP myToggleStruts myConfig
