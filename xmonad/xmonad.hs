{-# LANGUAGE CPP #-}

import XMonad
import XMonad.Actions.Submap (submap)
import XMonad.Util.Cursor (setDefaultCursor)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.ResizableTile (ResizableTall (..), MirrorResize (..))
import XMonad.Layout.LayoutHints (layoutHintsToCenter, hintsEventHook)
import XMonad.Layout.WindowNavigation
import XMonad.Prompt (defaultXPConfig, XPConfig (..))
import XMonad.Prompt.Shell (shellPrompt)
import System.Exit (exitWith, ExitCode (..))
import qualified XMonad.StackSet as S
import qualified Data.Map as M

main = xmonad conf

altm  = mod1Mask
winm  = mod4Mask
saltm = shiftMask .|. altm
swinm = shiftMask .|. winm

conf = defaultConfig
    { terminal = "urxvtc"
    , focusFollowsMouse = False
    , borderWidth = 1
    , modMask = altm
    , workspaces = map show [1..10]
    , normalBorderColor = "grey30"
    , focusedBorderColor = "aquamarine4"
    , keys = myKeys
    , layoutHook = myLayoutHook
    , startupHook = myStartupHook
    , handleEventHook = myHandleEventHook
    }

myWorkspaces = map show [1..10]

myStartupHook = setDefaultCursor xC_left_ptr

myXPConfig = defaultXPConfig
    { font = "xft:Monospace:size=9"
    , bgColor = "grey10"
    , fgColor = "grey60"
    , fgHLight = "tomato2"
    , bgHLight = "grey10"
    , promptBorderWidth = 0
    }

myHandleEventHook = hintsEventHook

-- FIXME: Maybe separate alt and win keybidings and use mod from default conf instead
myKeys conf = M.fromList $
    [ ((altm, xK_Return), spawn $ terminal conf)
    , ((altm, xK_r), shellPrompt myXPConfig)
    , ((altm, xK_q), kill)
    , ((altm, xK_space), sendMessage NextLayout)
    , ((saltm, xK_space), setLayout $ layoutHook conf)
    , ((altm, xK_n), refresh)
    , ((altm, xK_h), sendMessage $ Go L)
    , ((altm, xK_j), sendMessage $ Go D)
    , ((altm, xK_k), sendMessage $ Go U)
    , ((altm, xK_l), sendMessage $ Go R)
    , ((altm, xK_Tab), windows S.focusDown)
    , ((saltm, xK_h), sendMessage Shrink)
    , ((saltm, xK_j), sendMessage MirrorShrink)
    , ((saltm, xK_k), sendMessage MirrorExpand)
    , ((saltm, xK_l), sendMessage Expand)
    , ((winm, xK_h), sendMessage $ Swap L)
    , ((winm, xK_j), sendMessage $ Swap D)
    , ((winm, xK_k), sendMessage $ Swap U)
    , ((winm, xK_l), sendMessage $ Swap R)
    , ((altm, xK_t), withFocused $ windows . S.sink)
    , ((altm, xK_comma ), sendMessage $ IncMasterN 1)
    , ((altm, xK_period), sendMessage $ IncMasterN (-1))
    , ((saltm, xK_e), io $ exitWith ExitSuccess)
    , ((saltm, xK_r), spawn "xmonad --recompile && xmonad --restart")
    , ((0,  0x1008ff12), spawn "amixer set Master toggle")
    , ((0,  0x1008ff11), spawn "amixer set Master 1- unmute")
    , ((0,  0x1008ff13), spawn "amixer set Master 1+ unmute")
#if 0
    , ((altm, xK_c), submap . M.fromList $
        [ ((0, xK_n),     spawn "cmus-remote -n")
        , ((0, xK_p),     spawn "cmus-remote -r")
        , ((0, xK_z),     spawn "cmus-remote -S")
        , ((0, xK_space), spawn "cmus-remote -u")
        ])
#else
    , ((altm, xK_n),     spawn "cmus-remote -n")
    , ((altm, xK_p),     spawn "cmus-remote -r")
    , ((altm, xK_o),     spawn "cmus-remote -u")
#endif
    ]
    ++
    [ ((m .|. altm, k), windows $ f i) | (i, k) <- zip (workspaces conf) $ [xK_1 .. xK_9] ++ [xK_0]
                                       , (f, m) <- [(S.greedyView, 0), (S.shift, shiftMask)]
    ]

myLayoutHook = modify $ tiled ||| Full
  where tiled = ResizableTall 1 0.02 0.5 []
        modify = configurableNavigation noNavigateBorders . layoutHintsToCenter . smartBorders
