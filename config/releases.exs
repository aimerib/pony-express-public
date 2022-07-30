import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :alternative_chef, AlternativeChefWeb.Endpoint, server: true

config :alternative_chef, AlternativeChef.Repo,
  url: database_url,
  ssl: true,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "2")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :alternative_chef, AlternativeChefWeb.Mailer,
  from: "support@mailer.alternativechefnc.com",
  adapter: Swoosh.Adapters.SparkPost,
  api_key: System.get_env("SPARKPOST_API"),
  endpoint: "https://api.sparkpost.com/api/v1"

config :alternative_chef, AlternativeChefWeb.Endpoint,
  http: [port: 4000],
  url: [scheme: "https", host: "texting.alternativechefnc.com", port: 443],
  secret_key_base: secret_key_base

config :libcluster,
  topologies: [
    k8s_example: [
      strategy: Cluster.Strategy.Kubernetes,
      config: [
        kubernetes_selector: System.get_env("LIBCLUSTER_KUBERNETES_SELECTOR"),
        kubernetes_node_basename: System.get_env("LIBCLUSTER_KUBERNETES_NODE_BASENAME")
      ]
    ]
  ]
