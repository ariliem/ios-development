// =============================================================
//  Station ALMA-7, Part III: The Repair Fleet
//  iOS Mobile Development · Module 5 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part3_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section. LegacyBeacon in
//     particular must be reached with an extension, not edited.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • The Health Rule must exist in exactly ONE place in this file.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Drone records recovered from the fleet registry.
/// One `kind` does not correspond to any drone type you will build.
let fleetData: [(kind: String, id: String, charge: Int)] = [
    (kind: "welder",  id: "W-1", charge: 80),
    (kind: "scanner", id: "S-1", charge: 45),
    (kind: "cargo",   id: "C-1", charge: 100),
    (kind: "welder",  id: "W-2", charge: 15),
    (kind: "scanner", id: "S-2", charge: 60),
    (kind: "tug",     id: "T-1", charge: 50)
]

/// Hull sensors. These are NOT drones — they never move and never work a shift.
let sensorData: [(id: String, charge: Int)] = [
    (id: "hull-cam", charge: 12),
    (id: "thermal",  charge: 77)
]

/// Hardware from the original station. You may not add anything to this
/// declaration — no methods, no protocols, no properties.
struct LegacyBeacon {
    let name: String
    let signalStrength: Int
}

let beacon = LegacyBeacon(name: "ALMA-BEACON", signalStrength: 8)

print("Fleet registry online: \(fleetData.count) drone records, \(sensorData.count) sensors, beacon \(beacon.name).")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================

// MARK: Level 1 · The Power Cell

// Why a class and not a struct here?  ->
// PowerCell represents shared mutable hardware: multiple systems need to drain and inspect the exact same battery instance via reference semantics rather than independent copies.
final class PowerCell {
    private var charge: Int

    init(charge: Int) {
        if charge < 0 {
            self.charge = 0
        } else if charge > 100 {
            self.charge = 100
        } else {
            self.charge = charge
        }
    }

    func level() -> Int {
        return charge
    }

    func spend(amount: Int) -> Bool {
        guard amount > 0, charge >= amount else {
            return false
        }
        charge -= amount
        return true
    }

    func recharge(by amount: Int) {
        guard amount > 0 else { return }
        charge += amount
        if charge > 100 {
            charge = 100
        }
    }
}

// Encapsulation proof (leave this commented, with the compiler error):
// let testCell = PowerCell(charge: 50)
// testCell.charge = 100
// error: 'charge' is inaccessible due to 'private' protection level


// MARK: Level 2 · The Fleet

// 2.1  What does `final` on runOnce() buy you?  ->
// It locks down the shift execution template so subclasses can never override runOnce() to bypass battery cost or mess up the order of operations.
class Drone {
    let id: String
    let cell: PowerCell

    init(id: String, cell: PowerCell) {
        self.id = id
        self.cell = cell
    }

    var powerCost: Int {
        return 10
    }

    var statusLine: String {
        return "\(id): [\(cell.level().powerBar)] \(cell.level())%"
    }

    func performTask() -> Int {
        return 0
    }

    final func runOnce() -> Int {
        if cell.spend(amount: powerCost) {
            return performTask()
        }
        return 0
    }
}

// 2.2 Subclasses
final class WelderDrone: Drone {
    override var powerCost: Int {
        return 25
    }

    override func performTask() -> Int {
        return 40
    }

    func weldSeam() -> String {
        return "Seam welded securely by \(id)."
    }
}

class ScannerDrone: Drone {
    override var powerCost: Int {
        return 10
    }

    override func performTask() -> Int {
        return 15
    }

    override var statusLine: String {
        return super.statusLine + " [scanner]"
    }
}

final class CargoDrone: Drone {
    override var powerCost: Int {
        return 20
    }

    override func performTask() -> Int {
        return 25
    }
}

// 2.3 Factory
func makeDrone(kind: String, id: String, charge: Int) -> Drone? {
    let cell = PowerCell(charge: charge)
    if kind == "welder" {
        return WelderDrone(id: id, cell: cell)
    } else if kind == "scanner" {
        return ScannerDrone(id: id, cell: cell)
    } else if kind == "cargo" {
        return CargoDrone(id: id, cell: cell)
    } else {
        print("Warning: Unknown drone kind '\(kind)' for ID \(id). Skipping record.")
        return nil
    }
}

var fleet: [Drone] = []
for record in fleetData {
    if let drone = makeDrone(kind: record.kind, id: record.id, charge: record.charge) {
        fleet.append(drone)
    }
}


// MARK: Level 3 · The Shift

func runShift(_ fleet: [Drone], rounds: Int) -> Int {
    var totalWork = 0
    for _ in 0..<rounds {
        for drone in fleet {
            totalWork += drone.runOnce()
        }
    }
    return totalWork
}

let A = runShift(fleet, rounds: 3)

