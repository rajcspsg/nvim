vim.g.terminator_runfile_map = {
    javascript = "node",
    python = "python -u",
    c = "gcc $dir$fileName -o $dir$fileNameWithoutExt && $dir$fileNameWithoutExt",
    fortran = "cd $dir && gfortran $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
    go = "go run"
   }
