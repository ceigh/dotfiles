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
import XMonad.Hooks.ManageHelpers     -- doFullFloat and other
import qualified XMonad.StackSet as W -- attach windows to workspaces
import Data.Char (toUpper)            -- to uppercase strings

-- CONST
colorRed    = "#ac4142"
colorYellow = "#e5b567"
colorGreen  = "#b4c973"

-- COMMON
-- terminal
myTerminal = "st"

-- open terminal and run command
term :: String -> String
term command = myTerminal ++ " -e sh -c \"" ++ command ++ "\" &"

-- commands
runNewsboat = term "newsboat --refresh-on-start"
runMutt     = term "neomutt"

-- make screenshot
-- fullscreen: capture root, otherwise select area
-- save: save image in filesystem, otherwise copy to clipboard
shot :: Bool -> Bool -> X()
shot fullscreen save
  | fullscreen     && save     = spawn $ root ++ file ++ bg
  | fullscreen     && not save = spawn $ root ++ clip ++ bg
  | not fullscreen && save     = spawn $ area ++ file ++ bg
  | not fullscreen && not save = spawn $ area ++ clip ++ bg
  where
    root   = "import -window root "
    area   = "import "
    file   = "$HOME/pictures/screenshots/`date +%d-%m-%H:%M`.png"
    clip   = "png:- | xclip -selection clipboard -target image/png"
    bg     = " &"

-- workspaces
ws1 = "1"
ws2 = "2"
ws3 = "3"
ws4 = "4"
myWorkspaces = [ws1, ws2, ws3, ws4] ++ map show [5..9]

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' .
  W.stack . W.workspace . W.current . windowset

-- bar
myBar = "xmobar"
myPP  = xmobarPP
  { ppCurrent = xmobarColor colorGreen  "" . wrap "<" ">"
  , ppUrgent  = xmobarColor colorRed    "" . wrap "*" "*"
  , ppLayout  = take 128 . drop 8 . map toUpper
  , ppTitle   = shorten 32 . map toUpper
  , ppExtras  = [windowCount]
  , ppSep     = " | "
  , ppOrder = \(ws:l:t:ex) -> [ws, l] ++ ex ++ [t]
  }

-- border
myBorderWidth        = 1
myNormalBorderColor  = "#000"
myFocusedBorderColor = "#575657"

-- KEYS
m = mod4Mask
myModMask = m
myToggleStruts XConfig { XMonad.modMask = m } = (m, xK_b)

-- HOOKS
myStartupHook = do
  spawnOnce       "wallpaper &"
  spawnOnce       "nts run &"
  spawnOnOnce ws3 "discord &"
  spawnOnOnce ws3 "telegram-desktop &"

myLayoutHook = smartBorders $ spacingRaw
  False (Border 20 20 20 20) True (Border 10 10 10 10) True $
  layoutTall ||| layoutMirrorTall ||| Grid ||| layoutSpiral ||| Full
    where
      layoutTall       = Tall 1 (5 / 100) (2 / 3)
      layoutMirrorTall = Mirror (Tall 1 (5 / 100) (2 / 3))
      layoutSpiral     = spiral (6 / 7)

myHandleEventHook = fullscreenEventHook

myManageHook = manageSpawn <+> composeAll
  [ className =? "mpv"              --> doFloat
  , title     =? "Media viewer"     --> doFullFloat  -- telegram media
  , className =? "firefox"          --> moveTo ws1
  , appName   =? "discord"          --> moveTo ws3
  , appName   =? "telegram-desktop" --> moveTo ws3
  ] where moveTo = doF . W.shift

-- ADDITIONAL KEYS
myAdditionalKeys =
  [ ((m, xK_p),               spawn "rofi -show run") -- rofi
  , ((m .|. shiftMask, xK_p), spawn "rofi -show")
  , ((m, xK_a),               spawn runNewsboat)      -- newsboat
  , ((m, xK_f),               spawn "firefox &")      -- firefox
  , ((m, xK_z),               spawn $ term "ranger")  -- ranger
  , ((m .|. shiftMask, xK_m), spawn runMutt)          -- mutt

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
  , ((m, xK_End), spawn $
      term "echo 'Press enter to suspend' && read && systemctl suspend")
  , ((m .|. controlMask, xK_End), spawn $
      term "echo 'Press enter to shutdown' && read && systemctl poweroff")
  , ((m .|. shiftMask, xK_End), spawn $
      term "echo 'Press enter to reboot' && read && systemctl reboot")

  -- screenshots
  , ((m, xK_Print),                               shot True False)
  , ((m .|. controlMask, xK_Print),               shot True True)
  , ((m .|. shiftMask, xK_Print),                 shot False False)
  , ((m .|. shiftMask .|. controlMask, xK_Print), shot False True)

  -- change wallpaper
  , ((m, xK_d), spawn "wallpaper once &")

  -- htop
  , ((m, xK_F9), spawn $ term "htop")

  -- restore keyboard layout
  , ((m, xK_F11), spawn "kb-layout")

  -- restore natural scrolling
  , ((m, xK_F12), spawn "natural-scrolling")
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
