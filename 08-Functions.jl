using Markdown

md"""

Worthy notes:

- Basic syntax:

```
julia> function f(x,y)
           x + y
       end
f (generic function with 1 method)
```

- The function returns the value of the last expression evaluated
- The `return` keyword can also be used

```
julia> function f(x,y)
           return x * y
       end
```

- A more terse syntax:

```
julia> f(x,y) = x + y
f (generic function with 1 method)
```

- Without parentheses, the expression `f` refers to the function object

```
julia> g = f;
```

- Unicode can also be used for function names

```
julia> ∑(x,y) = x + y
∑ (generic function with 1 method)
```

- Argument types can be specified for a function call

```
julia> function echo(phrase::AbstractString, n::Int)
           return phrase ^ n
       end;
```

- A return type can be specified in the function declaration using the :: operator.
  This converts the return value to the specified type

```
julia> function g(x, y)::Int8
           return x * y
       end;

julia> typeof(g(1, 2))
Int8
```

- Functions can return `nothing` (same as `None` in Python)
- Functions are first-class objects
- Anonymous function syntax:

```
julia> x -> x^2 + 2x - 1
#1 (generic function with 1 method)
```

- Variable argument function syntax:

```
julia> foo(arg1, arg2, args...) = (arg1, arg2, args)
foo (generic function with 1 method)
```

- The `...` syntax can be used for decomposition of iterables inside calls

```
julia> bar(a, b) = b - a;

julia> bar((1, 2))
ERROR: ...

julia> bar((1, 2)...)
1
```

- Keyword arguments can be separated from positional arguments using `;`.
  Julia also supports variable-length keyword arguments

```
julia> function f(arg1, arg2, args...; kwarg1=val1, kwarg2=val2, kwargs...)
            # body
       end;
```

- Functions can be combined/chained. The syntax `(f ∘ g)(args...)` is the same as
  `f(g(args...))`. Chaining syntax consists of using `|>`

```
args... |> f |> g
```

"""


function f(x, y)::Int8
    x^2 + 2(x*y) + y^2
end


f(1, 1)
# f(10, 10)  # ERROR: InexactError: ...

g = f
g(1, 2)

# many operators are functions
1 + 2 + 3
+(1, 2, 3)

add = +
mul = *

1 + 2*3
add(1, mul(2, 3))

# anonymous function
(x,y) -> x^2y
() -> 10 + rand(-10:10)

# assigning anonymous functions
anonymous = (x,y) -> x^2y
anonymous(2, 3)

# tuples
(1, )
(2, "Umiko was here", ['あ', 'い', 'う', 'え', 'お'])
3, 4
golden_ratio, nepper = MathConstants.golden, MathConstants.e

# named tuples
namedtup = (name="Shoto", surname="Todoroki")
namedtup[1]
namedtup.name

# varargs
foo(a, b, x...) = (a, b, x)

foo(1, 2)
foo(1, 2, 3)
foo(1, 2, 3, 4)

# decompose iterable in function call
bar(x, y) = y - x

# bar((1, 2)) ERROR: MethodError: ...
bar((1, 2)...)

# optional arguments
date(y, m=1, d=1) = string(y, pad=4) * "-" * string(m, pad=2) * "-" * string(d, pad=2)

date(2021)
date(2021, 2)
date(2022, 6, 12)

# `do`
md"""

```
map([A, B, C]) do x
    if x < 0 && iseven(x)
        return 0
    elseif x == 0
        return 1
    else
        return x
    end
end
```

The `do x` syntax creates an anonymous function with argument `x` and
passes it as the first argument to `map`. Similarly, do `a,b` would create
a two-argument anonymous function, and a plain `do` would declare that
what follows is an anonymous function of the form `() -> ...`

"""

# function composition
(sqrt ∘ +)(3, 6)

# function chaining/piping
1:10 .|> sqrt |> sum
