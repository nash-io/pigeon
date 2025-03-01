defmodule Pigeon.FCM.Error do
  @moduledoc false

  alias Pigeon.FCM.Notification

  require Logger

  @doc false
  @spec parse(map) :: Notification.error_response()
  def parse(%{"details" => [%{"errorCode" => error_code}]}) when is_binary(error_code) do
    parse_response(error_code)
  end

  def parse(%{"status" => status}) when is_binary(status) do
    parse_response(status)
  end

  def parse(unknown_error) do
    parse_response(unknown_error)
  end

  defp parse_response("UNSPECIFIED_ERROR"), do: :unspecified_error
  defp parse_response("INVALID_ARGUMENT"), do: :invalid_argument
  defp parse_response("UNREGISTERED"), do: :unregistered
  defp parse_response("SENDER_ID_MISMATCH"), do: :sender_id_mismatch
  defp parse_response("QUOTA_EXCEEDED"), do: :quota_exceeded
  defp parse_response("UNAVAILABLE"), do: :unavailable
  defp parse_response("INTERNAL"), do: :internal
  defp parse_response("THIRD_PARTY_AUTH_ERROR"), do: :third_party_auth_error

  defp parse_response(unknown_error) do
    Logger.error("Unknown FCM error #{inspect(unknown_error)}")
    :unknown_error
  end
end
