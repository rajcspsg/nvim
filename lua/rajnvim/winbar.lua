local M = {}

local icons = {
	abc = "  ",
	array = "  ",
	arrowReturn = "  ",
	bigCircle = "  ",
	bigUnfilledCircle = "  ",
	bomb = "  ",
	bookMark = "  ",
	boolean = "  ",
	box = " 󰅫 ",
	buffer = "  ",
	bug = "  ",
	calculator = "  ",
	calendar = "  ",
	caretRight = "",
	checkSquare = "  ",
	copilot = "",
	codeium = "",
	exit = " 󰗼 ",
	chevronRight = "",
	circle = "  ",
	class = "  ",
	close = "  ",
	code = "  ",
	cog = "  ",
	color = "  ",
	comment = "  ",
	constant = "  ",
	constructor = "  ",
	container = "  ",
	console = " 󰞷 ",
	consoleDebug = "  ",
	cubeTree = "  ",
	dashboard = "  ",
	database = "  ",
	enum = "  ",
	enumMember = "  ",
	error = "  ",
	errorOutline = "  ",
	errorSlash = " ﰸ ",
	event = "  ",
	field = "  ",
	file = "  ",
	fileBg = "  ",
	fileCopy = "  ",
	fileCutCorner = "  ",
	fileNoBg = "  ",
	fileNoLines = "  ",
	fileNoLinesBg = "  ",
	fileRecent = "  ",
	fire = "  ",
	folder = "  ",
	folderNoBg = "  ",
	folderOpen = "  ",
	folderOpen2 = " 󰉖 ",
	folderOpenNoBg = "  ",
	forbidden = " 󰍛 ",
	func = "  ",
	gear = "  ",
	gears = "  ",
	git = "  ",
	gitAdd = "  ",
	gitChange = " 󰏬 ",
	gitRemove = "  ",
	hexCutOut = "  ",
	history = "  ",
	hook = " ﯠ ",
	info = "  ",
	infoOutline = "  ",
	interface = "  ",
	key = "  ",
	keyword = "  ",
	light = "  ",
	lightbulb = "  ",
	lightbulbOutline = "  ",
	list = "  ",
	lock = "  ",
	m = " m ",
	method = "  ",
	module = "  ",
	newFile = "  ",
	note = " 󰎚 ",
	number = "  ",
	numbers = "  ",
	object = "  ",
	operator = "  ",
	package = " 󰏓 ",
	packageUp = " 󰏕 ",
	packageDown = " 󰏔 ",
	paint = "  ",
	paragraph = " 󰉢 ",
	pencil = "  ",
	pie = "  ",
	pin = " 󰐃 ",
	project = "  ",
	property = "  ",
	questionCircle = "  ",
	reference = "  ",
	ribbon = " 󰑠 ",
	robot = " 󰚩 ",
	scissors = "  ",
	scope = "  ",
	search = "  ",
	settings = "  ",
	signIn = "  ",
	snippet = "  ",
	sort = "  ",
	spell = " 暈",
	squirrel = "  ",
	stack = "  ",
	string = "  ",
	struct = "  ",
	table = "  ",
	tag = "  ",
	telescope = "  ",
	terminal = "  ",
	text = "  ",
	threeDots = " 󰇘 ",
	threeDotsBoxed = "  ",
	timer = "  ",
	trash = "  ",
	tree = "  ",
	treeDiagram = " 󰙅 ",
	typeParameter = "  ",
	unit = "  ",
	up_hexagon = " 󰋘 ",
	value = "  ",
	variable = "  ",
	warningCircle = "  ",
	vim = "  ",
	warningTriangle = "  ",
	warningTriangleNoBg = "  ",
	watch = "  ",
	word = "  ",
	wrench = "  ",
}

local function isempty(s)
	return s == nil or s == ""
end

M.filename = function()
	local filename = vim.fn.expand("%:t")
	local file_path = vim.fn.expand("%:p")
	local parent_dir = string.match(file_path, ".*/([^/]+)/[^/]+$")
	local extension = ""
	local file_icon = ""
	local file_icon_color = ""
	local default_file_icon = ""
	local default_file_icon_color = ""

	if not isempty(filename) then
		extension = vim.fn.expand("%:e")

		local default = false

		if isempty(extension) then
			extension = ""
			default = true
		end

		file_icon, file_icon_color =
			require("nvim-web-devicons").get_icon_color(filename, extension, { default = default })

		local hl_group = "FileIconColor" .. extension

		vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
		if file_icon == nil then
			file_icon = default_file_icon
			file_icon_color = default_file_icon_color
		end

		-- Return filename if parent dir doesn't exist
		if parent_dir == nil or parent_dir == "" then
			return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#Winbar#" .. filename .. "%*"
		end

		-- Return parent dir
		return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#Winbar#" .. parent_dir .. "%*"
	end
end

M.gps = function()
	local navic = require("nvim-navic")
	local navic_location = navic.get_location()

	if not navic.is_available() then -- Returns boolean value indicating whether a output can be provided
		return
	end

	local retval = M.filename()

	if navic_location == "error" then
		return ""
	else
		if not isempty(navic_location) then
			local hl_group = "Winbar"
			return retval .. " " .. "%#" .. hl_group .. "#" .. icons.caretRight .. "%*" .. " " .. navic_location
		else
			return retval
		end
	end
end

vim.api.nvim_create_autocmd({ "CursorMoved", "BufWinEnter", "BufFilePost" }, {
	callback = function()
		local winbar_filetype_exclude = {
			"help",
			"startify",
			"dashboard",
			"packer",
			"neogitstatus",
			"NeoTree",
			"Trouble",
			"alpha",
			"lir",
			"Outline",
			"TelescopePrompt",
			"neotest-summary",
			"toggleterm",
			"octo",
		}

		if vim.api.nvim_win_get_config(0).relative ~= "" then
			return
		end

		if vim.bo.filetype == "dapui_watches" then
			local hl_group = "EcovimSecondary"
			vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. icons.watch .. "Watches" .. "%*"
			return
		end

		if vim.bo.filetype == "dapui_stacks" then
			local hl_group = "EcovimSecondary"
			vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. icons.git .. "Stacks" .. "%*"
			return
		end

		if vim.bo.filetype == "dapui_breakpoints" then
			local hl_group = "EcovimSecondary"
			vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. icons.bigCircle .. "Breakpoints" .. "%*"
			return
		end

		if vim.bo.filetype == "dapui_scopes" then
			local hl_group = "EcovimSecondary"
			vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. icons.telescope .. "Scopes" .. "%*"
			return
		end

		if vim.bo.filetype == "dap-repl" then
			local hl_group = "EcovimSecondary"
			vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. icons.consoleDebug .. "Debug Console" .. "%*"
			return
		end

		if vim.bo.filetype == "dapui_console" then
			local hl_group = "EcovimSecondary"
			vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. icons.console .. "Console" .. "%*"
			return
		end

		if vim.tbl_contains(winbar_filetype_exclude, vim.bo.filetype) then
			vim.opt_local.winbar = nil
			return
		end

		if vim.bo.filetype == "blame" then
			local hl_group = "EcovimSecondary"
			vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. icons.git .. "Blame" .. "%*"
			return
		end

		local winbar_present, winbar = pcall(require, "rajnvim.winbar")
		if not winbar_present or type(winbar) == "boolean" then
			vim.opt_local.winbar = nil
			return
		end

		local value = winbar.gps()

		if value == nil then
			value = winbar.filename()
		end

		vim.opt_local.winbar = value
	end,
})

return M
