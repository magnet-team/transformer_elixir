defmodule TransformerexTest do
  use ExUnit.Case

  setup do
    original_data = test_json() |> Jason.decode!()
    transformed_data = Transformerex.transform(test_json(), test_mapping())
    [original_data: original_data, transformed_data: transformed_data]
  end

  test "transforms mapped key, dob: birth_date", context do
    expected_value = "June 1, 1964"

    assert Map.has_key?(context.original_data, "dob")
    assert context.original_data["dob"] == expected_value

    refute Map.has_key?(context.transformed_data, "dob")
    assert Map.has_key?(context.transformed_data, "birth_date")
    assert context.transformed_data["birth_date"] == expected_value
  end

  test "omits unmapped key, city", context do
    assert Map.has_key?(context.original_data, "city")
    refute Map.has_key?(context.transformed_data, "city")
  end

  test "retains explicitly mapped key, first_name: $.first_name", context do
    expected_value = "Martin"
    assert Map.has_key?(context.original_data, "first_name")
    assert context.original_data["first_name"] == expected_value
    assert Map.has_key?(context.transformed_data, "first_name")
    assert context.transformed_data["first_name"] == expected_value
  end

  test "retains implicitly mapped key, last_name: <blank>", context do
    expected_value = "Streicher"
    assert Map.has_key?(context.original_data, "last_name")
    assert context.original_data["last_name"] == expected_value
    assert Map.has_key?(context.transformed_data, "last_name")
    assert context.transformed_data["last_name"] == expected_value
  end

  # test "show me the data" do
  #   test_json()
  #   |> Jason.decode!()
  #   |> IO.inspect()

  #   test_mapping()
  #   |> IO.inspect()
  # end

  defp test_json do
    {:ok, json} =
      Path.relative("test/support/files/test.json")
      |> File.read()

    json
  end

  defp test_mapping do
    {:ok, map} =
      Path.relative("test/support/files/test_mapping.yml")
      |> YamlElixir.read_from_file()

    map
  end
end
