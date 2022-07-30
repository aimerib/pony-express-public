# Pony Express
A public version of Pony Express text message delivery system.

Built with Phoenix, Elixir, and Twilio.

## Development

### System Requirements
- Elixir 1.10.4
- Erlang OTP 23.1
- Node 12.18.2
- Postgresql

```shell
mix deps.get
mix deps.compile

cd pony-express-public

docker run --rm -p 5432:5432 -v \
  pony-express-data:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=postgres --name pony_express_db postgres

mix setup

mix phx.server
```

