# %%
using Markdown

md"""

List of control flow constructs:

- Compound Expressions: `begin` and `;`
- Conditional Evaluation: `if`-`elseif`-`else` and `?:` (ternary operator)
- Short-Circuit Evaluation: logical operators `&&` (“and”) and `||` (“or”), and also chained comparisons
- Repeated Evaluation: Loops: `while` and `for`
- Exception Handling: `try`-`catch`, `error` and `throw`
- Tasks (aka Coroutines): `yieldto`

Worthy notes:

- `if` blocks are "leaky", i.e. they do not introduce a local scope
    * When depending on this behavior, make sure all possible code paths define a value for the variable
- `if` blocks also return a value, this value is simply the return value of
  the last executed statement in the branch that was chosen
- Conditional expressions require strictly boolean operators (`1` or `""` or ... are not accepted)
- Ternary operator requires whitespace around `?` and `:` (either space or newline)
- Short-circuit evaluation can be used as shorthand conditionals

```
julia> function fact(n::Int)
           n >= 0 || error("n must be non-negative")
           n == 0 && return 1
           n * fact(n-1)
       end
```

- Boolean operations without short-circuit evaluation can be done with the bitwise boolean operators `&` and `|`
- Using a non-boolean value anywhere **except for the last entry in a conditional chain** is an error
- `for` loops can be used with either `=`, `in` or `∈`
- `break` and `continue` statements are supported
- Multiple nested `for` loops can be combined into a single outer loop,
  forming the cartesian product of its iterables
- Multiple containers can be iterated over at the same time in a single `for` loop using `zip`
- When writing an error message, it is preferred to make the first word lowercase
- The `error` function is used to produce an `ErrorException` that interrupts the normal flow of control
    * Use `error` if you want to raise `ErrorException`s, which are generic exceptions
    accompanied by a message as a string
    * Use `throw` when you want to control the type of exception raised

"""


# %% last line/subexpression is evaluated and returned
z = begin
    x = 1
    y = 2
    x + y
end

z = (
    x = 1;
    y = 2;
    x + y
)

begin x=1; y=2; x+y end

z = (x=1; y=2; x+y)


# %% conditionals
if x > y
    println("x greater than y")
elseif x == y
    println("x equal to y")
else
    println("x less than y")
end

# ERROR!
# if 1
#     ...
# end

if x + y == 3
    "Yay!"
else
    "Nay..."
end

# ternary operator
your_kimetsu_rating = 9//10
your_kimetsu_rating == 10//10 ? "I see you are a man of culture as well." : "You unworthy pig."


# %% short circuit evaluation
function fact(n::Int)
    n >= 0 || error("n must be non-negative")
    n == 0 && return 1
    n * fact(n-1)
end


# 1 && true  ERROR: TypeError: non-boolean used...
true && 1  # is okay


# %% loops!
# while loop syntax
i = 1
while i < 5
    println(i)
    i += 1
end

# for loop syntax(es)
for i in 1:4
    println(i)
end

for j = ['a', 'b', 'c']
    println(j)
end

for anime ∈ ["Kono Subarashii", "Re:Zero", "MHA"]
    println("I love $(anime)!")
end

for i ∈ 1:3, j ∈ 4:6
    println((i, j))
end

nms = ["John", "Sherlock", "John"]
surnms = ["Doe", "Holmes", "Watson"]
for (name, surname) ∈ zip(nms, surnms)
    println((name, surname))
end


# %% exceptions
# defining custom exceptions
struct MyCustomError <: Exception end

# throw syntax
function divide(a, b)
    b == 0 && throw(MyCustomError())
    return div(a, b)
end


# divide(10, 0) ERROR: ...
divide(10, 5)

# try-catch-finally syntax
try
    # somthing risky
catch e  # saves the Exception in the variable `e`
    # do something about error (if any)
finally
    # executed regardless
end
