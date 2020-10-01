-- IMPORTS
import XMonad
import XMonad.Util.SpawnOnce -- for start hook
import XMonad.Util.EZConfig -- to configure keys
import XMonad.Hooks.DynamicLog -- for bar
import XMonad.Hooks.EwmhDesktops -- for chromium fullscreen
import XMonad.Layout.Spacing -- for layout spacing
import XMonad.Layout.NoBorders -- to hide lonely window border

-- COMMON
myTerminal = "st"

myBorderWidth = 5
myNormalBorderColor = "#B2B2B2"
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
} `additionalKeys` [((mod4Mask, xK_p), spawn "dmenu_run -fn 'Iosevka Semibold-12' -nb '#080808' -nf '#B2B2B2' -sb '#8CC85F'")]

main = xmonad =<< xmobar myConfig
