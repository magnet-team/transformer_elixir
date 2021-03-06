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

  test "transforms nested mapping keys", context do
    assert Map.has_key?(context.original_data, "emails")
    refute Map.has_key?(context.transformed_data, "emails")
    assert Map.has_key?(context.transformed_data, "email_addresses")
  end

  test "retains nested mapping values", context do
    emails = Enum.map(context.transformed_data["email_addresses"], & &1)

    assert %{"email_address" => "jon@doe.com", "type" => "work"} in emails
    assert %{"email_address" => "jane@doe.com", "type" => "home"} in emails
  end

  defp test_json do
    Path.relative("test/support/files/test.json")
    |> File.read!()
  end

  defp test_mapping do
    Path.relative("test/support/files/test_mapping.yml")
    |> YamlElixir.read_from_file!()
  end
end
