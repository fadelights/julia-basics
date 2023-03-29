using Dates
using Markdown

md"""

Worthy notes:

- The `Dates` module provides two types for working with dates: `Date` and `DateTime`,
  representing day and millisecond precision, respectively
- Both `Date` and `DateTime` are basically immutable `Int64` wrappers
- The `DateTime` type is not aware of time zones (naive, in Python parlance).
  Additional time zone functionality can be added through the `TimeZones.jl` package.

More information at: https://docs.julialang.org/en/v1/stdlib/Dates/

"""


# %% constructors
# `Date` and `DateTime` types can be constructed by integer or `Period` types
Date(2000)
Date(2000, 5)
Date(2000, 5, 24)
Date(Dates.Year(2000), Dates.Day(24))
Date(Dates.Month(5), Dates.Year(1918))

DateTime(1918, 5)
DateTime(1918, 5, 11, 6, 42, 7, 84)
DateTime(Dates.Hour(9), Dates.Minute(11))

# `Date` or `DateTime` parsing is accomplished by the use of format strings
Date("2003-06-04", dateformat"y-m-d")  # delimited slots
Date("20030604", dateformat"yyyymmdd")  # fixed-width slots
Date("4/6", dateformat"d/m/y")
Date("4/6", dateformat"d/m")
Date("June 4, 2003", dateformat"U d, y")

# `DateFormat`s may be created explicitly
df = DateFormat("y/m/d")
Date("99/2/15", df)

# broadcasting is pretty cool
wwdt = ["19399", "194592"]
Date.(wwdt, dateformat"yyyymd")

# `parse` is also an option
parse(Date, "23.6.1912", dateformat"d.m.y")

# `format` is the opposite of `parse`
Dates.format(Date(1912, 6, 23), "dd.mm.yyyy")


# %% durations, comparisons, & arithmetic
df = dateformat"u d, y"
albert = Date("Mar 14, 1879", df)
erwin = Date("Aug 12, 1887", df)

erwin > albert
erwin != albert

erwin - albert
albert - erwin
# erwin + albert  # MethodError: ...
diff = DateTime(erwin) - DateTime(albert)
canonicalize(diff)

# %% accessor functions
t = Date("7/oct/1885", dateformat"d/u/y")

Dates.year(t)
Dates.Year(t)

Dates.month(t)
Dates.Month(t)

Dates.yearmonth(t)
Dates.monthday(t)
Dates.yearmonthday(t)

# query stuff
Dates.dayofweek(t)
Dates.dayname(t)
Dates.monthname(t)
Dates.daysinmonth(t)  # How many days in October 1885?
Dates.dayofweekofmonth(t)  # 1st Wednesday of October
Dates.quarterofyear(t)
# etc...


# %% compound periods and arithmetic
duration = Dates.Hour(2) + Dates.Second(98)
canonicalize(duration)

# or...
duration = Dates.CompoundPeriod(Day(10), Millisecond(42))
canonicalize(duration)

y1 = Year(3)
y2 = Day(10)

y1 + y2
y1 - y2

# ranges
rng = Date(1939, 9, 1):Month(1):Date(1945, 9, 2)
collect(rng)


# %% pure time types
Dates.Time(3, 2, 10)
Dates.Time(Hour(3), Second(2))


# %% misc stuff
Dates.isleapyear(Date(2000))
time()  # seconds since Unix epoch
unix2datetime(time())  # GMT timezone
