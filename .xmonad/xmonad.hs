-- IMPORTS
import XMonad
import XMonad.Util.SpawnOnce -- for start hook
import XMonad.Util.EZConfig -- to configure keys
import XMonad.Hooks.DynamicLog -- for bar
import XMonad.Hooks.EwmhDesktops -- for chromium fullscreen
import XMonad.Layout.Spacing -- for layout spacing
import XMonad.Layout.NoBorders -- to hide lonely window border

-- CONST
fontDefault = "'Iosevka Semibold-13'"
colorWhite = "#B2B2B2"
colorBlack = "#080808"
colorRed = "#FF5454"
colorYellow = "#E3C78A"
colorGreen = "#8CC85F"

run_dmenu = "dmenu_run" ++
  " -fn " ++ fontDefault ++
  " -nf " ++ "'" ++ colorWhite ++ "'" ++
  " -nb " ++ "'" ++ colorBlack ++ "'" ++
  " -sb " ++ "'" ++ colorRed ++ "'"

-- COMMON
myTerminal = "st"

myBar = "xmobar"
myPP = xmobarPP {
  ppCurrent = xmobarColor colorRed "" . wrap "<" ">",
  ppLayout = xmobarColor colorYellow "",
  ppTitle = xmobarColor colorGreen "" . shorten 70,
  ppSep = " | "
}

myBorderWidth = 5
myNormalBorderColor = colorWhite
myFocusedBorderColor = colorRed

-- KEYS
m = mod4Mask -- mod key
myModMask = m
myToggleStruts XConfig { XMonad.modMask = m } = (m, xK_b)

-- HOOKS
myStartupHook = do
  spawn "~/.bin/nts run"
  -- spawnOnce "picom &"

myLayoutHook =
  smartBorders (
    spacingRaw True (Border 10 10 10 10) True (Border 10 10 10 10) True $
      layoutHook def
  )

myHandleEventHook = fullscreenEventHook

myManageHook = composeAll
  [
    className =? "mpv" --> doFloat
  ]

-- ADDITIONAL KEYS
myAdditionalKeys =
  [
    -- dmenu
    ((m, xK_p), spawn run_dmenu),
    -- volume
    ((m, xK_equal), spawn "pulsemixer --change-volume +10"),
    ((m, xK_minus), spawn "pulsemixer --change-volume -10"),
    ((m, xK_0), spawn "pulsemixer --toggle-mute"),
    -- play radio
    ((m, xK_r), spawn "~/.bin/nts run"),
    ((m .|. shiftMask, xK_r), spawn "~/.bin/nts run 2"),
    ((m, xK_e), spawn "~/.bin/nts end"),
    -- firefox
    ((m, xK_f), spawn "firefox"),
    -- newsboat
    ((m, xK_a), spawn "st -e sh -c 'newsboat -r'"),
    -- power
    ((m, xK_End), spawn "st -e sh -c 'sudo shutdown now'"),
    ((m .|. shiftMask, xK_End), spawn "st -e sh -c 'sudo reboot'"),
    -- screenshots
    ((m, xK_Print), spawn "import -window root $HOME/pictures/`date +%d-%m-%H:%M`.png")
  ]

-- SUMMARY
myConfig = def {
  terminal = myTerminal,
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
