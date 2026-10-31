import Foundation


var fruits = ["Apple", "Banana", "Orange", "Mango", "Grapes"]
print(fruits[2]) 


var favoriteNumbers: Set<Int> = [7, 42, 99]
favoriteNumbers.insert(13)
print(favoriteNumbers)


var programmingLanguages = ["C": 1972, "Java": 1995, "Swift": 2014]
print(programmingLanguages["Swift"]!) 


var colors = ["Red", "Green", "Blue", "Yellow"]
colors[1] = "Purple"
print(colors)



let set1: Set<Int> = [1, 2, 3, 4]
let set2: Set<Int> = [3, 4, 5, 6]
let intersectionSet = set1.intersection(set2)
print(intersectionSet)


var studentScores = ["Alice": 85, "Bob": 92, "Charlie": 78]
studentScores.updateValue(95, forKey: "Bob")
print(studentScores)


var array1 = ["apple", "banana"]
let array2 = ["cherry", "date"]
array1.append(contentsOf: array2)
print(array1)



var countryPopulations = ["Kazakhstan": 20000000, "USA": 331000000]
countryPopulations["Japan"] = 125000000
print(countryPopulations)

let animalSet1: Set<String> = ["cat", "dog"]
let animalSet2: Set<String> = ["dog", "mouse"]
let unionSet = animalSet1.union(animalSet2)
let finalSet = unionSet.subtracting(animalSet2)
print(finalSet)

var studentGrades = [
    "John": [85, 90, 92],
    "Emma": [95, 88, 100]
]
print(studentGrades["John"]![1])
