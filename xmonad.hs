import XMonad
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders
import XMonad.Prompt (defaultXPConfig, autoComplete)
import XMonad.Prompt.Window (windowPromptGoto, windowPromptBring)
import XMonad.Actions.Volume (raiseVolumeChannels, lowerVolumeChannels, osdCat, defaultOSDOpts)
import Data.Ratio ((%))
import XMonad.Layout.ResizableTile
import Graphics.X11.ExtraTypes
import Network.MPD
import Network.MPD.Commands.Extensions
import Control.Monad (void)

myTerm = "urxvtc"

myLayout = tall ||| Mirror tall ||| Full
  where tall = Tall {tallNMaster = 1, tallRatioIncrement = 3 % 100, tallRatio = 1 % 2}

mpd = io . void . withMPD

myConfig = defaultConfig {
             terminal = myTerm, 
             layoutHook = smartBorders myLayout
           }
           `additionalKeys`
           [ ((0, xK_Super_L), spawn "dmenu_run") ,
             ((mod1Mask, xK_p), spawn "dmenu_run") , -- override of default
             ((0, xK_Menu), spawn myTerm) ,
             ((mod1Mask, xK_g), windowPromptGoto  defaultXPConfig { autoComplete = Just 500000 } ) ,
             ((mod1Mask, xK_b), windowPromptBring defaultXPConfig ) ,
             ((0, xF86XK_AudioLowerVolume), lowerVolumeChannels ["Master"] 3 >>= flip osdCat (\_->"")),
             ((0, xF86XK_AudioRaiseVolume), raiseVolumeChannels ["Master"] 3 >>= flip osdCat (\_->"")),
             ((mod1Mask, xK_b), mpd previous ) ,
             ((mod1Mask, xK_n), mpd next )
           ]

statusBarSettings = xmobarPP { ppTitle = xmobarColor "green" "" . shorten 70 }
toggleStrutsKey _ = (mod1Mask, xK_s)

main = xmonad =<< statusBar "xmobar" statusBarSettings toggleStrutsKey myConfig
