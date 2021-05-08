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
colorBlack  = "black"
colorWhite  = "white"

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

term = runInTerm ""

-- quick workspaces access
ws id = myWorkspaces !! (id - 1)

-- COMMON
myWorkspaces = map show [1..9]

-- bar
myPP  = xmobarPP
  { ppCurrent = xmobarColor colorWhite "" . wrap "(" ")"
  , ppTitle   = shorten 64
  , ppExtras  = [windowCount]
  , ppSep     = "   "
  , ppOrder = \(ws:l:t:ex) -> [ws, l] ++ ex ++ [t]
  }

-- prompt
myXPConfig = def
  { font              = "xft:monospace:size=10"
  , bgColor           = colorBlack
  , fgColor           = colorWhite
  , bgHLight          = colorWhite
  , promptBorderWidth = 0
  , position          = Top
  , alwaysHighlight   = True
  , height            = 20
  , maxComplRows      = Just 5
  , historySize       = 64
  , autoComplete      = Just 0
  }

-- HOOKS
myStartupHook = do
  spawnOnce          "epic-bg"
  spawnOnce          "nts run"
  spawnOnOnce (ws 3) "telegram-desktop"

myLayoutHook = smartBorders $
  layoutTall ||| Mirror layoutTall ||| Grid
  where
    layoutTall = Tall 1 (5 / 100) (2 / 3)

myManageHook = manageSpawn <+> composeAll
  [ className =? "mpv"                -->
    doFullFloat <+> moveTo (ws 4)
  -- telegram media
  , title     =? "Media viewer"       --> doFullFloat
  -- firefox pip
  , title     =? "Picture-in-Picture" -->
    doRectFloat (W.RationalRect 0.7 0.7 0.3 0.3)
  , className =? "firefox"            --> moveTo (ws 1)
  , appName   =? "telegram-desktop"   --> moveTo (ws 3)
  ] where moveTo = doF . W.shift

-- PROMPTS
calcPrompt = calcPrompt' "Calculate"
calcPrompt' prompter = inputPrompt myXPConfig (trim prompter) ?+ calc
  where trim = f . f where f = reverse . dropWhile isSpace
        calc expr = calcPrompt' =<< liftIO (runProcessWithInput
          "sh" ["-c", "echo 'scale=3; " ++ expr ++ "' | bc"] "")

-- KEYS
m = mod4Mask

myToggleStruts XConfig { XMonad.modMask = m } = (m, xK_b)

myAdditionalKeys =
  [ ((m, xK_p), shellPrompt myXPConfig)
  , ((m, xK_c), calcPrompt)
  , ((m, xK_v), term "nvim")
  , ((m, xK_a), term "newsboat")
  , ((m, xK_z), term "ranger")
  , ((m, xK_o), term "htop")
  , ((m, xK_f), spawn "firefox")

  , ((m .|. shiftMask, xK_m), term "neomutt")
  , ((m .|. shiftMask, xK_l), spawn "xautolock -locknow")

  -- radio
  , ((m, xK_r),               spawn "nts run")
  , ((m .|. shiftMask, xK_r), spawn "nts run 2")
  , ((m, xK_e),               spawn "nts end")

  -- screenshots
  , ((m, xK_Print),                               shot True False)
  , ((m .|. controlMask, xK_Print),               shot True True)
  , ((m .|. shiftMask, xK_Print),                 shot False False)
  , ((m .|. shiftMask .|. controlMask, xK_Print), shot False True)

  -- volume with media keys
  , ((0, 0x1008ff11), spawn "mixer vol -10")
  , ((0, 0x1008ff13), spawn "mixer vol +10")
  ]

-- SUMMARY
myConfig = def
  { terminal           = "xterm"
  , workspaces         = myWorkspaces
  , normalBorderColor  = "black"
  , focusedBorderColor = "white"
  , borderWidth        = 1
  , modMask            = m
  , startupHook        = myStartupHook
  , layoutHook         = myLayoutHook
  , handleEventHook    = fullscreenEventHook
  , manageHook         = myManageHook
  } `additionalKeys` myAdditionalKeys
main = xmonad =<<
  statusBar "xmobar" myPP myToggleStruts (ewmh myConfig)
