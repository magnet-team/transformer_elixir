defmodule Transformerex.Path do
  @moduledoc false

  alias Transformerex.Path.List, as: TransList
  alias Transformerex.Path.Map, as: TransMap
  alias Transformerex.Path.Root

  def transform(mapping: nil, path: path, target: target, json: json) do
    Root.transform path: path, target: target, json: json
  end

  def transform(mapping: [mapping], path: path, target: target, json: json)  do
    TransList.transform path: path, mapping: mapping, json: json
  end

  def transform(mapping: mapping, path: path, target: target, json: json) when is_bitstring(mapping) do
    if String.match?(mapping, ~r/\A(\$\.)?[[:alpha:]_\-]+\z/) do
      Root.transform path: path, target: mapping, json: json
    end
  end

  def transform(mapping: mapping, path: path, target: target, json: json) when is_map(mapping) do
    TransMap.transform path: path, mapping: mapping, json: json
  end
end
