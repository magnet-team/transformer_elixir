defmodule Transformerex.Path.Map do
  @moduledoc false

  alias Transformerex.Path

  def transform(path: path, mapping: mapping, json: json) do
    source = Map.get(mapping, "source")
    mapping = Map.drop(mapping, ["source"])
    updated_path = "#{path}#{source}."

    Enum.reduce(mapping, %{}, fn {target, new_mapping}, result ->
      Map.put(
        result,
        target,
        Path.transform(
          mapping: new_mapping,
          path: updated_path,
          target: target,
          json: json
        )
      )
    end)
  end
end
