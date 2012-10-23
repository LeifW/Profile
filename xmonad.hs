import XMonad
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.ResizableTile
import XMonad.Prompt (defaultXPConfig, autoComplete)
import XMonad.Prompt.Window (windowPromptGoto, windowPromptBring)
import XMonad.Actions.FindEmptyWorkspace (viewEmptyWorkspace, tagToEmptyWorkspace)
import XMonad.Prompt.Ssh (sshPrompt)
import XMonad.Actions.Volume (raiseVolumeChannels, lowerVolumeChannels, toggleMute, osdCat)
import XMonad.Prompt.MPD (addAndPlay)
import Network.MPD (withMPD, stop, previous, next, Metadata (..))
import Network.MPD.Commands.Extensions (toggle)
import XMonad.Util.Run (safeSpawnProg)
import Graphics.X11.ExtraTypes
import XMonad.Hooks.SetWMName
import XMonad.Actions.WindowNavigation
import XMonad.Actions.GridSelect
import Control.Monad (void)

myMask :: KeyMask
myMask = mod4Mask

myConfig = defaultConfig {
             terminal = "urxvtc", 
             modMask = myMask,
             layoutHook = smartBorders myLayout,
             startupHook = setWMName "LG3D"
           }
           `additionalKeys`
           [  ((0, xK_Print), safeSpawnProg "dmenu_run") ,
             ((myMask, xK_p), safeSpawnProg "dmenu_run") , -- override of default
             ((0, xK_Menu), safeSpawnProg $ terminal myConfig) ,
             ((myMask, xK_a), sendMessage MirrorShrink) ,
             ((myMask, xK_z), sendMessage MirrorExpand) ,
             ((0, xK_F7), vol lowerVolumeChannels 2), 
             ((0, xK_F8), vol raiseVolumeChannels 2),
             ((0, xF86XK_AudioLowerVolume), vol lowerVolumeChannels 2), 
             ((0, xF86XK_AudioRaiseVolume), vol raiseVolumeChannels 2),
             ((0, xF86XK_AudioMute), void toggleMute),
             ((myMask, xK_r), sshPrompt defaultXPConfig ) ,
             ((myMask, xK_g), windowPromptGoto  defaultXPConfig { autoComplete = Just 500000 } ) ,
             ((myMask .|. shiftMask , xK_g), windowPromptBring defaultXPConfig ) ,
             ((myMask, xK_f), goToSelected defaultGSConfig ) ,
             ((myMask, xK_m), viewEmptyWorkspace) ,
             ((myMask .|. shiftMask, xK_m), tagToEmptyWorkspace) ,
             ((myMask, xK_a), addAndPlay withMPD defaultXPConfig [Artist, Title]) ,
             ((0, xF86XK_AudioPlay), mpd toggle ) ,
             ((0, xF86XK_AudioStop), mpd stop ) ,
             ((0, xF86XK_AudioPrev), mpd previous ) ,
             ((0, xF86XK_AudioNext), mpd next )
           ]
  where
    myLayout = tall ||| Mirror tall ||| Full
      where tall = ResizableTall { _nmaster = 1,  _delta = 3/100, _frac = 1/2, _slaves = [] }
    vol action n = do
      v <- action ["Master"] n 
      osdCat v (const "")
    mpd = io . void . withMPD

main :: IO ()
main =
  statusBar "xmobar" statusBarSettings toggleStrutsKey myConfig >>=
  withWindowNavigation (xK_Up, xK_Left, xK_Down, xK_Right) >>=
  xmonad
    where
      statusBarSettings = xmobarPP { ppTitle = xmobarColor "green" ""}
      toggleStrutsKey _ = (myMask, xK_s)