var remainingChargeSum = 0
var readyForNextTaskCount = 0

print("\n--- Drone Fleet Status After Shift ---")
for drone in fleet {
    print(drone.statusLine)
    let currentCharge = drone.cell.level()
    remainingChargeSum += currentCharge
    if currentCharge >= drone.powerCost {
        readyForNextTaskCount += 1
    }
}

let B = remainingChargeSum
let C = readyForNextTaskCount

print("Shift work completed (A): \(A)")
print("Total remaining charge (B): \(B)")
print("Drones ready for another task (C): \(C)")


// MARK: Level 4 · Diagnostics

// 4.1
protocol Diagnosable {
    var componentID: String { get }
    var statusCode: Int { get }
    func diagnose() -> String
}

// 4.2
protocol Rechargeable {
    mutating func recharge(by amount: Int)
}

// Why does Drone implement recharge(by:) without `mutating`?  ->
// Drone is a reference type (class). Modifying properties updates heap memory rather than mutating the variable holding the pointer, so classes never need mutating.
extension Drone: Diagnosable, Rechargeable {
    var componentID: String {
        return id
    }

    var statusCode: Int {
        return Diagnosable.evaluateHealth(for: cell.level())
    }

    func recharge(by amount: Int) {
        cell.recharge(by: amount)
    }
}

struct SensorModule: Diagnosable, Rechargeable {
    let id: String
    var chargeLevel: Int

    var componentID: String {
        return id
    }

    var statusCode: Int {
        return Diagnosable.evaluateHealth(for: chargeLevel)
    }

    mutating func recharge(by amount: Int) {
        guard amount > 0 else { return }
        chargeLevel += amount
        if chargeLevel > 100 {
            chargeLevel = 100
        }
    }
}

var sensorModules: [SensorModule] = []
for record in sensorData {
    sensorModules.append(SensorModule(id: record.id, chargeLevel: record.charge))
}

// 4.3 Diagnostics screen
// Why could [Drone] never have held the sensors?  ->
// Swift arrays are strictly typed, and SensorModule is an independent struct with no inheritance relationship to Drone; only an existential protocol array like [Diagnosable] can group both.
func diagnosticsReport(_ components: [Diagnosable]) -> String {
    var report = "=== STATION DIAGNOSTICS REPORT ===\n"
    for item in components {
        report += "\(item.diagnose())\n"
    }
    return report
}


// MARK: Level 5 · Shared Behaviour

// 5.1 · default diagnose() + the single home of the Health Rule
extension Diagnosable {
    func diagnose() -> String {
        return "\(componentID): code \(statusCode)"
    }

    // THE HEALTH RULE (Lives in exactly ONE place in the entire file)
    static func evaluateHealth(for value: Int) -> Int {
        if value < 20 {
            return 2 // critical
        } else if value < 50 {
            return 1 // warning
        } else {
            return 0 // nominal
        }
    }
}

// 5.2 · the beacon you cannot edit
extension LegacyBeacon: Diagnosable {
    var componentID: String {
        return name
    }

    var statusCode: Int {
        return Diagnosable.evaluateHealth(for: signalStrength)
    }

    func diagnose() -> String {
        return "[LEGACY HARDWARE] \(componentID): code \(statusCode) (Signal: \(signalStrength))"
    }
}

// Build all components array
var allComponents: [Diagnosable] = []
for drone in fleet {
    allComponents.append(drone)
}
for sensor in sensorModules {
    allComponents.append(sensor)
}
allComponents.append(beacon)

print("\n" + diagnosticsReport(allComponents))

var totalStatusCodes = 0
for comp in allComponents {
    totalStatusCodes += comp.statusCode
}
let D = totalStatusCodes


// 5.3 Extension on Int
extension Int {
    var powerBar: String {
        var blocks = self / 10
        if blocks < 0 { blocks = 0 }
        if blocks > 10 { blocks = 10 }
        var result = ""
        for i in 0..<10 {
            if i < blocks {
                result += "#"
            } else {
                result += "."
            }
        }
        return result
    }
}


// MARK: Level 6 · Incident Reports
// Two of these do not compile. Two compile and lie.
// For each: expectation, actual behaviour, the language rule, the fix.

