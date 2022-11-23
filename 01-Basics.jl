using Markdown

md"""

Worthy notes:

- If you have code that you want executed whenever Julia is run,
  it can be put in `~/.julia/config/startup.jl`

(Outside the Julia REPL)
- Double-click the Julia executable
  or run `julia` from the command-line to enter the REPL
- To run code in a file non-interactively
  you can give it as the first argument to the `julia` command:

  ```
  $ julia script.jl arg1 arg2...
  ```

- The following command-line arguments to `julia`
  are interpreted as command-line arguments to the program `script.jl`
- Use the `-e` argument to execute a Julia command from the shell

(Inside the Julia REPL or process)
- The variable `ans` is bound to the value of
  the last evaluated expression whether it is shown or not
- If an expression is entered into an interactive session
  with a trailing semicolon, its value is not shown
- To evaluate expressions written in a
  source file `file.jl`, write `include("file.jl")`
- command-line arguments are passed to the global constant `ARGS`
- The name of the script itself is passed in as the global `PROGRAM_FILE`
- Type `?` to enter help mode
- Type `]` to enter Pkg mode
- Type `]?` to enter Pkg help mode

"""
