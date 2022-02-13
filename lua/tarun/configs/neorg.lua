local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
    return
end

neorg.setup {
    load = {
        ["core.defaults"] = {},
        ["core.norg.completion"] = {
            config = {
                engine = "nvim-cmp",
            },
        },
        ["core.norg.concealer"] = {
            config = {
                icons = {
                    heading = {
                        enabled = true,
                        level_1 = {
                            icon = "◉",
                        },
                        level_2 = {
                            icon = " ○",
                        },
                        level_3 = {
                            icon = "  ●",
                        },
                        level_4 = {
                            icon = "   ○",
                        },
                        level_5 = {
                            icon = "    ●",
                        },
                        level_6 = {
                            icon = "     ○",
                        },
                        level_7 = {
                            icon = "      ●",
                        },
                    },
                },
            },
        },
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    nvim_config_todos = "~/.config/nvim/todos/",
                },
                -- Automatically detect whenever we have entered a subdirectory of a workspace
            autodetect = true,
            -- Automatically change the directory to the root of the workspace every time
            autochdir = true,
            }
        }
    }
}
