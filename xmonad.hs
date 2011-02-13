import XMonad
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run (spawnPipe)
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders
import XMonad.Prompt (defaultXPConfig, autoComplete)
import XMonad.Prompt.Window (windowPromptGoto, windowPromptBring)
import XMonad.Actions.Volume (raiseVolumeChannels, lowerVolumeChannels, osdCat, defaultOSDOpts)
import System.IO (hPutStrLn)
--import Data.Ratio ((%))
import XMonad.Layout.ResizableTile

myTerm = "urxvt +sb"

myLayout = Mirror tall ||| tall ||| Full
  where tall = ResizableTall 1 (3/100) (1/2) [] --Tall {tallNMaster = 1, tallRatioIncrement = 3 % 100, tallRatio = 1 % 2}
        golden = toRational (2/(1 + sqrt 5 :: Double))

main = do 
    xmproc <- spawnPipe "/usr/bin/xmobar /home/leif/.xmobarrc"
    xmonad $ defaultConfig {
             terminal = myTerm, 
             layoutHook = smartBorders myLayout,
             logHook = dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc,
                          ppTitle = xmobarColor "green" "" . shorten 70
                        }
             } 
                `additionalKeys` 
                [ ((0, xK_Super_L), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"") ,
                  ((0, xK_Menu), spawn myTerm) ,
                  ((mod1Mask, xK_g), windowPromptGoto  defaultXPConfig { autoComplete = Just 500000 } ) ,
                  ((mod1Mask, xK_b), windowPromptBring defaultXPConfig ) ,
                  ((0, xK_F7), lowerVolumeChannels ["Master"] 4 >>= flip osdCat (\_->"")),
                  ((0, xK_F8), raiseVolumeChannels ["Master"] 4 >>= flip osdCat (\_->"")),
                  ((mod1Mask, xK_a), sendMessage MirrorShrink),
                  ((mod1Mask, xK_z), sendMessage MirrorExpand)
                ]
