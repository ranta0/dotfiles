local wezterm = require("wezterm")
local act = wezterm.action

local config = {
    check_for_updates = false,
    default_prog = { '/bin/bash', '-l' },
    launch_menu = {},
    scrollback_lines = 10000,
    leader = { key="s", mods="CTRL" },
    -- disable_default_key_bindings = true,
    keys = {
        {
            key = "v",
            mods = "LEADER",
            action = act.Multiple({
                act.CopyMode("ClearSelectionMode"),
                act.ActivateCopyMode,
                act.ClearSelection
            }),
        },
        {
            key = "s",
            mods = "LEADER|CTRL",
            action = act{SendString="\x01"}
        },
        {
            key = "%",
            mods = "LEADER|SHIFT",
            action = act{SplitVertical={domain="CurrentPaneDomain"}}
        },
        {
            key = '"',
            mods = "LEADER|SHIFT",
            action = act{SplitHorizontal={domain="CurrentPaneDomain"}}
        },
        {
            key = "m",
            mods = "LEADER",
            action = "TogglePaneZoomState" },
        {
            key = "t",
            mods = "LEADER",
            action = act{SpawnTab="CurrentPaneDomain"}},
        {
            key = "h",
            mods = "CTRL",
            action = act{ActivatePaneDirection="Left"}},
        {
            key = "j",
            mods = "CTRL",
            action = act{ActivatePaneDirection="Down"}},
        {
            key = "k",
            mods = "CTRL",
            action = act{ActivatePaneDirection="Up"}},
        {
            key = "l",
            mods = "CTRL",
            action = act{ActivatePaneDirection="Right"}},
        {
            key = "H",
            mods = "CTRL|SHIFT",
            action = act{AdjustPaneSize={"Left", 5}}
        },
        {
            key = "J",
            mods = "CTRL|SHIFT",
            action = act{AdjustPaneSize={"Down", 5}}
        },
        {
            key = "K",
            mods = "CTRL|SHIFT",
            action = act{AdjustPaneSize={"Up", 5}}
        },
        {
            key = "L",
            mods = "CTRL|SHIFT",
            action = act{AdjustPaneSize={"Right", 5}}
        },
        {
            key = "1",
            mods = "LEADER",
            action = act{ActivateTab=0}},
        {
            key = "2",
            mods = "LEADER",
            action = act{ActivateTab=1}},
        {
            key = "3",
            mods = "LEADER",
            action = act{ActivateTab=2}},
        {
            key = "4",
            mods = "LEADER",
            action = act{ActivateTab=3}},
        {
            key = "5",
            mods = "LEADER",
            action = act{ActivateTab=4}},
        {
            key = "6",
            mods = "LEADER",
            action = act{ActivateTab=5}},
        {
            key = "7",
            mods = "LEADER",
            action = act{ActivateTab=6}},
        {
            key = "8",
            mods = "LEADER",
            action = act{ActivateTab=7}},
        {
            key = "9",
            mods = "LEADER",
            action = act{ActivateTab=8}},
        {
            key = "&",
            mods = "LEADER|SHIFT",
            action = act{CloseCurrentTab={confirm=true}}
        },
        {
            key = "D",
            mods = "LEADER",
            action = act{CloseCurrentPane={confirm=true}}
        },
    },
    key_tables = {
        copy_mode = {
            {
                key = "Escape",
                mods = "NONE",
                action = act.Multiple({
                    act.ClearSelection,
                    act.CopyMode("ClearPattern"),
                    act.CopyMode("Close"),
                }),
            },
            {
                key = "q",
                mods = "NONE",
                action = act.CopyMode("Close")
            },
            -- move cursor
            {
                key = "h",
                mods = "NONE",
                action = act.CopyMode("MoveLeft")
            },
            {
                key = "LeftArrow",
                mods = "NONE",
                action = act.CopyMode("MoveLeft")
            },
            {
                key = "j",
                mods = "NONE",
                action = act.CopyMode("MoveDown")
            },
            {
                key = "DownArrow",
                mods = "NONE",
                action = act.CopyMode("MoveDown")
            },
            {
                key = "k",
                mods = "NONE",
                action = act.CopyMode("MoveUp")
            },
            {
                key = "UpArrow",
                mods = "NONE",
                action = act.CopyMode("MoveUp")
            },
            {
                key = "l",
                mods = "NONE",
                action = act.CopyMode("MoveRight")
            },
            {
                key = "RightArrow",
                mods = "NONE",
                action = act.CopyMode("MoveRight")
            },
            -- move word
            {
                key = "RightArrow",
                mods = "ALT",
                action = act.CopyMode("MoveForwardWord")
            },
            {
                key = "f",
                mods = "ALT",
                action = act.CopyMode("MoveForwardWord")
            },
            {
                key = "\t",
                mods = "NONE",
                action = act.CopyMode("MoveForwardWord")
            },
            {
                key = "w",
                mods = "NONE",
                action = act.CopyMode("MoveForwardWord")
            },
            {
                key = "LeftArrow",
                mods = "ALT",
                action = act.CopyMode("MoveBackwardWord")
            },
            {
                key = "b",
                mods = "ALT",
                action = act.CopyMode("MoveBackwardWord")
            },
            {
                key = "\t",
                mods = "SHIFT",
                action = act.CopyMode("MoveBackwardWord")
            },
            {
                key = "b",
                mods = "NONE",
                action = act.CopyMode("MoveBackwardWord")
            },
            {
                key = "e",
                mods = "NONE",
                action = act({
                    Multiple = {
                        act.CopyMode("MoveRight"),
                        act.CopyMode("MoveForwardWord"),
                        act.CopyMode("MoveLeft"),
                    },
                }),
            },
            -- move start/end
            {
                key = "0",
                mods = "NONE",
                action = act.CopyMode("MoveToStartOfLine")
            },
            {
                key = "\n",
                mods = "NONE",
                action = act.CopyMode("MoveToStartOfNextLine")
            },
            {
                key = "$",
                mods = "SHIFT",
                action = act.CopyMode("MoveToEndOfLineContent")
            },
            {
                key = "$",
                mods = "NONE",
                action = act.CopyMode("MoveToEndOfLineContent")
            },
            {
                key = "e",
                mods = "CTRL",
                action = act.CopyMode("MoveToEndOfLineContent")
            },
            {
                key = "m",
                mods = "ALT",
                action = act.CopyMode("MoveToStartOfLineContent")
            },
            {
                key = "^",
                mods = "SHIFT",
                action = act.CopyMode("MoveToStartOfLineContent")
            },
            {
                key = "^",
                mods = "NONE",
                action = act.CopyMode("MoveToStartOfLineContent")
            },
            {
                key = "a",
                mods = "CTRL",
                action = act.CopyMode("MoveToStartOfLineContent")
            },
            -- select
            {
                key = " ",
                mods = "NONE",
                action = act.CopyMode({
                    SetSelectionMode = "Cell"
                })
            },
            {
                key = "v",
                mods = "NONE",
                action = act.CopyMode({
                    SetSelectionMode = "Cell"
                })
            },
            {
                key = "v",
                mods = "SHIFT",
                action = act({
                    Multiple = {
                        act.CopyMode("MoveToStartOfLineContent"),
                        act.CopyMode({
                            SetSelectionMode = "Cell"
                        }),
                        act.CopyMode("MoveToEndOfLineContent"),
                    },
                }),
            },
            -- copy
            {
                key = "y",
                mods = "NONE",
                action = act({
                    Multiple = {
                        act({
                            CopyTo = "ClipboardAndPrimarySelection"
                        }),
                        act.CopyMode("Close"),
                    },
                }),
            },
            {
                key = "y",
                mods = "SHIFT",
                action = act({
                    Multiple = {
                        act.CopyMode({
                            SetSelectionMode = "Cell"
                        }),
                        act.CopyMode("MoveToEndOfLineContent"),
                        act({
                            CopyTo = "ClipboardAndPrimarySelection"
                        }),
                        act.CopyMode("Close"),
                    },
                }),
            },
            -- scroll
            {
                key = "G",
                mods = "SHIFT",
                action = act.CopyMode("MoveToScrollbackBottom")
            },
            {
                key = "G",
                mods = "NONE",
                action = act.CopyMode("MoveToScrollbackBottom")
            },
            {
                key = "g",
                mods = "NONE",
                action = act.CopyMode("MoveToScrollbackTop")
            },
            {
                key = "H",
                mods = "NONE",
                action = act.CopyMode("MoveToViewportTop")
            },
            {
                key = "H",
                mods = "SHIFT",
                action = act.CopyMode("MoveToViewportTop")
            },
            {
                key = "M",
                mods = "NONE",
                action = act.CopyMode("MoveToViewportMiddle")
            },
            {
                key = "M",
                mods = "SHIFT",
                action = act.CopyMode("MoveToViewportMiddle")
            },
            {
                key = "L",
                mods = "NONE",
                action = act.CopyMode("MoveToViewportBottom")
            },
            {
                key = "L",
                mods = "SHIFT",
                action = act.CopyMode("MoveToViewportBottom")
            },
            {
                key = "o",
                mods = "NONE",
                action = act.CopyMode("MoveToSelectionOtherEnd")
            },
            {
                key = "O",
                mods = "NONE",
                action = act.CopyMode("MoveToSelectionOtherEndHoriz")
            },
            {
                key = "O",
                mods = "SHIFT",
                action = act.CopyMode("MoveToSelectionOtherEndHoriz")
            },
            {
                key = "PageUp",
                mods = "NONE",
                action = act.CopyMode("PageUp")
            },
            {
                key = "PageDown",
                mods = "NONE",
                action = act.CopyMode("PageDown")
            },
            {
                key = "u",
                mods = "CTRL",
                action = act.CopyMode("PageUp")
            },
            {
                key = "d",
                mods = "CTRL",
                action = act.CopyMode("PageDown")
            },
            {
                key = "Enter",
                mods = "NONE",
                action = act.CopyMode("ClearSelectionMode"),

            },
            -- search
            {
                key = "/",
                mods = "NONE",
                action = act.Search("CurrentSelectionOrEmptyString")
            },
            {
                key = "n",
                mods = "NONE",
                action = act.Multiple({
                    act.CopyMode("NextMatch"),
                    act.CopyMode("ClearSelectionMode"),
                }),

            },
            {
                key = "N",
                mods = "SHIFT",
                action = act.Multiple({
                    act.CopyMode("PriorMatch"),
                    act.CopyMode("ClearSelectionMode"),
                }),
            },

        },
        search_mode = {
            {
                key = "Escape",
                mods = "NONE",
                action = act.CopyMode("Close")
            },
            {
                key = "Enter",
                mods = "NONE",
                action = act.Multiple({
                    act.CopyMode("ClearSelectionMode"),
                    act.ActivateCopyMode,
                }),

            },
            {
                key = "p",
                mods = "CTRL",
                action = act.CopyMode("PriorMatch")
            },
            {
                key = "n",
                mods = "CTRL",
                action = act.CopyMode("NextMatch")
            },
            {
                key = "r",
                mods = "CTRL",
                action = act.CopyMode("CycleMatchType")
            },
            {
                key = "/",
                mods = "NONE",
                action = act.CopyMode("ClearPattern")
            },
            {
                key = "u",
                mods = "CTRL",
                action = act.CopyMode("ClearPattern")
            },
        },
    },

    --THEME
    set_environment_variables = {
        prompt = '$E]7;file://localhost/$P$E\\$E[32m$T$E[0m $E[35m$P$E[36m$_$G$E[0m ',
    },
    window_background_opacity = 0.8,
    font_size = 10.0,
    colors = {
        cursor_bg = "#c678dd",
        tab_bar = {
            background = "#1A1A2F",

            active_tab = {
                bg_color = "#1A1A2F",
                fg_color = "#c678dd"
            },

            inactive_tab = {
                bg_color = "#1A1A2F",
                fg_color = "#ffffff",
                italic = true,
            }
        }
    },
    inactive_pane_hsb = {
        saturation = 0.8,
        brightness = 0.4,
    }
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.front_end = "Software" -- OpenGL doesn't work quite well with RDP.
    config.term = "" -- Set to empty so FZF works on windows
    config.default_prog = { "cmd.exe" }
    table.insert(config.launch_menu, { label = "PowerShell", args = {"powershell.exe", "-NoLogo"} })

    -- Find installed visual studio version(s) and add their compilation
    -- environment command prompts to the menu
    for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
        local year = vsvers:gsub("Microsoft Visual Studio/", "")
        table.insert(config.launch_menu, {
            label = "x64 Native Tools VS " .. year,
            args = {"cmd.exe", "/k", "C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat"},
        })
    end
else
    table.insert(config.launch_menu, { label = "bash", args = {"bash", "-l"} })
end

wezterm.on(
    'format-tab-title',
    function(tab)
        local index = (tab.tab_index + 1) .. '~' .. tab.active_pane.title
        return index
    end
)

return config
