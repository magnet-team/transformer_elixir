defmodule Transformerex do
  @json_root_path "$."

  alias Transformerex.Path

  # TODO: YAML maps should be read into an Elixir map once at startup
  def transform(json, mapping) do
    {:ok, map} = Jason.decode(json)
    operate(map, mapping, @json_root_path)
  end

  defp operate(json, mapping, root) do
    Enum.reduce(mapping, %{}, fn {target, new_mapping}, result ->
      Map.put(
        result,
        target,
        Path.transform(
          mapping: new_mapping,
          path: fully_qualified_root(root),
          target: target,
          json: json
        )
      )
    end)
  end

  defp fully_qualified_root(root) do
    if String.match?(root, ~r/\A\$\./), do: root, else: "$.#{root}"
  end
end
