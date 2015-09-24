//: Playground - noun: a place where people can play

import UIKit

struct Vector {
    var x: Float
    var y: Float
    var z: Float
    
    mutating func add(vector: Vector) {
        
        // add vectors
        x += vector.x
        y += vector.y
        z += vector.z
    }
    
    // a type method is associated with the specific type, as opposed to a specific instance
    static func vector(defaultValue: Float) -> Vector {
        return Vector(x: defaultValue, y: defaultValue, z: defaultValue)
    }
}

var vectorA = Vector(x: 0, y: 4, z: 15)
var vectorB = Vector(x: 10, y: 20, z: 15)

// to call type methods, you don't query a specific instance of an entity, just the type itself
vectorA.add(vectorB)

var vectorC = Vector.vector(75)

struct Person
{
    var firstName = ""
    var lastName = ""
    
    mutating func changeNames(first: String, last: String)
    {
        firstName = first
        lastName = last
    }
}

var thisGuy = Person(firstName: "Shawn", lastName: "Michaels")

thisGuy.firstName
thisGuy.lastName

thisGuy.changeNames("Dusty", last: "Rhodes")

thisGuy.firstName
thisGuy.lastName