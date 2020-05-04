defmodule Transformerex do
  @json_root_path "$."

  alias Transformerex.Path

  # TODO: the intent here is that the YAML maps will be read once at startup
  def transform(json, yaml_mapping) do
    {:ok, map} = Jason.decode(json)
    operate(map, yaml_mapping, @json_root_path)
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
