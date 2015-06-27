import XMonad
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.ResizableTile
import XMonad.Prompt (defaultXPConfig, autoComplete)
import XMonad.Prompt.Window (windowPromptGoto, windowPromptBring)
import XMonad.Actions.FindEmptyWorkspace (viewEmptyWorkspace, tagToEmptyWorkspace)
import XMonad.Prompt.Ssh (sshPrompt)
import XMonad.Util.Run (safeSpawn, safeSpawnProg)
import Graphics.X11.ExtraTypes
import XMonad.Hooks.SetWMName
import XMonad.Actions.WindowNavigation
import XMonad.Actions.GridSelect
import Control.Monad (void)

myMask :: KeyMask
myMask = mod4Mask

keyBindings :: [((ButtonMask, KeySym), X ())]
keyBindings =
  plain xK_Print |=> safeSpawnProg "dmenu_run" :
  mod xK_p |=> safeSpawnProg "dmenu_run" : -- override of default
  plain xK_Menu |=> safeSpawnProg (terminal myConfig) :
  mod xK_a |=> sendMessage MirrorShrink :
  mod xK_z |=> sendMessage MirrorExpand :
  mod xK_r |=> sshPrompt defaultXPConfig :
  mod xK_g |=> windowPromptGoto defaultXPConfig { autoComplete = Just 500000 } :
  modShift xK_g |=> windowPromptBring defaultXPConfig :
  mod xK_f |=> goToSelected defaultGSConfig :
  mod xK_m |=> viewEmptyWorkspace :
  modShift xK_m |=> tagToEmptyWorkspace :
  plain xF86XK_MonBrightnessUp |=> safeSpawn "xbacklight" ["-inc", "2"] :
  plain xF86XK_MonBrightnessDown |=> safeSpawn "xbacklight" ["-dec", "2"] :
  []
  where
    k |=> a = (k, a)
    mod k = (myMask, k)
    modShift k = (myMask .|. shiftMask, k)
    plain k = (0, k)

myConfig =
  ewmh $ defaultConfig {
    terminal = "urxvtc", 
    modMask = myMask,
    layoutHook = smartBorders myLayout,
    handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook
    --startupHook = setWMName "LG3D"
  } 
  `additionalKeys`
  keyBindings
  where
    myLayout = tall ||| Mirror tall ||| Full
    tall = ResizableTall { _nmaster = 1,  _delta = 3/100, _frac = 1/2, _slaves = [] }

main :: IO ()
main =
  statusBar "xmobar" statusBarSettings toggleStrutsKey myConfig >>=
  withWindowNavigation (xK_Up, xK_Left, xK_Down, xK_Right) >>=
  xmonad
    where
      statusBarSettings = xmobarPP { ppTitle = xmobarColor "green" ""}
      toggleStrutsKey _ = (myMask, xK_s)

