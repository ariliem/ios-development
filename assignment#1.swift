import Foundation


let currentYear: Int = 2026
let birthYear: Int = 2006
var age: Int = currentYear - birthYear

var firstName: String = "Arailym"
var lastName: String = "Rakhman"
var isStudent: Bool = true
var height: Double = 1.68
var hometown: String = "Turkistan" 
var hobby: String = "painting 🎨" 
var numberOfHobbies: Int = 5
var favNum: Int = 7
var isHobbycreat: Bool = true


var favMus: String = "k-pop"


var futureGoals: String = "In the future, I want to become a professional iOS developer."
var 🚀: String = "I am ready to code!" 


var lifeStory: String = """
My name is \(firstName) \(lastName). I am \(age) years old, born in \(birthYear). \
I am currently a student: \(isStudent). My height is \(height) meters, and I am from \(hometown). \
I enjoy \(hobby), which is a creative hobby: \(isHobbycreat). \
I have \(numberOfHobbies) hobbies in total, my favorite number is \(favNum), and I love listening to \(favMus). \
\(futureGoals) \(🚀)
"""

print(lifeStory)
