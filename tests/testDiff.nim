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

    test "RelDiff (short)":
        let original = "a\nc"
        let expected = "a\nbc"
        let value = relDiff(original,expected);
        let changed = applySteps(original, value)
        assert changed == expected
    
    test "RelDiff (lorepsum)":
        let original = """\nLorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nAenean vel elit ut dolor fringilla tristique sed eu mi.\nMorbi quis nunc ut tellus ullamcorper egestas eget eu ex.\nNulla vitae ex eget turpis volutpat vehicula a in nisi.\nMorbi et odio fermentum, dignissim magna at, hendrerit augue.\nMauris fermentum odio vitae lorem porta, eget tristique diam malesuada.\n\nAenean ut nisi ut sem egestas ultricies.\n"""
        let expected = """\nDuis sit amet nisl sit amet odio faucibus aliquam at vitae libero.\nIn pulvinar sapien sit amet orci consequat hendrerit a eget urna.\nIn euismod dui sit amet orci ultrices, id lacinia sem rutrum.\n\nEtiam eu neque varius, dignissim lacus et, consectetur orci.\nDonec tincidunt tortor sodales, mattis quam a, ullamcorper libero.\nCurabitur nec quam facilisis, pulvinar ante ut, cursus velit.\nSuspendisse suscipit ligula et nibh hendrerit tempor.\nPhasellus vitae enim at eros dignissim rhoncus.\n\nVivamus dictum magna vel augue semper, ac fringilla mi fermentum.\n"""
        let steps = relDiff(original,expected);
        let changed = applySteps(original, steps)        
        assert changed == expected

    test "Inverse steps (short)":
        let original = "a\nb"
        let expected = "a\nc"
        let steps = relDiff(original,expected);
        let changed = applySteps(expected, reverseSteps(steps)) 
        assert changed == original
    
    test "Inverse steps (lorepsum)":
        let original = """\nLorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nAenean vel elit ut dolor fringilla tristique sed eu mi.\nMorbi quis nunc ut tellus ullamcorper egestas eget eu ex.\nNulla vitae ex eget turpis volutpat vehicula a in nisi.\nMorbi et odio fermentum, dignissim magna at, hendrerit augue.\nMauris fermentum odio vitae lorem porta, eget tristique diam malesuada.\n\nAenean ut nisi ut sem egestas ultricies.\n"""
        let expected = """\nDuis sit amet nisl sit amet odio faucibus aliquam at vitae libero.\nIn pulvinar sapien sit amet orci consequat hendrerit a eget urna.\nIn euismod dui sit amet orci ultrices, id lacinia sem rutrum.\n\nEtiam eu neque varius, dignissim lacus et, consectetur orci.\nDonec tincidunt tortor sodales, mattis quam a, ullamcorper libero.\nCurabitur nec quam facilisis, pulvinar ante ut, cursus velit.\nSuspendisse suscipit ligula et nibh hendrerit tempor.\nPhasellus vitae enim at eros dignissim rhoncus.\n\nVivamus dictum magna vel augue semper, ac fringilla mi fermentum.\n"""
        let steps = relDiff(original,expected);
        let changed = applySteps(expected, reverseSteps(steps))        
        assert changed == original