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


## Logging

The client logs the requests made to the DNSimple API:

```
iex(2)> Dnsimple.Identity.whoami(client)

09:45:08.229 [debug] [dnsimple] GET https://api.sandbox.dnsimple.com/v2/whoami
{:ok,
 %Dnsimple.Response{data: %Dnsimple.Whoami{account: %Dnsimple.Account{email: "javier@dnsimple.com",
    id: 63, plan_identifier: "dnsimple-professional"}, user: nil},
  http_response: %HTTPoison.Response{body: "{\"data\":{\"user\":null,\"account\":{\"id\":63,\"email\":\"javier@dnsimple.com\",\"plan_identifier\":\"dnsimple-professional\",\"created_at\":\"2014-07-02T14:15:56Z\",\"updated_at\":\"2016-12-14T08:44:06Z\"}}}",
   headers: [{"Server", "nginx"}, {"Date", "Mon, 26 Dec 2016 08:45:07 GMT"},
    {"Content-Type", "application/json; charset=utf-8"},
    {"Transfer-Encoding", "chunked"}, {"Connection", "keep-alive"},
    {"X-RateLimit-Limit", "2400"}, {"X-RateLimit-Remaining", "2398"},
    {"X-RateLimit-Reset", "1482745464"},
    {"ETag", "W/\"d01b8b299498e2b3d9207dee0a2c92a1\""},
    {"Cache-Control", "max-age=0, private, must-revalidate"},
    {"X-Request-Id", "6c3fb7b0-2c8d-4166-8fc0-ef3961d26d42"},
    {"X-Runtime", "0.025066"}, {"X-Content-Type-Options", "nosniff"},
    {"X-Download-Options", "noopen"}, {"X-Frame-Options", "DENY"},
    {"X-Permitted-Cross-Domain-Policies", "none"},
    {"X-XSS-Protection", "1; mode=block"},
    {"Strict-Transport-Security", "max-age=31536000"}], status_code: 200},
  pagination: nil, rate_limit: 2400, rate_limit_remaining: 2398,
  rate_limit_reset: 1482745464}}
```

The log level used for this is `debug`. If you want to disable the logging you will have to configure the logging level of your app.

```elixir
config :logger, level: :info
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

The value you provide will be appended to the default `User-Agent` the client uses. For example, if you use `my-app`, the final header value will be `dnsimple-elixir/1.0 my-app` (note that it will vary depending on the client version).


## License

Copyright (c) 2015-2016 Aetrion LLC. This is Free Software distributed under the MIT license.

