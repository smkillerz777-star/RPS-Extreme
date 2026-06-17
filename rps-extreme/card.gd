extends Node2D
class_name Cards
@export var element = null
func match(element1,element2):
    if(element1=="rock"):
        if(element2=="paper" or element=="s" or element=="s"):
            return element1
        elif(element2=="paper" or element=="s" or element=="s"):
            return element2
        else:
            return null
    elif(element1=="paper"):
        if(element2=="paper" or element=="s" or element=="s"):
            return element1
        elif(element2=="paper" or element=="s" or element=="s"):
            return element2
        else:
            return null
    elif(element1=="scissors"):
        if(element2=="paper" or element=="s" or element=="s"):
            return element1
        elif(element2=="paper" or element=="s" or element=="s"):
            return element2
        else:
            return null
    elif(element1=="light"):
        if(element2=="paper" or element=="s" or element=="s"):
            return element1
        elif(element2=="paper" or element=="s" or element=="s"):
            return element2
        else:
            return null
    elif(element1=="fire"):
        if(element2=="paper" or element=="s" or element=="s"):
            return element1
        elif(element2=="paper" or element=="s" or element=="s"):
            return element2
        else:
            return null
    elif(element1=="air"):
        if(element2=="paper" or element=="s" or element=="s"):
            return element1
        elif(element2=="paper" or element=="s" or element=="s"):
            return element2
        else:
            return null
    elif(element1=="water"):
        if(element2=="paper" or element=="s" or element=="s"):
            return element1
        elif(element2=="paper" or element=="s" or element=="s"):
            return element2
        else:
            return null
    return "0"