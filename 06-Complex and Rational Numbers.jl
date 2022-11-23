using Markdown

md"""

# Complex Numbers
Worthy notes:

- The global constant `im` is bound to the complex number *i*,
  representing the principal square root of -1

  ```
  1 + 2im
  ```

- You can perform all the standard arithmetic operations with complex numbers
- Note that `3/4im == 3/(4*im) == -(3/4 * im)`
- Standard functions used with complex numbers: `real`, `imag`, `abs`, `conj`, `angle`, ...
- The full gamut of other *Elementary Functions* is also defined for complex numbers
- The `complex` function provides an easy way to create
  complex numbers from variables

# Rational Numbers
Worthy notes:

- Rationals are constructed using the `//` operator

```
julia> 3 // 9
1//3
```

- Rationals can easily be converted to floating-point numbers
  by using the `float` function
- Constructing infinite rational values is acceptable

```
julia> 5 // 0
1//0
```

- Trying to construct a NaN rational value, however, is invalid

```
julia> 0 // 0
ERROR: ArgumentError...
```

"""
