import XMonad
import XMonad.Util.EZConfig(additionalKeys)

myTerm = "urxvt +sb"

main = xmonad $ defaultConfig {terminal = myTerm} 
                `additionalKeys` 
                [ ((0, xK_Super_L), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"") ,
                 ((0, xK_Menu), spawn myTerm) ]
