%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "test/"],
        excluded: []
      },
      checks: [
        # To deactivate a check:
        # Put `false` as second element:

        {Credo.Check.Consistency.TabsOrSpaces},
        {Credo.Check.Design.AliasUsage, priority: :normal},
        {Credo.Check.Readability.AliasOrder},
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 80},
        {Credo.Check.Readability.SpaceAfterCommas},
        {Credo.Check.Readability.TrailingBlankLine},
        {Credo.Check.Readability.TrailingWhiteSpace},
        {Credo.Check.Warning.IExPry}
      ]
    }
  ]
}
