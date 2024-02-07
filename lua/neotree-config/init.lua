local Icons = {
    diagnostics = {error = "", warn = "", hint = "", info = ""},
    git = {
        added = "",
        modified = "",
        removed = "",
        renamed = "➜",
        untracked = "",
        ignored = "",
        unstaged = "U",
        staged = "",
        conflict = "",
        deleted = ""
    },
    gitsigns = {
        add = "┃",
        change = "┋",
        delete = "",
        topdelhfe = "",
        changedelete = "┃",
        untracked = "┃"
    },
    kinds = {
        Array = "",
        Boolean = "",
        Class = "",
        Color = "",
        Constant = "",
        Constructor = "",
        Copilot = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "",
        File = "",
        Folder = "",
        Function = "",
        Interface = "",
        Key = "",
        Keyword = "",
        Method = "",
        Module = "",
        Namespace = "",
        Null = "",
        Number = "",
        Object = "",
        Operator = "",
        Package = "",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "",
        Struct = "",
        Text = "",
        TypeParameter = "",
        Unit = "",
        Value = "",
        Variable = "",
        Macro = "" -- Macro
    },
    borders = {
        --- @class BorderIcons
        single = {
            top = "─",
            right = "│",
            bottom = "─",
            left = "│",
            top_left = "╭",
            top_right = "╮",
            bottom_right = "╯",
            bottom_left = "╰"
        },
        double = {
            top = '═',
            right = "║",
            bottom = '═',
            left = "║",
            top_left = "╔",
            top_right = "╗",
            bottom_right = "╝",
            bottom_left = "╚"
        },
        --- @class BorderIcons
        thin = {
            top = "▔",
            right = "▕",
            bottom = "▁",
            left = "▏",
            top_left = "🭽",
            top_right = "🭾",
            bottom_right = "🭿",
            bottom_left = "🭼"
        },
        ---@type BorderIcons
        empty = {
            top = " ",
            right = " ",
            bottom = " ",
            left = " ",
            top_left = " ",
            top_right = " ",
            bottom_right = " ",
            bottom_left = " "
        },
        ---@type BorderIcons
        thick = {
            top = "▄",
            right = "█",
            bottom = "▀",
            left = "█",
            top_left = "▄",
            top_right = "▄",
            bottom_right = "▀",
            bottom_left = "▀"
        }
    },
    misc = {codeium = "󰘦 "}
}

local Components = {
    name = function(config, node, state)
        local common = require("neo-tree.sources.common.components")
        local highlights = require("neo-tree.ui.highlights")

        local highlight = config.highlight or highlights.FILE_NAME
        local text = node.name
        if node.type == "directory" then
            highlight = highlights.DIRECTORY_NAME
            if config.trailing_slash and text ~= "/" then
                text = text .. "/"
            end
        end

        if node:get_depth() == 1 and node.type ~= "message" then
            highlight = highlights.ROOT_NAME
            text = vim.fn.fnamemodify(text, ":p:h:t")
            text = string.upper(text)
        else
            local filtered_by = common.filtered_by(config, node, state)
            highlight = filtered_by.highlight or highlight
            if config.use_git_status_colors then
                local git_status = state.components.git_status({}, node, state)
                if git_status and git_status.highlight then
                    highlight = git_status.highlight
                end
            end
        end

        if type(config.right_padding) == "number" then
            if config.right_padding > 0 then
                text = text .. string.rep(" ", config.right_padding)
            end
        else
            text = text .. " "
        end

        return {text = text, highlight = highlight}
    end,

    icon = function(config, node, state)
        local common = require("neo-tree.sources.common.components")
        local highlights = require("neo-tree.ui.highlights")

        local icon = config.default or " "
        local highlight = config.highlight or highlights.FILE_ICON
        if node.type == "directory" then
            highlight = highlights.DIRECTORY_ICON
            if node.loaded and not node:has_children() then
                icon = not node.empty_expanded and config.folder_empty or
                           config.folder_empty_open
            elseif node:is_expanded() then
                icon = config.folder_open or "-"
            else
                icon = config.folder_closed or "+"
            end
        elseif node.type == "file" or node.type == "terminal" then
            local success, web_devicons = pcall(require, "nvim-web-devicons")
            if success then
                local devicon, hl = web_devicons.get_icon(node.name, node.ext)
                icon = devicon or icon
                highlight = hl or highlight
            end
        end

        local filtered_by = common.filtered_by(config, node, state)

        -- Don't render icon in root folder
        if node:get_depth() == 1 then
            return {text = nil, highlight = highlight}
        end

        return {
            text = icon .. " ",
            highlight = filtered_by.highlight or highlight
        }
    end
}

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim"
    },
    config = function()
        require("neo-tree").setup({
            close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
            sources = {"filesystem", "buffers", "git_status", "diagnostics"},
            source_selector = {
                winbar = true, -- toggle to show selector on winbar
                content_layout = "center",
                tabs_layout = "equal",
                show_separator_on_edge = true,
                sources = {
                    {source = "filesystem", display_name = "󰉓"},
                    {source = "buffers", display_name = "󰈙"},
                    {source = "git_status", display_name = ""},
                    {source = "diagnostics", display_name = "󰒡"}
                }
            },
            default_component_configs = {
                indent = {
                    indent_size = 2,
                    padding = 1, -- extra padding on left hand side
                    -- indent guides
                    with_markers = true,
                    indent_marker = "│",
                    last_indent_marker = "└",
                    -- expander config, needed for nesting files
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander"
                },
                icon = {
                    folder_closed = "",
                    folder_open = "",
                    folder_empty = "",
                    folder_empty_open = "",
                    -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
                    -- then these will never be used.
                    default = " "
                },
                modified = {symbol = ""},
                git_status = {symbols = Icons.git},
                diagnostics = {symbols = Icons.diagnostics}
            },
            window = {
                width = 40,
                mappings = {["<1-LeftMouse>"] = "open", ["l"] = "open"}
            },
            filesystem = {
                window = {
                    mappings = {
                        ["H"] = "navigate_up",
                        ["<bs>"] = "toggle_hidden",
                        ["."] = "set_root",
                        ["/"] = "fuzzy_finder",
                        ["f"] = "filter_on_submit",
                        ["<c-x>"] = "clear_filter",
                        ["a"] = {"add", config = {show_path = "relative"}} -- "none", "relative", "absolute"
                    }
                },
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false
                },
                follow_current_file = {enabled = true}, -- This will find and focus the file in the active buffer every
                -- time the current file is changed while the tree is open.
                group_empty_dirs = true, -- when true, empty folders will be grouped together
                components = Components
            },
            async_directory_scan = "always"
        })
    end
}

