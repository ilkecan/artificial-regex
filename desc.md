# Regex fun

Each line of your input file is a string, encoding a simple regular expression.

Each regex string consists only of lowercase letters, parens and square brackets.

Each regex string is well bracketed, ie. every open paren/square bracket has a matching closing pair.

We have the following simple matching rules:

  - lowercase letters match themselves, eg.:
    `a` matches `a` and nothing else
  - parens enclosing only letters match their full sequence, eg.:
    `(abc)` matches `abc` and nothing else
  - square brackets enclosing only letters match every letters inside, eg.:
    `[abc]` matches `a` and `b` and `c` and nothing else

Parens and square brackets can contains other parenthesised and/or square bracketed groups not just letters.

The following are all valid:

  - `(a[bc])` matches `ab` and `ac` and nothing else
  - `[a(bc)]` matches `a` and `bc` and nothing else
  - `(a(bc))` is the same as `(abc)` and matches `abc` and nothing else
  - `[a[bc]]` is the same as `[abc]` and matches `a` and `b` and `c` and nothing else

The last two examples suggest that we can even simplify some of the regexes! Simplifying here means making the regex string as short as you can whilst still matching the same set of strings as the original regex.

For example `[a[[bb]b[[b]]](c)(d)]` is really just the same as `[abcd]` which matches `a`, `b`, `c` and `d`.

Your task is to parse the input file and for each regex output the following 3-tuple:
  - the number of strings it matches
  - the original regex string
  - the simplified regex string

 For example the output for the above input `[a[[bb]b[[b]]](c)(d)]` is:

```
(4, "[a[[bb]b[[b]]](c)(d)]", "[abcd]")
```

Do this for every line of the input file and sort the resulting list by the number of matches ascending, eg.:

The following input file:

```
[[a]b]
((a)b)
```

produces the following output:

```
[(1,"((a)b)","(ab)"),(2,"[[a]b]","[ab]")]
```

You will find your input file attached to this gist.

Please create a new private github repository named artificial-regex. Put your source code in there and once done please invite me (pwm) so we can check your solution. Please also add tests that you deem meaningful.

Good luck!
