-- IMPORTS
import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig           -- configure keys
import XMonad.Layout.Spacing
import XMonad.Layout.Accordion
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Hooks.DynamicLog        -- bar
import XMonad.Hooks.EwmhDesktops      -- fullscreen
import XMonad.Hooks.ManageHelpers     -- doFullFloat and other
import XMonad.Hooks.ManageDocks       -- toggleFull
import XMonad.Prompt
import XMonad.Prompt.Shell
import qualified XMonad.StackSet as W -- attach windows to workspaces
import Data.Char (toUpper)

-- CONST
colorBlack  = "#000"
colorRed    = "#ac4142"
colorYellow = "#e5b567"
colorGreen  = "#b4c973"

-- HELPERS
-- count windows in workspace
windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' .
  W.stack . W.workspace . W.current . windowset

-- make screenshot
-- fullscreen: capture root, otherwise select area
-- save: save image in filesystem, otherwise copy to clipboard
shot :: Bool -> Bool -> X()
shot fullscreen save
  | fullscreen     && save     = spawn $ root ++ file
  | fullscreen     && not save = spawn $ root ++ clip
  | not fullscreen && save     = spawn $ area ++ file
  | not fullscreen && not save = spawn $ area ++ clip
  where
    root   = "import -window root "
    area   = "import "
    file   = "$HOME/pictures/screenshots/`date +%d-%m-%H:%M`.png"
    clip   = "png:- | xclip -selection clipboard -target image/png"

-- toggle fullscreen
toggleFull :: X()
toggleFull = sequence_
  [ sendMessage ToggleStruts
  , toggleScreenSpacingEnabled
  , toggleWindowSpacingEnabled
  ]

-- open terminal and run command
run :: String -> X()
run command = spawn $
  myTerminal ++ " -e sh -c '" ++ command ++ "'"

-- COMMON
myTerminal = "st"

-- workspaces
ws1 = "WWW"
ws2 = "DEV"
ws3 = "IRC"
ws4 = "RSS"
myWorkspaces = [ws1, ws2, ws3, ws4] ++ map show [5..9]

-- bar
myBar = "xmobar"
myPP  = xmobarPP
  { ppCurrent = xmobarColor colorGreen "" . wrap "<" ">"
  , ppUrgent  = xmobarColor colorRed   "" . wrap "*" "*"
  , ppLayout  = take 128 . drop 8 . map toUpper
  , ppTitle   = shorten 64 . map toUpper
  , ppExtras  = [windowCount]
  , ppSep     = " | "
  , ppOrder = \(ws:l:t:ex) -> [ws, l] ++ ex ++ [t]
  }

-- prompt
myXPConfig = def
  { font              = "xft:monospace:size=11"
  , bgColor           = colorBlack
  , fgColor           = "#d6d6d6"
  , bgHLight          = colorGreen
  , promptBorderWidth = 0
  , position          = Top
  , alwaysHighlight   = True
  , height            = 20
  , maxComplRows      = Just 5
  , historySize       = 64
  , autoComplete      = Just 0
  }

-- border
myBorderWidth        = 1
myNormalBorderColor  = colorBlack
myFocusedBorderColor = "#555"

-- HOOKS
myHandleEventHook = fullscreenEventHook

myStartupHook = do
  spawnOnce       "wallpaper"
  spawnOnce       "nts run"
  spawnOnOnce ws3 "discord"
  spawnOnOnce ws3 "telegram-desktop"

myLayoutHook = smartBorders $
  spacingRaw False border True border True $
  layoutTall ||| Accordion ||| Grid
  where
    border     = Border 10 10 10 10
    layoutTall = Tall 1 (5 / 100) (2 / 3)

myManageHook = manageSpawn <+> composeAll
  [ className =? "mpv"              --> doFullFloat
  , title     =? "Media viewer"     --> doFullFloat
  , className =? "firefox"          --> moveTo ws1
  , appName   =? "discord"          --> moveTo ws3
  , appName   =? "telegram-desktop" --> moveTo ws3
  ] where moveTo = doF . W.shift

-- KEYS
-- common
m = mod4Mask
myModMask = m
myToggleStruts XConfig { XMonad.modMask = m } = (m, xK_b)

-- additional
myAdditionalKeys =
  [ ((m, xK_p),   shellPrompt myXPConfig)
  , ((m, xK_v),   run "nvim")
  , ((m, xK_a),   run "newsboat --refresh-on-start")
  , ((m, xK_z),   run "ranger")
  , ((m, xK_F9),  run "htop")
  , ((m, xK_d),   spawn "wallpaper once")
  , ((m, xK_f),   spawn "firefox")
  , ((m, xK_F11), spawn "kb-layout")
  , ((m, xK_F12), spawn "natural-scrolling")

  , ((m .|. shiftMask, xK_m), run "neomutt")
  , ((m .|. shiftMask, xK_l), spawn "slock")
  , ((m .|. shiftMask, xK_b), toggleFull)

  -- radio
  , ((m, xK_r),               spawn "nts run")
  , ((m .|. shiftMask, xK_r), spawn "nts run 2")
  , ((m, xK_e),               spawn "nts end")

  -- volume
  , ((m, xK_equal), spawn "pulsemixer --change-volume +10")
  , ((m, xK_minus), spawn "pulsemixer --change-volume -10")
  , ((m, xK_0),     spawn "pulsemixer --toggle-mute")

  -- power
  , ((m, xK_End),
    run "echo Suspend? && read && systemctl suspend")
  , ((m .|. controlMask, xK_End),
    run "echo Shutdown? && read && systemctl poweroff")
  , ((m .|. shiftMask, xK_End),
    run "echo Reboot? && read && systemctl reboot")

  -- screenshots
  , ((m, xK_Print),                               shot True False)
  , ((m .|. controlMask, xK_Print),               shot True True)
  , ((m .|. shiftMask, xK_Print),                 shot False False)
  , ((m .|. shiftMask .|. controlMask, xK_Print), shot False True)
  ]

-- SUMMARY
myConfig = def
  { terminal           = myTerminal
  , workspaces         = myWorkspaces
  , borderWidth        = myBorderWidth
  , normalBorderColor  = myNormalBorderColor
  , focusedBorderColor = myFocusedBorderColor
  , modMask            = myModMask
  , startupHook        = myStartupHook
  , layoutHook         = myLayoutHook
  , handleEventHook    = myHandleEventHook
  , manageHook         = myManageHook
  } `additionalKeys` myAdditionalKeys
main = xmonad =<< statusBar myBar myPP myToggleStruts (ewmh myConfig)
