return {
	"CRAG666/code_runner.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("code_runner").setup({
			filetype = {
				java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
				python = "python3 -u",
				typescript = "deno run",
				rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
				go = "go run $fileName",
			},
		})
	end,
}
