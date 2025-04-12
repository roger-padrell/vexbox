import simplediff, unittest, ../src/diff

suite "Diff tests":
    test "Simple int (addition)":
        let value = diff([1, 2, 3], [1, 2])
        let expected = @[Diff[int](kind: NoChange, tokens: @[1, 2]), Diff[int](kind: Deletion, tokens: @[3])]
        assert value == expected

    test "Simple string (addition)":
        let value = stringDiff("the word is", "the word is red", seps={' '})
        let expected = @[Diff[string](kind: NoChange, tokens: @["the", "word", "is"]), Diff[string](kind: Insertion, tokens: @["red"])]
        assert value == expected

    test "Simple string with line (replacement)":
        let value = stringDiff("a\nb","a\nc")
        let expected = @[Diff[string](kind: NoChange, tokens: @["a"]), Diff[string](kind: Deletion, tokens: @["b"]), Diff[string](kind: Insertion, tokens: @["c"])];
        assert value == expected

    test "Simple string (deletion)":
        let value = stringDiff("the word is blue", "the word is", seps={' '})
        let expected = @[Diff[string](kind: NoChange, tokens: @["the", "word", "is"]), Diff[string](kind: Deletion, tokens: @["blue"])]
        assert value == expected
        
    test "Adding lines in the middle":
        let value = stringDiff("a\nc","a\nb\nc")
        let expected = @[Diff[string](kind: NoChange, tokens: @["a"]), Diff[string](kind: Insertion, tokens: @["b"]), Diff[string](kind: NoChange, tokens: @["c"])]
        assert value == expected

    test "RelDiff":
        let original = "a\nc"
        let expected = "a\nbc"
        let value = relDiff(original,expected);
        let changed = applySteps(original, value)
        assert changed == expected