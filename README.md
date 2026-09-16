# nicktoumpelis/tap

Homebrew formulae by Nick Toumpelis.

| Formula | What it is |
|---|---|
| [`clocwork`](Formula/clocwork.rb) | Lines per language, AI co-authored commits and token cost over a repository's whole history, as one dashboard ([source](https://github.com/nicktoumpelis/clocwork)) |

## Installing

```bash
brew install nicktoumpelis/tap/clocwork
```

Homebrew loads a formula from a tap outside its own only once the formula is
trusted. Installing by the full name, as above, trusts that formula. After a
bare `brew tap nicktoumpelis/tap`, run
`brew trust --formula nicktoumpelis/tap/clocwork` before `brew install clocwork`.

In a `Brewfile`, trust it in the entry:

```ruby
tap "nicktoumpelis/tap"
brew "nicktoumpelis/tap/clocwork", trusted: true
```

## Documentation

`brew help`, `man brew` or [Homebrew's documentation](https://docs.brew.sh).
