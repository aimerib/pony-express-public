defmodule AlternativeChef.PonyExpress do
  alias ExTwilio.Message

  @from_number System.get_env("AC_TWILIO_NUMBER")

  def post_letter(message) do
    case AlternativeChef.Contacts.list_clients() do
      {:ok, clients} ->
        clients
        |> Enum.filter(fn client -> client.text == true end)
        |> Enum.each(fn client ->
          message = "Hello #{client.first_name}\n" <> message
          deliver_message(%{phone_number: client.phone_number, message: message})
          update_last_text_field(client)
        end)

      {:empty_list, _} ->
        {:error,
         """
         Can't send a message with an empty client list.
         Add a new client first.
         """}
    end
  end

  defp update_last_text_field(client) do
    AlternativeChef.Contacts.update_client_last_texted(client, %{
      last_texted: NaiveDateTime.local_now()
    })
  end

  defp deliver_message(%{message: message, phone_number: phone_number}) do
    Message.create(to: parse_number(phone_number), from: @from_number, body: message)
  end

  defp parse_number(phone_number) do
    "+1#{phone_number}"
  end
end
