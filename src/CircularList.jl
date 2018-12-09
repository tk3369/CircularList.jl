module CircularList

import Base: insert!, delete!, length

export circularlist, length, current, previous, next, 
    insert!, delete!, shift!, forward!, backward!

"""
Double linked list
"""
mutable struct Node{T} 
    data::Union{T, Nothing}
    prev::Union{Node{T}, Nothing}
    next::Union{Node{T}, Nothing}
end

"""
Buffer is used to hold a pre-allocated vector of nodes.
"""
mutable struct Buffer
    nodes::Vector{Node}
    current::Node
    length::Int
    last::Int
    capacity::Int
end

"Create a circular list with the specified data element."
function circularlist(data::T; capacity = 100) where T
    nodes = [Node{T}(nothing, nothing, nothing) for _ in 1:capacity]
    n = nodes[1]
    n.data = data
    n.prev = n
    n.next = n
    return Buffer(nodes, n, 1, 1, capacity)
end

"Returns the length of the circular list"
length(buf::Buffer) = buf.length

"Allocates a new uninitialized node in the circular list"
function allocate!(buf::Buffer, T::DataType)
    if buf.last == buf.capacity   # exceeded capacity...auto resize.
        newcapacity = buf.capacity * 2
        additional  = newcapacity - buf.capacity
        buf.nodes = vcat(buf.nodes, [Node{T}(nothing, nothing, nothing) for _ in 1:additional])
        buf.capacity = newcapacity
    end
    buf.length += 1
    buf.last += 1
    return buf.nodes[buf.last]
end

"Insert a new node after the current node and return the new node."
function insert!(buf::Buffer, data) 
    cl = buf.current
    
    n = allocate!(buf, typeof(data))  # make a new node and arrange prev/next pointers
    n.data = data
    n.prev = cl
    n.next = cl.next

    cl.next = n         # fix prev node's next pointer
    n.next.prev = n     # fix next node's prev pointer
    
    buf.current = n     # move pointer to newly inserted node
    return buf
end

"""
Delete current node and return the previous node.

_Warning_: removed nodes are not reclaimed from memory for simplicity reasons
"""
function delete!(buf::Buffer)
    length(buf) == 1 && error("cannot remove last item in circular list")
    cl = buf.current
    cl.prev.next = cl.next   # fix prev node's next pointer
    cl.next.prev = cl.prev   # fix next node's prev pointer
    buf.current = cl.prev    # reset buffer's current pointer to prev
    buf.length -= 1
    return buf
end

"""
Shift the current pointer forward or backward.
"""
function shift!(buf::Buffer, steps::Int, direction::Symbol)
    for i in 1:steps
        if direction == :forward 
            buf.current = buf.current.next
        elseif direction == :backward
            buf.current = buf.current.prev
        else
            error("Wrong direction: $direction")
        end
    end
    return buf
end

"Shift the current pointer forward."
forward!(buf::Buffer) = shift!(buf, 1, :forward)

"Shift the current pointer backward."
backward!(buf::Buffer) = shift!(buf, 1, :backward)

"Current node"
current(buf::Buffer) = buf.current

"Previous node"
previous(buf::Buffer) = buf.current.prev

"Next node"
next(buf::Buffer) = buf.current.next

end # module
