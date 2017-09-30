import XMonad
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.ResizableTile
import XMonad.Prompt (autoComplete)
import XMonad.Prompt.Window (windowPromptGoto, windowPromptBring)
import XMonad.Actions.FindEmptyWorkspace (viewEmptyWorkspace, tagToEmptyWorkspace)
import XMonad.Prompt.Ssh (sshPrompt)
import XMonad.Util.Run (safeSpawn)
import Graphics.X11.ExtraTypes
import XMonad.Actions.Navigation2D
import XMonad.Actions.GridSelect

winKey :: KeyMask
winKey = mod4Mask

(|=>) :: k -> a -> (k, a)
k |=> a = (k, a)

win, winShift, plain :: a -> (KeyMask, a)
win k = (winKey, k)
winShift k = (winKey .|. shiftMask, k)
plain k = (0, k)

keyBindings :: [((ButtonMask, KeySym), X ())]
keyBindings =
  win xK_a |=> sendMessage MirrorShrink :
  win xK_z |=> sendMessage MirrorExpand :
  win xK_r |=> sshPrompt def :
  win xK_g |=> windowPromptGoto def { autoComplete = Just 500000 } :
  winShift xK_g |=> windowPromptBring def :
  win xK_f |=> goToSelected def :
  win xK_m |=> viewEmptyWorkspace :
  winShift xK_m |=> tagToEmptyWorkspace :
  plain xF86XK_MonBrightnessUp |=> safeSpawn "xbacklight" ["-inc", "1"] :
  plain xF86XK_MonBrightnessDown |=> safeSpawn "xbacklight" ["-dec", "1"] :
  []

myConfig =
  ewmh $ def {
    terminal = "urxvtc", 
    modMask = winKey,
    layoutHook = smartBorders myLayout,
    handleEventHook = handleEventHook def <+> fullscreenEventHook
  } 
  `additionalKeys`
  keyBindings
  where
    myLayout = tall ||| Mirror tall ||| Full
    tall = ResizableTall { _nmaster = 1,  _delta = 3/100, _frac = 1/2, _slaves = [] }

navSetting :: XConfig a -> XConfig a
navSetting =
  navigation2D
    def
    (xK_Up, xK_Left, xK_Down, xK_Right)
    [
      win windowGo,
      winShift windowSwap
    ]
    False

main :: IO ()
main = do
  configWithXmobar <- xmobar myConfig
  xmonad $ navSetting configWithXmobar
