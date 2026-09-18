import Foundation

// MARK: - =================== STARTER CODE ===================
// MARK: - Do not modify anything in this section

typealias Reading = (sensor: String, value: Int)

/// Splits a string at the first occurrence of the separator.
/// splitOnce("O2:87", by: ":") -> ("O2", "87")
/// splitOnce("hello", by: ":") -> nil
func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.\n")

// MARK: - ================= END OF STARTER CODE =================


// MARK: - =================== YOUR SOLUTION ===================

// MARK: Level 1 · Decoding Telemetry

// 1.1
func parseReading(_ raw: String) -> Reading? {
    guard let pair = splitOnce(raw, by: ":"),
          !pair.0.isEmpty,
          let value = Int(pair.1),
          pair.0 == "TEMP" || value >= 0 else {
        return nil
    }
    return (sensor: pair.0, value: value)
}

// 1.2
func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var validReadings = [Reading]()
    var corrupted = 0
    
    for line in lines {
        if let reading = parseReading(line) {
            validReadings.append(reading)
        } else {
            corrupted += 1
        }
    }
    return (validReadings, corrupted)
}

let parsedData = parseLog(rawLog)
let A = parsedData.invalidCount


// MARK: Level 2 · Analysis

// 2.1
func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
    var result = [Reading]()
    for reading in readings {
        if isIncluded(reading) {
            result.append(reading)
        }
    }
    return result
}

func values(of readings: [Reading]) -> [Int] {
    var result = [Int]()
    for reading in readings {
        result.append(reading.value)
    }
    return result
}

let o2Readings = select(parsedData.valid) { $0.sensor == "O2" }
let o2Values = values(of: o2Readings)

// 2.2
func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
    guard !values.isEmpty else { return nil }
    
    var minVal = values[0]
    var maxVal = values[0]
    var sum = 0
    
    for v in values {
        if v < minVal { minVal = v }
        if v > maxVal { maxVal = v }
        sum += v
    }
    
    return (minVal, maxVal, Double(sum) / Double(values.count))
}

func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
    stats(of: values)
}

let B = Int(stats(of: o2Values)?.average ?? 0.0)

// 2.3 · The Closure Ladder (5 sorts, then compare results in code)
let toSort = parsedData.valid

let s1 = toSort.sorted(by: { (a: Reading, b: Reading) -> Bool in return a.value > b.value })
let s2 = toSort.sorted(by: { a, b in return a.value > b.value })
let s3 = toSort.sorted(by: { a, b in a.value > b.value })
let s4 = toSort.sorted(by: { $0.value > $1.value })
let s5 = toSort.sorted { $0.value > $1.value }

let areAllEqual = (s1.map{$0.value} == s2.map{$0.value} && s2.map{$0.value} == s3.map{$0.value} && s3.map{$0.value} == s4.map{$0.value} && s4.map{$0.value} == s5.map{$0.value})



// MARK: Level 3 · Temperature Stabilization

// 3.1
func heatUp(_ t: Int) -> Int { t + 5 }
func coolDown(_ t: Int) -> Int { t - 3 }
func hold(_ t: Int) -> Int { t }

func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < 18 { return heatUp }
    if temp > 24 { return coolDown }
    return hold
}

// 3.2
func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
    var currentTemp = start
    var stepCount = 0
    
    while (currentTemp < 18 || currentTemp > 24) && stepCount < maxSteps {
        let action = chooseProtocol(for: currentTemp)
        currentTemp = action(currentTemp)
        stepCount += 1
    }
    
    return (currentTemp, stepCount, currentTemp >= 18 && currentTemp <= 24)
}

let tempReadings = select(parsedData.valid) { $0.sensor == "TEMP" }
let tempValuesList = values(of: tempReadings)
let lowestTemp = stats(of: tempValuesList)?.min ?? 0

let C = runUntilStable(from: lowestTemp).steps


// MARK: Level 4 · The Crew

// 4.1
func oxygenLevel(of member: CrewMember) -> Int? {
    return member.module?.oxygenTank?.level
}

// 4.2
func status(of member: CrewMember) -> String {
    let location = member.module?.name ?? "open space"
    
    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no data (\(location))"
    }
    
    return level < 20 ? "\(member.name): \(level)% CRITICAL" : "\(member.name): \(level)% OK"
}

// Вывод статуса экипажа
for member in crew {
    print(status(of: member))
}

// 4.3
@discardableResult
func transferOxygen(from source: inout Int, to target: inout Int, amount: Int) -> Int {
    guard amount > 0 else { return 0 }
    
    let actualAmount = min(amount, source, 100 - target)
    source -= actualAmount
    target += actualAmount
    
    return actualAmount
}

if let labTank = lab.oxygenTank, let habTank = hab.oxygenTank {
    transferOxygen(from: &labTank.level, to: &habTank.level, amount: 30)
}

let D = hab.oxygenTank?.level ?? 0

// 4.4
func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {
    var foundMembers = [CrewMember]()
    
    for name in names {
        guard let member = roster[name] else {
            print("Unknown crew member: \(name)")
            continue
        }
        foundMembers.append(member)
    }
    
    let sorted = foundMembers.sorted { $0.priority < $1.priority }
    
    var resultNames = [String]()
    for m in sorted {
        resultNames.append(m.name)
    }
    return resultNames
}


// MARK: Level 5 · The Saboteur's Logbook


func reportOxygen(for member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no data"
    }
    return "\(member.name): \(level)%"
}

func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        if let level = oxygenLevel(of: member), level < 20 {
            return member.name
        }
    }
    return nil
}

// Test to prove the bug is gone
let testTank1 = Tank(level: 10)
let testTank2 = Tank(level: 5)
let testCrew = [
    CrewMember(name: "Test1", role: "", priority: 1, module: Module(name: "1", oxygenTank: testTank1)),
    CrewMember(name: "Test2", role: "", priority: 2, module: Module(name: "2", oxygenTank: testTank2))
]
let fixTest = firstCritical(in: testCrew)


// MARK: Finale · Launch Code

let launchCode = "\(A)-\(B)-\(C)-\(D)"
print("\nLAUNCH CODE: \(launchCode)")


// MARK: Bonus

func makeAlarm(threshold: Int) -> (Int) -> Bool {
    var count = 0
    return { currentLevel in
        if currentLevel < threshold {
            count += 1
            print("Alarm #\(count)")
            return true
        }
        return false
    }
}


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. guard let vs if let beyond syntax:
 guard let keep variable outside for use later. if let only work inside {}. if we do if let many times code go too much right side like pyramid and hard to read.

 2. Why can't you pass [Int] to stats(_ values: Int...)?
 because ... take normal numbers and make array inside function itself. if we put array it think it is wrong type.

 3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5) compile?
 swift have rule exclusive access to memory. cannot change same x from two places same time, it make memory error.

 4. Why doesn't oxygenLevel(of: dana) ?? "no data" compile?
 left side is Int? but right side is String. ?? need same type both sides.

 5. Full type of chooseProtocol and how to read it:
 (Int) -> ((Int) -> Int). it take Int and return one more function. that second function take Int and return Int too.

 Bonus. Where does the alarm counter live after makeAlarm returns?
 it live in heap because closure capture it. so count not deleted when function finish.
*/