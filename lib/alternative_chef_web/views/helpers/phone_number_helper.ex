defmodule AlternativeChefWeb.PhoneNumberHelper do
  def phone_number_formatter(options \\ []) do
    [_, first, second, third] =
      Regex.run(~r/(\d{3})(\d{3})(\d{4})/, value(options[:phone_number]))

    AlternativeChefWeb.PhoneNumberView.render("phone_number.html",
      phone_number: "(#{first}) #{second}-#{third}"
    )
  end

  defp value(fun) when is_function(fun, 0), do: fun.()
  defp value(val), do: val
end
