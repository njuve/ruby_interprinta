require "minruby"
#演算構文木の評価
def evaluate(tree, genv,lenv)
  case tree[0]
  when "lit"
    tree[1]
  when "+"
    left  = evaluate(tree[1], genv,lenv)
    right = evaluate(tree[2], genv,lenv)
    left + right
  when "-"
    left  = evaluate(tree[1], genv,lenv)
    right = evaluate(tree[2], genv,lenv)
    left - right
  when "*"
    left  = evaluate(tree[1], genv,lenv)
    right = evaluate(tree[2], genv,lenv)
    left * right
  when "**"
    left  = evaluate(tree[1], genv,lenv)
    right = evaluate(tree[2], genv,lenv)
    left ** right
  when "%"
    left  = evaluate(tree[1], genv,lenv)
    right = evaluate(tree[2], genv,lenv)
    left % right
  when "=="
    left  = evaluate(tree[1], genv,lenv)
    right = evaluate(tree[2], genv,lenv)
    if left == right
      true
    else
      false
    end
  when ">"
    left  = evaluate(tree[1], genv,lenv)
    right = evaluate(tree[2], genv,lenv)
    if left > right
      true
    else
      false
    end
  when "<"
    left  = evaluate(tree[1], genv,lenv)
    right = evaluate(tree[2], genv,lenv)
    if left < right
      true
    else
      false
    end
  when "<="
    left  = evaluate(tree[1], genv,lenv)
    right = evaluate(tree[2], genv,lenv)
    if left <= right
      true
    else
      false
    end
  when ">="
    left  = evaluate(tree[1], genv,lenv)
    right = evaluate(tree[2], genv,lenv)
    if left >= right
      true
    else
      false
    end
  when "/"
    left  = evaluate(tree[1], genv,lenv)
    right = evaluate(tree[2], genv,lenv)
    left / right
  when "func_call"
    args =[]
    i = 0
    while tree[i + 2]
      args[i] = evaluate(tree[i + 2], genv,lenv)
      i = i + 1
    end
    mhd = genv[tree[1]]
    if mhd[0] == "builtin"
      minruby_call(mhd[1], args)
    else
      new_lenv = {}
      params = mhd[1] #仮引数
      i = 0
      while params[i]
        new_lenv[params[i]] = args[i] #実引数を代入
        i = i + 1
      end
      evaluate(mhd[2], genv, new_lenv)
    end
  when "stmts"
    i = 1
    last = nil
    while tree[i]
      last = evaluate(tree[i], genv,lenv)
      i = i + 1
    end
    last
  when "var_assign"
    lenv[tree[1]] = evaluate(tree[2], genv,lenv)
  when "var_ref"
    lenv[tree[1]]
  when "if"
    if evaluate(tree[1], genv,lenv)
      evaluate(tree[2], genv,lenv)
    else
      evaluate(tree[3],genv,lenv)
    end
  when "while"
    while evaluate(tree[1],genv,lenv)
      evaluate(tree[2],genv,lenv)
    end
  when "func_def"
    genv[tree[1]] = ["use_defined", tree[2], tree[3]]
  else
  p("error")
  pp(tree)
  raise("unknown node")
  end
end

#構文木中の最大の数字を求める
def max(tree)
  case tree[0]
  when "lit"
    tree[1]
  else
    left  = evaluate(tree[1],genv,lenv)
    right = evaluate(tree[2],genv,lenv)
    if left >= right
      max = left
    else
      max = right
    end
  end
end


input = minruby_load()
tree = minruby_parse(input) #構文解析
genv = {"p" => ["builtin", "p"], "add" => ["builtin", "add"]}
lenv = {}
evaluate(tree, genv, lenv)
#output_max = max(tree)
#p(output)
#p(output_max)
