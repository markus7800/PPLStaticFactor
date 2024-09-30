import JuliaSyntax: SyntaxNode, children, SyntaxData, GreenNode, SyntaxHead, EMPTY_FLAGS, SourceFile, Kind

abstract type NodeTransformer end

function generic_visit!(visitor::NodeTransformer, node::SyntaxNode)::SyntaxNode
    i = 0
    for child in children(node)
        new_child = visit!(visitor, child)
        if !isnothing(new_child)
            i += 1
            node.children[i] = new_child
        end
    end
    if !isnothing(node.children)
        resize!(node.children, i)
    end

    return node
end

function visit!(visitor::NodeTransformer, node::SyntaxNode)::Union{Nothing,SyntaxNode}
    return generic_visit!(visitor, node)
end

function add_child!(node::SyntaxNode, child::SyntaxNode)
    push!(node.children, child)
    child.parent = node
end

function delete_child!(node::SyntaxNode, child::SyntaxNode)
    ix = findfirst(c -> c == child, node.children)
    deleteat!(node.children, ix)
    child.parent = nothing
    return ix
end

function insert_child!(node::SyntaxNode, index::Integer, child::SyntaxNode)
    insert!(node.children, index, child)
    child.parent = node
end

function set_children!(node::SyntaxNode, children::Vector{SyntaxNode})
    node.children = children
    for child in children
        child.parent = node
    end
end

import JuliaSyntax: SourceFile, Kind
const EMPTY_SOURCE = SourceFile(" ")

# Created node does not map to a GreenNode, because we change source code
function get_empty_syntax_node(kind::Kind; flags::JuliaSyntax.RawFlags=EMPTY_FLAGS, source::SourceFile=EMPTY_SOURCE, span::UInt32=UInt32(0), position::Int=1, val::Any=nothing)::SyntaxNode
    SyntaxNode(
        nothing,
        nothing,
        SyntaxData(
            source,
            GreenNode(SyntaxHead(kind, flags), span, ()),
            position,
            val
        )
    )
end

mutable struct LoopUnroller <: NodeTransformer
end

function copy_body!(node::SyntaxNode, loop_var::SyntaxNode, loop_var_value::Int)
    if kind(node) == K"Identifier" && node.val == loop_var.val
        replaced_node = get_empty_syntax_node(K"Integer", val=loop_var_value)
        return replaced_node
    end
    copied_node = SyntaxNode(nothing, nothing, node.data)
    if JuliaSyntax.haschildren(node)
        copied_node.children = SyntaxNode[]
        for child in JuliaSyntax.children(node)
            copied_child = copy_body!(child, loop_var, loop_var_value)
            add_child!(copied_node, copied_child)
        end
    end
    return copied_node
end

function visit!(visitor::LoopUnroller, node::SyntaxNode)::Union{Nothing,SyntaxNode}
    if kind(node) == K"for"
        loop_var_node = node[1]
        @assert kind(loop_var_node) == K"=" "Cannot unroll loop: Unknown loop_var_node $loop_var_node."
        loop_var = loop_var_node[1]
        @assert kind(loop_var) == K"Identifier" "Cannot unroll loop: Unknown loop_var $loop_var."
        loop_range = loop_var_node[2]

        @assert kind(loop_range) == K"call" && kind(loop_range[2]) == K":"
        start_node = loop_range[1]
        end_node = loop_range[3]
        @assert kind(start_node) == K"Integer"
        @assert kind(end_node) == K"Integer"
        unroll_range = start_node.val : end_node.val

        # println("unroll_range: ", unroll_range)
        
        body = node[2]
        @assert kind(body) == K"block"
        block_node = get_empty_syntax_node(K"block")
        block_node.children = SyntaxNode[]

        parent = node.parent
        ix = delete_child!(parent, node)
        for i in unroll_range
            copied_body = copy_body!(body, loop_var, i)
            for child in JuliaSyntax.children(copied_body)
                add_child!(block_node, child)
            end
        end
        insert_child!(parent, ix, block_node)

        # for nested loops
        generic_visit!(visitor, block_node)

        return block_node
    end

    return generic_visit!(visitor, node)
end

function unroll_loops!(node::SyntaxNode)
    visit!(LoopUnroller(), node)
end