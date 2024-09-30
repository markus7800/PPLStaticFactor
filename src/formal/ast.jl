using JuliaSyntax

filename = ARGS[1]
filecontent = read(open(filename, "r"),String)
# println(filename)
# println(filecontent)

ast = parseall(SyntaxNode, filecontent)
# println(ast)

function sexpr(node::SyntaxNode)
    s = "("
    if JuliaSyntax.haschildren(node)
        s *= string(untokenize(head(node)))
        s *= " "
        s *= join([sexpr(child) for child in JuliaSyntax.children(node)], "  ")
    else
        s *= string(kind(node))
        s *= " "
        value = node.val
        s *= value isa Symbol ? string(value) : repr(value)
    end
    s *= ")"
    return s
end

if length(ARGS) > 1 && ARGS[2] == "--unroll_loops"
    include("loop_unroller.jl")
    unroll_loops!(ast)
end

println(sexpr(ast))