-- IMPORTS
import XMonad
import XMonad.Util.SpawnOnce -- for start hook
import XMonad.Util.EZConfig -- to configure keys
import XMonad.Hooks.DynamicLog -- for bar
import XMonad.Hooks.EwmhDesktops -- for chromium fullscreen
import XMonad.Layout.Spacing -- for layout spacing
import XMonad.Layout.NoBorders -- to hide lonely window border

-- CONST
font_default = "'Iosevka Semibold-12'"
color_white = "#B2B2B2"

run_dmenu = "dmenu_run" ++
  " -fn " ++ font_default ++
  " -nf " ++ "'" ++ color_white ++ "'" ++
  " -nb '#080808' -sb '#8CC85F'"

-- COMMON
myTerminal = "st"

myBorderWidth = 5
myNormalBorderColor = color_white
myFocusedBorderColor = "#FF5454"

myModMask = mod4Mask -- mod key

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

main = xmonad =<< xmobar myConfig
