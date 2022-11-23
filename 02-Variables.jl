using Markdown

md"""

Worthy notes:

- In the Julia REPL, and several other Julia editing environments,
  you can type many Unicode math symbols by typing the backslashed
  LaTeX symbol name followed by tab. For example,
  the variable name `δ` can be entered by typing `\delta`-*tab*,
  or even `α̂⁽²⁾` by `\alpha`-*tab*-`\hat`-*tab*-`\^(2)`-*tab*.
  (If you find a symbol somewhere, e.g. in someone else's code,
  that you don't know how to type, the REPL help will tell you:
  just type ? and then paste the symbol).

- The only explicitly disallowed names for variables
  are the names of the built-in keywords

"""

# Unicode names (in UTF-8 encoding) are allowed
UniversalDeclarationOfHumanRightsStart = "人人生而自由，在尊严和权利上一律平等。"
δ = 0.00001
안녕하세요 = "Hello"
🐱 = "cat face"

# Built-in keywords are disallowed
# if = 10 -> ERROR: syntax: unexpected "else"

md"""
# Stylistic Conventions

- Names of variables are in lower case
- Word separation can be indicated by underscores ('_'),
  but use of underscores is discouraged unless
  the name would be hard to read otherwise
- Names of `Type`s and `Module`s begin with a capital letter
  and word separation is shown with upper camel case instead of underscores
- Names of `function`s and `macro`s are in lower case, without underscores
- Functions that write to their arguments have names that end in !

"""
