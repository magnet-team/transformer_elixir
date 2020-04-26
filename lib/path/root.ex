defmodule Transformerex.Path.Root do
  @moduledoc false

  def transform(path: path, target: target, json: json) do
    normalized_path = if String.match?(target, ~r/\A\$\./), do: target, else: "#{path}#{target}"
    {:ok, value} = Warpath.query json, normalized_path
    value
  end
end
