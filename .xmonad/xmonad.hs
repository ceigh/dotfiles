-- IMPORTS
import XMonad
import XMonad.Util.SpawnOnce -- for start hook
import XMonad.Util.EZConfig -- to configure keys
import XMonad.Hooks.DynamicLog -- for bar
import XMonad.Hooks.EwmhDesktops -- for chromium fullscreen
import XMonad.Layout.Spacing -- for layout spacing
import XMonad.Layout.NoBorders -- to hide lonely window border

-- CONST
fontDefault = "'Iosevka Semibold-12'"
colorWhite = "#B2B2B2"
colorRed = "#FF5454"

run_dmenu = "dmenu_run" ++
  " -fn " ++ fontDefault ++
  " -nf " ++ "'" ++ colorWhite ++ "'" ++
  " -nb '#080808' -sb '#8CC85F'"

-- COMMON
myTerminal = "st"

myBar = "xmobar"
myPP = xmobarPP {
  ppCurrent = xmobarColor colorRed "" . wrap "<" ">",
  ppLayout = xmobarColor "#E3C78A" "",
  ppTitle = xmobarColor "#8CC85F" "" . shorten 100,
  ppSep = " | "
}

myBorderWidth = 5
myNormalBorderColor = colorWhite
myFocusedBorderColor = colorRed

-- KEYS
myModMask = mod4Mask -- mod key
myToggleStruts XConfig { XMonad.modMask = myModMask } = (myModMask, xK_b)

-- HOOKS
myStartupHook = do
  spawnOnce "nitrogen --restore &"
  -- spawnOnce "picom &"

myLayoutHook =
  smartBorders (
    spacingRaw True (Border 0 10 10 10) True (Border 10 10 10 10) True $
      layoutHook def
  )

myHandleEventHook = fullscreenEventHook

-- ADDITIONAL KEYS
myAdditionalKeys =
  [
    ((myModMask, xK_p), spawn run_dmenu)
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
  handleEventHook = myHandleEventHook
} `additionalKeys` myAdditionalKeys

main = xmonad =<< statusBar myBar myPP myToggleStruts myConfig
