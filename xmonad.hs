import XMonad
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.ResizableTile
import XMonad.Hooks.ManageDocks
import XMonad.Prompt (autoComplete)
import XMonad.Prompt.Window (windowPromptGoto, windowPromptBring)
import XMonad.Actions.FindEmptyWorkspace (viewEmptyWorkspace, tagToEmptyWorkspace)
import XMonad.Prompt.Ssh (sshPrompt)
import XMonad.Util.Run (safeSpawn)
import Graphics.X11.ExtraTypes
import XMonad.Actions.Navigation2D
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleRecentWS (cycleRecentWS)
import XMonad.Actions.Volume (raiseVolume, lowerVolume, toggleMute, osdCat, defaultOSDOpts)
import qualified XMonad.Util.Brightness as Brightness
import Control.Monad (void)
import Data.Monoid ((<>))

inc, dec :: MonadIO m => Int -> m ()
inc i = liftIO $ void $ Brightness.change (+ i)
dec i = liftIO $ void $ Brightness.change (subtract i)

winKey :: KeyMask
winKey = mod4Mask

(|=>) :: k -> a -> (k, a)
k |=> a = (k, a)

win, winShift, plain :: a -> (KeyMask, a)
win k = (winKey, k)
winShift k = (winKey .|. shiftMask, k)
plain k = (0, k)

mprisCmd :: MonadIO m => String -> m ()
mprisCmd cmd = safeSpawn "playerctl" [cmd]

keyBindings :: [((ButtonMask, KeySym), X ())]
keyBindings =
  win xK_a |=> sendMessage MirrorShrink :
  win xK_z |=> sendMessage MirrorExpand :
  win xK_r |=> sshPrompt def :
  win xK_g |=> windowPromptGoto def { autoComplete = Just 500000 } :
  winShift xK_g |=> windowPromptBring def :
  win xK_f |=> goToSelected def :
  winShift xK_f |=> focusUrgent :
  win xK_m |=> viewEmptyWorkspace :
  winShift xK_m |=> tagToEmptyWorkspace :
  plain xF86XK_MonBrightnessUp |=> inc 20:
  plain xF86XK_MonBrightnessDown |=> dec 20:
  win xF86XK_MonBrightnessUp |=> inc 1:
  win xF86XK_MonBrightnessDown |=> dec 1:
  plain xF86XK_AudioLowerVolume |=> vol lowerVolume :
  plain xF86XK_AudioRaiseVolume |=> vol raiseVolume :
  plain xF86XK_AudioMute |=> void toggleMute :
  win xF86XK_AudioLowerVolume |=> mprisCmd "previous" :
  win xF86XK_AudioRaiseVolume |=> mprisCmd "next" :
  win xF86XK_AudioMute |=> mprisCmd "play-pause" :
  win xK_b |=> sendMessage ToggleStruts :
  win xK_grave |=> cycleRecentWS [xK_Super_L] xK_grave xK_grave :
  []

vol :: Functor f => (Double -> f Double) -> f ()
vol action = void $ action 2.0

configMods = docks . navSetting . withUrgencyHook (BorderUrgencyHook "#FFD700") . ewmh

myConfig =
  def {
    terminal = "urxvtc", 
    modMask = winKey,
    layoutHook = avoidStruts $ smartBorders myLayout,
    handleEventHook = handleEventHook def <> fullscreenEventHook,
    startupHook = startupHook def *> setWMName "LG3D"
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
main = xmobar (configMods myConfig) >>= xmonad
