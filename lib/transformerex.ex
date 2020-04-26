defmodule Transformerex do
  @moduledoc false
  @json_root_path "$."
  @yaml_test_file "test/support/files/test.yml"

  alias Transformerex.Path

  def transform(file_path \\ @yaml_test_file, root \\ @json_root_path) do
    {:ok, [yaml]} = YamlElixir.read_all_from_file(file_path, atoms: true)
    operate yaml["data"], yaml["mapping"], root
  end

  defp operate(json, mapping, root) do
    Enum.reduce mapping, %{}, fn({target, new_mapping}, result) ->
      Map.put(
        result,
        target,
        Path.transform(
          mapping: new_mapping,
          path:    fully_qualified_root(root),
          target:  target,
          json:    json
        )
      )
    end
  end

  defp fully_qualified_root(root) do
    if String.match?(root, ~r/\A\$\./), do: root, else: "$.#{root}"
  end
end
