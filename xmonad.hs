import XMonad
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.NoBorders
import XMonad.Prompt (defaultXPConfig, autoComplete)
import XMonad.Prompt.Window (windowPromptGoto, windowPromptBring)
import XMonad.Actions.Volume (raiseVolumeChannels, lowerVolumeChannels, osdCat, defaultOSDOpts)
import Data.Ratio((%))

myTerm = "urxvt +sb"

myLayout = Mirror tall ||| tall ||| Full
  where tall = Tall {tallNMaster = 1, tallRatioIncrement = 3 % 100, tallRatio = 1 % 2}

main = xmonad $ defaultConfig {terminal = myTerm, layoutHook = smartBorders myLayout} 
                `additionalKeys` 
                [ ((0, xK_Super_L), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"") ,
                  ((0, xK_Menu), spawn myTerm) ,
                  ((mod1Mask, xK_g), windowPromptGoto  defaultXPConfig { autoComplete = Just 500000 } ) ,
                  ((mod1Mask, xK_b), windowPromptBring defaultXPConfig ) ,
                  ((0, xK_F7), lowerVolumeChannels ["Master"] 4 >>= flip osdCat (\_->"")),
                  ((0, xK_F8), raiseVolumeChannels ["Master"] 4 >>= flip osdCat (\_->""))
                ]
