# DNSimple Elixir Client

An Elixir client for the [DNSimple API v2](https://developer.dnsimple.com/v2/).

[![Build Status](https://travis-ci.org/dnsimple/dnsimple-elixir.svg?branch=master)](https://travis-ci.org/dnsimple/dnsimple-elixir)


## Installation

You will have to add the `dnsimple` app to your `mix.exs` file as a dependency:

```elixir
def deps do
  [
    {:dnsimple, "~> 1.0.0"}, #...
  ]
end
```

And then add it to the list of applications that should be started:

```elixir
def application do
  [applications: [
    :dnsimple, #...
  ]]
end
```


## Usage

### From iex

```elixir
# Create a client passing the proper settings
iex> client = %Dnsimple.Client{access_token: "TOKEN", base_url: "https://api.sandbox.dnsimple.com/"}

# Check the login
iex> {:ok, response} = Dnsimple.Identity.whoami(client)
iex> response.data
# => %{"account" => %{"created_at" => "2014-05-19T14:20:32.263Z",
# =>   "email" => "example-account@example.com", "id" => 1,
# =>   "updated_at" => "2015-04-01T10:07:47.559Z"}, "user" => nil}
```


### From an .exs file

```elixir
# Start Dnsimple app
Dnsimple.start

# Create a client passing the proper settings
client = %Dnsimple.Client{access_token: "TOKEN", base_url: "https://api.sandbox.dnsimple.com/"}

# Check the login
Dnsimple.Identity.whoami(client)
```

## Sandbox Environment

We highly recommend testing against our [sandbox environment](https://developer.dnsimple.com/sandbox/) before using our production environment. This will allow you to avoid real purchases, live charges on your credit card, and reduce the chance of your running up against rate limits.

The client supports both the production and sandbox environment. To switch to sandbox pass the sandbox API host using the `base_url` option when you construct the client:

```elixir
client = %Dnsimple::Client{base_url: "https://api.sandbox.dnsimple.com", access_token: "a1b2c3"}
```

You will need to ensure that you are using an access token created in the sandbox environment. Production tokens will *not* work in the sandbox environment.

## Setting a custom `User-Agent` header

You customize the `User-Agent` header for the calls made to the DNSimple API:

```elixir
client = %Dnsimple::Client{user_agent: "my-app", access_token: "a1b2c3"}
```

Note that the value you provide will be appended to the default `User-Agent` the client uses. So, if you use `my-app`, the final header value will be something like `dnsimple-elixir/1.0 my-app`.

## License

Copyright (c) 2015-2016 Aetrion LLC. This is Free Software distributed under the MIT license.

