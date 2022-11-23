using Markdown

md"""

# Characters

- Can be converted to a numeric value representing a Unicode code point
- You can input any Unicode character in single quotes using
  \u followed by up to four hexadecimal digits or \U followed by
  up to eight hexadecimal digits (thought the longest valid value only requires six)

# Strings

- All string types are subtypes of the abstract type `AbstractString`
  If you define a function expecting a string argument, you should
  declare the type as `AbstractString` in order to accept any string type
- Delimited by double quotes or triple double quotes
- Indexing is one-based
- Range indexing makes a copy of the selected part of the original string.
  Alternatively, it is possible to create a view into a string using
  the type `SubString`
- String indices in Julia refer to code units (= bytes for UTF-8),
  the fixed-width building blocks that are used to encode arbitrary
  characters (code points). This means that not every index into
  a String is necessarily a valid index for a character
- The next/previous valid indices can be computed by `nextind` and `prevind`
- `length` returns the number of characters, not the number of bytes!
    - `length(s)` ≤ `lastindex(s)`
- String literals are interpolated using `$`
- `string` actually just returns the output of `print`
- Triple-quoted strings are dedented to the level of the least-indented line
- If the opening \""" is followed by a newline, the newline is stripped from the resulting string
- Perl-compatible regular expressions

"""


#################### Characters ####################

c = 'ب'
typeof(c)

# convert c to Unicode code point
cp = Int(c)
Char(cp)

# in case of wanting to know the Unicode hex representation
"U+" * string(cp, base=16, pad=8)

# `Char` also accepts hex values
Char(0x0274)
Char('\u0274')  # pay attention to single quotes!
Char('\u74')
Char('\U00000274')  # uppercase U can have up to 8 digits

# C-style escaped input form
Char('\x7f')
Int('\x7f')
Char('\177')
Int('\177')

# using Unicode in string literals
"\u2200 x \u2203 y"

# comparison
'A' < 'a'
'A' < 'a' < 'Z'
'A' <= 'X' <= 'Z'

# arithmetic
'x' - 'a'
'x' + 2


#################### Strings ####################

str = "While the Duchess sang the second verse of the song..."
long_str =
"""
Alice could hardly hear the words:—

"I speak severely to my boy,
    I beat him when he sneezes;
For he can thoroughly enjoy
    The pepper when he pleases!"
"""

# indexing
str[begin]
str[1]  # one-based indexing
str[11:17]
str[end]
str[end:-1:end-6]
# str[end + 1] ERROR: BoundsError: ...

# functions to return first and last index
firstindex(str)
lastindex(str)

# create a view into string
substr = SubString(str, 28, 39)
typeof(substr)

# string with some character bytes > 0
s = "\u2200 x \u2203 y"
s[1]
# s[2], s[3] ERROR: StringIndexError: ...

# next vaild index for multi-byte characters
next = nextind(s, 1)
s[next]
nextnext = nextind(s, next)
s[nextnext]

# useful funcs for iteration
eachindex(s)
thisind(s, 2)

# convert data to/from UTF-8
encoded = transcode(UInt32, "Cheshire Cat")  # convert to UTF-32
decoded = transcode(String, encoded)  # convert to UTF-8

# concatenation
string("Queen", "of", "Hearts")
"Queen" * "of" * "Hearts"
join(["Queen", "of", "Hearts"], " ")

# interpolation
name = "Alice"
surname = "Liddell"
fullname = "$name $surname"
"length($name) = $(length(name))"
print("\$100")

# string comparison is lexicographic
"a man came" < "came a man"
"1 + 2 = 3" == "1 + 2 = $(1+2)"

# search for index of a particular character
findfirst(isequal('o'), "xylophone")
findlast(isequal('o'), "xylophone")

findnext(isequal('o'), "xylophone", 1)
findnext(isequal('o'), "xylophone", 5)
findprev(isequal('o'), "xylophone", 5)

# check if substring exists
occursin("Wonder", "Wonderland")

# string repetition
"My..."^3
repeat("Zzz...", 3)


#################### Non-Standard Strings ####################

# %% regex strings
re = r"l.*?k"
typeof(re)

# check for matches
occursin(re, "Are you looking at the lock or the silk?")
occursin(re, "Using the electronic locator, they found a path up.")

# find multiple matches
collect(eachmatch(re, "The locals attacked the lackey!"))

# capture info about the match
line = "The fat cat raced to the carrot cart."
re = r"(c)(a)(r|t)"  # () is a capturing group
m = match(re, line)

# RegexMatch objects have the following attributes
m.match
m.captures
m.offset
m.offsets

# %% byte-array string literals
b"DATA\xff\u2200"
# if you are wondering what the fuck this is, visit
# https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses/

# %% version number literals
v"2"
v"0.2"
v"0.2.1-rc1+win64"
typeof(v"0.2.1-rc1+win64")

# current Julia version
VERSION

# version strings can be used for version comparison
if v"0.2" <= VERSION < v"0.3-"
  # do something specific to 0.2 release series
end

# %% raw strings
raw"""
I'll be there next time,
I'll be there next time.
"""

raw"""A\nB\nC"""
"A\nB" == raw"A\nB"

# exception!
"\"" == raw"\""

# %% markdown strings
md"Do I really need to explain this to you?"
