defmodule Transformerex.Path.List do
  @moduledoc false

  alias Transformerex.Path

  def transform(path: path, mapping: mapping, json: json) do
    source          = Map.get mapping, "source"
    mapping         = Map.drop mapping, ["source"]
    elements_path   = "#{path}#{source}[*]"
    {:ok, elements} = Warpath.query json, elements_path

    List.foldl elements, [], fn(_element, result) ->
      updated_path = "#{path}#{source}[#{Enum.count(result)}]."

      reduction =
        Enum.reduce mapping, %{}, fn({target, new_mapping}, result) ->
          Map.put(
            result,
            target,
            Path.transform(
              mapping: new_mapping,
              path:    updated_path,
              target:  target,
              json:    json
            )
          )
        end

      [reduction | result]
    end
  end
end
