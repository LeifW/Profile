import XMonad
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.NoBorders
import XMonad.Actions.Volume (raiseVolume, lowerVolume)

myTerm = "urxvt +sb"

main = xmonad $ defaultConfig {terminal = myTerm, layoutHook = smartBorders $ layoutHook defaultConfig} 
                `additionalKeys` 
                [ ((0, xK_Super_L), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"") ,
                  ((0, xK_Menu), spawn myTerm) ,
                  ((0, xK_F7), lowerVolume 3 >> return ()),
                  ((0, xK_F8), raiseVolume 3 >> return ())
                ]