/*
// ==================== Report 1 ====================
// Broken code:
class PatchDrone: Drone {
    func performTask() -> Int {
        return 30
    }
}

- Author's expectation: Subclass Drone and override performTask() to yield 30 work units.
- What actually happens: Fails to compile ("Overriding declaration requires 'override' keyword").
- Language rule: Swift strictly requires the `override` keyword when replacing a superclass method to prevent accidental name collisions.
- The fix:
class PatchDroneFixed: Drone {
    override func performTask() -> Int {
        return 30
    }
}


// ==================== Report 2 ====================
// Broken code:
final class HeavyWelder: WelderDrone {
    override func runOnce() -> Int {
        return 999
    }
}

- Author's expectation: Subclass WelderDrone and override runOnce() to return 999 work units.
- What actually happens: Fails to compile with two errors: WelderDrone is a final class (cannot be inherited), and runOnce() is a final method (cannot be overridden).
- Language rule: The `final` keyword forbids subclassing when applied to classes and prohibits overriding when applied to methods.
- The fix: Inherit directly from Drone and override performTask(), preserving the final runOnce() ritual:
final class HeavyWelderFixed: Drone {
    override var powerCost: Int { 50 }
    override func performTask() -> Int { 999 }
}


// ==================== Report 3 ====================
// Broken code:
let reportFleet: [Drone] = [WelderDrone(id: "W-9", cell: PowerCell(charge: 100))]
let first = reportFleet[0]
print(first.weldSeam())

- Author's expectation: Call weldSeam() directly on the first element in reportFleet.
- What actually happens: Fails to compile ("Value of type 'Drone' has no member 'weldSeam'").
- Language rule: The static type of the array elements is Drone, which has no weldSeam() declaration. Accessing subclass-specific members requires a conditional downcast (`as?`). `as?` returns an optional because runtime type casting might fail, returning nil safely without crashing.
- The fix:
if let welder = first as? WelderDrone {
    print(welder.weldSeam())
}


// ==================== Report 4 ====================
// Broken code:
protocol Labelled {
    var componentID: String { get }
}

extension Labelled {
    func label() -> String { "generic component" }
}

struct Thruster: Labelled {
    let componentID: String
    func label() -> String { "thruster \(componentID)" }
}

let parts: [Labelled] = [Thruster(componentID: "T-1")]
print(parts[0].label())

- Author's expectation: The program prints "thruster T-1".
- What actually happens: Compiles fine, but prints "generic component".
- Language rule: Static vs dynamic method dispatch in protocol extensions. Because `label()` was only declared in the extension and not inside `protocol Labelled`, it is not a protocol requirement. When called on a value typed as the protocol `Labelled`, Swift statically dispatches to the extension's default implementation, completely ignoring the struct's own method.
- The fix: Declare `func label() -> String` inside `protocol Labelled` so it becomes a requirement and uses dynamic dispatch.
*/


// MARK: Finale · Mission Code

let missionCode = "\(A)-\(B)-\(C)-\(D)"
print("MISSION CODE: \(missionCode)")


// MARK: Bonus

// 1. Two ways to forbid instantiating Drone directly:
// - Compile-time approach: Mark Drone's initializer as `fileprivate init` or `internal init` while keeping the class public, so external callers cannot instantiate base instances directly.
// - Runtime approach: Inside Drone's `performTask()`, throw a `fatalError("Drone is an abstract base class. Subclasses must override performTask().")`.

// 2. Protocol-based redesign:
protocol DroneEntity {
    var id: String { get }
    var cell: PowerCell { get }
    var powerCost: Int { get }
    func performTask() -> Int
}

extension DroneEntity {
    func runOnce() -> Int {
        if cell.spend(amount: powerCost) {
            return performTask()
        }
        return 0
    }
}

struct StructWelderDrone: DroneEntity {
    let id: String
    let cell: PowerCell
    var powerCost: Int { 25 }
    func performTask() -> Int { 40 }
}

// 3. Comparison:
// A protocol-oriented approach provides great modularity and allows using lightweight structs without rigid class hierarchies. However, if drones need reference identity or must share mutable internal state across multiple systems, the class-based design remains cleaner and more practical.


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why does a class satisfy a `mutating` protocol requirement without the
    keyword, while a struct must write it?
    Structs are value types; modifying a stored property changes the entire instance
    in memory, so Swift requires `mutating` to acknowledge that `self` will be re-assigned.
    Classes are reference types; changing an internal property mutates the object living
    on the heap while the pointer itself stays constant. Because `self` never changes its
    reference, class methods never need `mutating`.

 2. One thing inheritance does that protocols cannot, and one thing
    protocols do that inheritance cannot:
    - Inheritance allows sharing stored properties and calling `super` to reuse base behavior.
    - Protocols allow retrofitting and grouping completely unrelated types (structs, classes,
      and untouchable external legacy types) under a single polymorphic contract.

 3. What does `final` prevent, and what did it protect in runOnce()?
    The `final` keyword prevents subclasses from overriding methods or inheriting from classes.
    In `runOnce()`, it protected the core execution template: ensuring energy is always deducted
    before work is performed, so no subclass could ever cheat the battery system.

 4. In Report 4, why did the protocol extension's method win?
    Because `label()` was only declared in the protocol extension, not inside the protocol definition
    itself, making it a non-requirement. When accessed through a variable typed as `Labelled`,
    Swift resolved the call using static dispatch, picking the extension's default implementation
    over the struct's implementation.
*/
