## :warning: Development Warning

This project targets the development of the API client for the [DNSimple API v2](https://developer.dnsimple.com/v2/).

This version is currently under development, therefore the methods and the implementation should he considered a work-in-progress. Changes in the method naming, method signatures, public or internal APIs may happen at any time.

The code is tested with an automated test suite connected to a continuous integration tool, therefore you should not expect :bomb: bugs to be merged into master. Regardless, use this library at your own risk. :boom:


# DNSimple Elixir Client

An Elixir client for the [DNSimple API v2](https://developer.dnsimple.com/v2/).

[![Build Status](https://travis-ci.org/dnsimple/dnsimple-elixir.svg?branch=master)](https://travis-ci.org/dnsimple/dnsimple-elixir)



## Installation

You will have to add the `dnsimple` app to your `mix.exs` file as a dependency:

```elixir
def deps do
  [
    #...
    {:dnsimple, "~> 0.9"}
  ]
end
```

And then add it to the list of applications that should be started:

```elixir
def application do
  [applications: [ :dnsimple, ... ]]
end
```


## Usage

### From iex

```elixir
# Create a client passing the proper settings
iex> client = %Dnsimple.Client{access_token: "TOKEN", base_url: "https://api.sandbox.dnsimple.com/"}

# Check the login
iex> {:ok, response} =Dnsimple.Identity.whoami(client)
iex> response.data
#=> %{"account" => %{"created_at" => "2014-05-19T14:20:32.263Z",
      "email" => "example-account@example.com", "id" => 1,
      "updated_at" => "2015-04-01T10:07:47.559Z"}, "user" => nil}
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


## License

Copyright (c) 2015-2016 Aetrion LLC. This is Free Software distributed under the MIT license.

