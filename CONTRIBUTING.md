# Contributing to DNSimple/Elixir

## Getting started

### Environment Setup

-   **Clone the repository**

    ```shell
    $ git clone git@github.com:weppos/dnsimple-elixir.git
    $ cd dnsimple-elixir
    ```

-   **Install Elixir**

-   **Install the dependencies**

    ```shell
    $ mix deps.get
    ```

-   **Build and test**

    Compile the project and [run the test suite](#testing) to check everything works as expected.

### Testing

```shell
$ mix compile
$ mix test
```

## Tests

Submit unit tests for your changes. You can test your changes on your machine by [running the test suite](#testing).

When you submit a PR, tests will also be run on the continuous integration environment [through Travis](https://travis-ci.com/aetrion/dnsimple-php).
