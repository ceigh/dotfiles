-- IMPORTS
import Data.Char
import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Util.EZConfig           -- configure keys
import XMonad.Layout.Spacing
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Hooks.DynamicLog        -- bar
import XMonad.Hooks.EwmhDesktops      -- fullscreen
import XMonad.Hooks.ManageHelpers     -- doFullFloat and other
import XMonad.Hooks.ManageDocks       -- toggleFull
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.Input
import XMonad.Prompt.Shell
import qualified XMonad.StackSet as W -- attach windows to workspaces

-- CONST
colorBlack  = "#000"
colorRed    = "#ac4142"
colorYellow = "#e5b567"
colorGreen  = "#b4c973"

-- HELPERS
-- count windows in workspace
windowCount = gets $ Just . show . length . W.integrate' .
  W.stack . W.workspace . W.current . windowset

-- make screenshot
-- fullscreen: capture root, otherwise select area
-- save: save image in filesystem, otherwise copy to clipboard
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
toggleFull = sequence_
  [ sendMessage ToggleStruts
  , toggleScreenSpacingEnabled
  , toggleWindowSpacingEnabled
  ]

term = runInTerm ""

-- quick workspaces access
ws id = myWorkspaces !! (id - 1)

-- COMMON
myWorkspaces = ["WWW", "DEV", "IRC", "RSS"] ++ map show [5..9]

-- bar
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
  , defaultPrompter   = map toUpper
  }

-- HOOKS
myStartupHook = do
  spawnOnce          "wallpaper"
  spawnOnce          "nts run"
  spawnOnOnce (ws 3) "discord"
  spawnOnOnce (ws 3) "telegram-desktop"

myLayoutHook = smartBorders $
  spacingRaw False border True border True $
  layoutTall ||| Mirror layoutTall ||| Grid
  where
    border     = Border 10 10 10 10
    layoutTall = Tall 1 (5 / 100) (2 / 3)

myManageHook = manageSpawn <+> composeAll
  [ className =? "mpv"                -->
    doFullFloat <+> moveTo (ws 4)
  -- telegram media
  , title     =? "Media viewer"       --> doFullFloat
  -- firefox pip
  , title     =? "Picture-in-Picture" -->
    doRectFloat (W.RationalRect 0.7 0.7 0.3 0.3) <+> doIgnore
  , className =? "firefox"            --> moveTo (ws 1)
  , appName   =? "discord"            --> moveTo (ws 3)
  , appName   =? "telegram-desktop"   --> moveTo (ws 3)
  ] where moveTo = doF . W.shift

-- PROMPTS
powerPrompt command = confirmPrompt myXPConfig command $
  spawn $ "systemctl " ++ command

calcPrompt = calcPrompt' "calculate"
calcPrompt' prompter = inputPrompt myXPConfig (trim prompter) ?+ calc
  where trim = f . f where f = reverse . dropWhile isSpace
        calc expr = calcPrompt' =<< liftIO (runProcessWithInput
          "sh" ["-c", "bc <<< 'scale=3; " ++ expr ++ "'"] "")

-- KEYS
m = mod4Mask

myToggleStruts XConfig { XMonad.modMask = m } = (m, xK_b)

myAdditionalKeys =
  [ ((m, xK_p),   shellPrompt myXPConfig)
  , ((m, xK_c),   calcPrompt)
  , ((m, xK_a),   term "newsboat")
  , ((m, xK_z),   term "ranger")
  , ((m, xK_F9),  term "htop")
  , ((m, xK_d),   spawn "wallpaper once")
  , ((m, xK_f),   spawn "firefox")
  , ((m, xK_F11), spawn "kb-layout")
  , ((m, xK_F12), spawn "natural-scrolling")

  , ((m .|. shiftMask, xK_m), term "neomutt")
  , ((m .|. shiftMask, xK_l), spawn "xautolock -locknow")
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
  , ((m, xK_End),                 powerPrompt "suspend")
  , ((m .|. controlMask, xK_End), powerPrompt "poweroff")
  , ((m .|. shiftMask, xK_End),   powerPrompt "reboot")

  -- screenshots
  , ((m, xK_Print),                               shot True False)
  , ((m .|. controlMask, xK_Print),               shot True True)
  , ((m .|. shiftMask, xK_Print),                 shot False False)
  , ((m .|. shiftMask .|. controlMask, xK_Print), shot False True)
  ]

-- SUMMARY
myConfig = def
  { terminal           = "alacritty"
  , workspaces         = myWorkspaces
  , borderWidth        = 1
  , normalBorderColor  = colorBlack
  , focusedBorderColor = "#777"
  , modMask            = m
  , startupHook        = myStartupHook
  , layoutHook         = myLayoutHook
  , handleEventHook    = fullscreenEventHook
  , manageHook         = myManageHook
  } `additionalKeys` myAdditionalKeys
main = xmonad =<<
  statusBar "xmobar" myPP myToggleStruts (ewmh myConfig)
