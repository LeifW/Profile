import XMonad
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.ResizableTile
import XMonad.Prompt (defaultXPConfig, autoComplete)
import XMonad.Prompt.Window (windowPromptGoto, windowPromptBring)
import XMonad.Actions.Volume (raiseVolumeChannels, lowerVolumeChannels, osdCat)
import XMonad.Util.Run (safeSpawnProg)
import Graphics.X11.ExtraTypes

myConfig = defaultConfig {
             terminal = "urxvtc", 
             layoutHook = smartBorders myLayout
           }
           `additionalKeys`
           [ ((0, xK_Super_L), safeSpawnProg "dmenu_run") ,
             ((mod1Mask, xK_p), safeSpawnProg "dmenu_run") , -- override of default
             ((0, xK_Menu), safeSpawnProg $ terminal myConfig) ,
             ((mod1Mask, xK_a), sendMessage MirrorShrink) ,
             ((mod1Mask, xK_z), sendMessage MirrorExpand) ,
             ((0, xK_F7), vol lowerVolumeChannels 2), 
             ((0, xK_F8), vol raiseVolumeChannels 2),
             ((0, xF86XK_AudioLowerVolume), vol lowerVolumeChannels 2), 
             ((0, xF86XK_AudioRaiseVolume), vol raiseVolumeChannels 2),
             ((mod1Mask, xK_g), windowPromptGoto  defaultXPConfig { autoComplete = Just 500000 } ) ,
             ((mod1Mask, xK_b), windowPromptBring defaultXPConfig )
           ]
  where
    myLayout = tall ||| Mirror tall ||| Full
      where tall = ResizableTall { _nmaster = 1,  _delta = 3/100, _frac = 1/2, _slaves = [] }
    vol action n = do
      v <- action ["Master"] n 
      osdCat v (\_->"")

statusBarSettings = xmobarPP { ppTitle = xmobarColor "green" ""}
toggleStrutsKey _ = (mod1Mask, xK_s)

main = xmonad =<< statusBar "xmobar" statusBarSettings toggleStrutsKey myConfig
