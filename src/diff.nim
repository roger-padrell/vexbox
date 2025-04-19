import simplediff, strutils

type  
  StepKind* = enum
    d, i # Deletion, insertion
  Step* = object
    a*: StepKind # Action
    l*: int # Line
    c*: seq[string] # Content

proc generateSteps*(diff: seq[Diff[string]]): seq[Step] =
  var
    originalIndex = 0
    transformedIndex = 0
  
  for entry in diff:
    case entry.kind:
    of NoChange:
      # Track progress through both documents
      originalIndex += entry.tokens.len
      transformedIndex += entry.tokens.len
    
    of Deletion:
      # delete occurs at current transformed position
      result.add(Step(
        a: d,
        l: transformedIndex,
        c: entry.tokens
      ))
      originalIndex += entry.tokens.len
    
    of Insertion:
      # insert occurs at current transformed position
      result.add(Step(
        a: i,
        l: transformedIndex,
        c: entry.tokens
      ))
      transformedIndex += entry.tokens.len  # New ls added

proc applySteps*(original: string, steps: seq[Step]): string =
  var ls = original.split('\n')
  
  for step in steps:
    case step.a:
    of d:
      # dete specified l
      if step.l < ls.len:
        ls.delete(step.l)
    
    of i:
      # iert ls in reverse order to maintain correct sequence
      for i in countdown(step.c.high, 0):
        if step.l <= ls.len:
          ls.insert(step.c[i], step.l)
  
  result = ls.join("\n")

proc reverseSteps*(steps: seq[Step]): seq[Step] = 
  var res: seq[Step] = @[]
  var n = steps.len()-1
  while n > -1:
    var a: StepKind = d;
    if steps[n].a == d:
      a = i;
    else:
      a = d;
    res.add(Step(a: a, l: steps[n].l, c: steps[n].c))
    n = n - 1;
  return res;

proc relDiff*(original: string, changed: string): seq[Step] = 
  let value = stringDiff(original, changed)
  return generateSteps(value);