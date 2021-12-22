# Contributing to DNSimple/Elixir

## Getting started

### 1. Clone the repository

Clone the repository and move into it:

```shell
git clone git@github.com:dnsimple/dnsimple-elixir.git
cd dnsimple-elixir
```

### 2. Install Elixir

### 3. Install the dependencies

```shell
mix deps.get
```

### 4. Build and test

Compile the project and [run the test suite](#testing) to check everything works as expected.

## Testing

```shell
mix test
```

## Releasing

The following instructions uses `$VERSION` as a placeholder, where `$VERSION` is a `MAJOR.MINOR.BUGFIX` release such as `1.2.0`.

1. Run the test suite and ensure all the tests pass.

1. Set the version in `mix.exs`:

    ```elixir
    defmodule Dnsimple.Mixfile do
      use Mix.Project

      @version "$VERSION"
    end
    ```

1. Run the test suite and ensure all the tests pass.

1. Finalize the `## main` section in `CHANGELOG.md` assigning the version.

1. Commit and push the changes

    ```shell
    git commit -a -m "Release $VERSION"
    git push origin main
    ```

1. Wait for CI to complete.

1. Create a signed tag.

    ```shell
    git tag -a v$VERSION -s -m "Release $VERSION"
    git push origin --tags
    ```

1. GitHub actions will take it from there and release to Hex

## Tests

Submit unit tests for your changes. You can test your changes on your machine by [running the test suite](#testing).

When you submit a PR, tests will also be run on the [continuous integration environment via GitHub Actions](https://github.com/dnsimple/dnsimple-ruby/actions/workflows/ci.yml).
