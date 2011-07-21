import XMonad
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run (spawnPipe)
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders
import XMonad.Prompt (defaultXPConfig, autoComplete)
import XMonad.Prompt.Window (windowPromptGoto, windowPromptBring)
import XMonad.Actions.Volume (raiseVolumeChannels, lowerVolumeChannels, osdCat, defaultOSDOpts)
import System.IO (hPutStrLn)
import Data.Ratio ((%))
import XMonad.Layout.ResizableTile
import Graphics.X11.ExtraTypes

myLayout = tall ||| Mirror tall ||| Full
  where tall = Tall {tallNMaster = 1, tallRatioIncrement = 3 % 100, tallRatio = 1 % 2}

myTerm = "urxvtc"

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
                [ ((0, xK_Super_L), spawn "dmenu_run") ,
                  ((mod1Mask, xK_p), spawn "dmenu_run") , -- override of default
                  ((0, xK_Menu), spawn myTerm) ,
                  ((mod1Mask, xK_t), spawn "urxvt") ,
                  ((mod1Mask, xK_g), windowPromptGoto  defaultXPConfig { autoComplete = Just 500000 } ) ,
                  ((mod1Mask, xK_b), windowPromptBring defaultXPConfig ), 
                  ((0, xF86XK_AudioLowerVolume), lowerVolumeChannels ["Master"] 3 >>= flip osdCat (\_->"")),
                  ((0, xF86XK_AudioRaiseVolume), raiseVolumeChannels ["Master"] 3 >>= flip osdCat (\_->"")),
                  ((0, xF86XK_Sleep), spawn "sudo /usr/sbin/pm-suspend" ),
                  ((0, xK_F4), spawn "echo slow" >> spawn "sudo /usr/bin/cpufreq-set -g ondemand" ),
                  ((0, xK_F5), spawn "echo fast" >> spawn "sudo /usr/bin/cpufreq-set -g performance" )
                ]
