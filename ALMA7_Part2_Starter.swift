// =============================================================
//  Station ALMA-7, Part II: The Teleporter Incident
//  iOS Mobile Development · Module 4 · Lab Assignment
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Splits a line into fields.
/// fields("crate:101:120")            -> ["crate", "101", "120"]
/// fields("livestock:lab mice:12:2")  -> ["livestock", "lab mice", "12", "2"]
/// fields("junk")                     -> ["junk"]
func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

/// Cargo manifest as recovered from the damaged recorder.
let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

/// Oxygen readings. One of these deck names is not a real deck.
let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

/// Crew records, straight from the personnel file.
let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")


// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · The Deck Register

// 1.1
enum Deck: String, CaseIterable {
    case bridge
    case lab
    case cargo
    case medbay
    case engine
    
    var evacuationPriority: Int {
        switch self {
        case .bridge:
            return 1
        case .medbay:
            return 2
        case .lab:
            return 3
        case .engine:
            return 4
        case .cargo:
            return 5
        }
    }
}

print("----- LEVEL 1.1 -----")

for deck in Deck.allCases {
    print("Deck: \(deck.rawValue), priority: \(deck.evacuationPriority)")
}


// 1.2
enum AlarmLevel: Int {
    case green = 0
    case yellow
    case orange
    case red
    
    static func level(forTotalMass mass: Int) -> AlarmLevel {
        let step = min(max(mass / 500, 0), 3)
        
        if let level = AlarmLevel(rawValue: step) {
            return level
        }
        
        return .red
    }
}

print("----- LEVEL 1.2 -----")
print("0 kg -> \(AlarmLevel.level(forTotalMass: 0))")
print("940 kg -> \(AlarmLevel.level(forTotalMass: 940))")
print("4000 kg -> \(AlarmLevel.level(forTotalMass: 4000))")


// MARK: Level 2 · The Manifest

// 2.1
enum ManifestEntry {
    case crate(id: Int, massKg: Int)
    case container(code: String, massKg: Int)
    case livestock(species: String, count: Int, massPerUnitKg: Int)
    case unknown(raw: String)
}


// 2.2
func parseEntry(_ line: String) -> ManifestEntry {
    let parts = fields(line)
    
    guard let tag = parts.first else {
        return .unknown(raw: line)
    }
    
    switch tag {
    case "crate":
        guard parts.count == 3,
              let id = Int(parts[1]),
              let massKg = Int(parts[2]) else {
            return .unknown(raw: line)
        }
        
        return .crate(id: id, massKg: massKg)
        
    case "container":
        guard parts.count == 3,
              let massKg = Int(parts[2]) else {
            return .unknown(raw: line)
        }
        
        return .container(
            code: parts[1],
            massKg: massKg
        )
        
    case "livestock":
        guard parts.count == 4,
              let count = Int(parts[2]),
              let massPerUnitKg = Int(parts[3]) else {
            return .unknown(raw: line)
        }
        
        return .livestock(
            species: parts[1],
            count: count,
            massPerUnitKg: massPerUnitKg
        )
        
    default:
        return .unknown(raw: line)
    }
}


// 2.3
func mass(of entry: ManifestEntry) -> Int {
    switch entry {
    case let .crate(_, massKg):
        return massKg
        
    case let .container(_, massKg):
        return massKg
        
    case let .livestock(_, count, massPerUnitKg):
        return count * massPerUnitKg
        
    case .unknown:
        return 0
    }
}

print("----- LEVEL 2 -----")

let exampleEntry1 = parseEntry("crate:101:120")
let exampleEntry2 = parseEntry("livestock:lab mice:12:2")

print("Example entry 1: \(exampleEntry1)")
print("Example entry 2: \(exampleEntry2)")

var totalManifestMass = 0
var unknownCount = 0

for line in rawManifest {
    let entry = parseEntry(line)
    
    totalManifestMass += mass(of: entry)
    
    switch entry {
    case .unknown:
        unknownCount += 1
    default:
        break
    }
}

let A = totalManifestMass

print("Total manifest mass A: \(A) kg")
print("Unknown lines: \(unknownCount)")


// MARK: Level 3 · Crew Snapshots

// 3.1
struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int
    
    mutating func breathe(_ amount: Int) {
        oxygen = max(0, oxygen - amount)
    }
    
    mutating func move(to deck: Deck) {
        self.deck = deck
    }
    
    mutating func reviveInMedbay() {
        self = CrewSnapshot(
            name: name,
            deck: .medbay,
            oxygen: 100
        )
    }
    
    static func rookie(named name: String) -> CrewSnapshot {
        return CrewSnapshot(
            name: name,
            deck: .bridge,
            oxygen: 100
        )
    }
}


// 3.2
let crewRoster: [CrewSnapshot] = {
    var result: [CrewSnapshot] = []
    
    for record in crewData {
        if let deck = Deck(rawValue: record.deck) {
            let snapshot = CrewSnapshot(
                name: record.name,
                deck: deck,
                oxygen: record.oxygen
            )
            
            result.append(snapshot)
        } else {
            print(
                "Warning: skipped \(record.name), " +
                "unknown deck: \(record.deck)"
            )
        }
    }
    
    return result
}()

print("----- LEVEL 3 -----")
print("Crew roster count: \(crewRoster.count)")
print(
    "First crew member: \(crewRoster[0].name), " +
    "oxygen: \(crewRoster[0].oxygen)"
)


// 3.3 — Value semantics

var copiedSnapshot = crewRoster[0]

print(
    "Copy BEFORE: original oxygen = \(crewRoster[0].oxygen), " +
    "copy oxygen = \(copiedSnapshot.oxygen)"
)

copiedSnapshot.breathe(10)

print(
    "Copy AFTER: original oxygen = \(crewRoster[0].oxygen), " +
    "copy oxygen = \(copiedSnapshot.oxygen)"
)


// Plain parameter
func changeOxygen(_ snapshot: CrewSnapshot) -> CrewSnapshot {
    var changedSnapshot = snapshot
    changedSnapshot.breathe(10)
    return changedSnapshot
}

print(
    "Plain parameter BEFORE: " +
    "original oxygen = \(crewRoster[0].oxygen)"
)

let changedSnapshot = changeOxygen(crewRoster[0])

print(
    "Plain parameter AFTER: " +
    "original oxygen = \(crewRoster[0].oxygen), " +
    "returned oxygen = \(changedSnapshot.oxygen)"
)


// inout parameter
func changeOxygenInPlace(_ snapshot: inout CrewSnapshot) {
    snapshot.breathe(10)
}

var inoutSnapshot = crewRoster[0]

print(
    "inout BEFORE: oxygen = \(inoutSnapshot.oxygen)"
)

changeOxygenInPlace(&inoutSnapshot)

print(
    "inout AFTER: oxygen = \(inoutSnapshot.oxygen)"
)


// Additional struct demonstration
var rookie = CrewSnapshot.rookie(named: "Test Rookie")

print(
    "Rookie before revive: " +
    "\(rookie.name), \(rookie.deck.rawValue), \(rookie.oxygen)"
)

rookie.reviveInMedbay()

print(
    "Rookie after revive: " +
    "\(rookie.name), \(rookie.deck.rawValue), \(rookie.oxygen)"
)


// MARK: Level 4 · The Teleport Pod

// 4.1
final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?
    
    // Struct gets a memberwise initializer automatically.
    // This class needs an initializer written manually.
    init(id: String, chargeLevel: Int) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = nil
    }
    
    func load(_ crew: CrewSnapshot) -> Bool {
        guard occupant == nil, chargeLevel >= 20 else {
            return false
        }
        
        occupant = crew
        return true
    }
    
    func fire() -> CrewSnapshot? {
        guard let currentOccupant = occupant else {
            return nil
        }
        
        occupant = nil
        chargeLevel -= 20
        
        return currentOccupant
    }
}


// 4.2
print("----- LEVEL 4 -----")

let Cpod = TeleportPod(
    id: "P-1",
    chargeLevel: 100
)

print("Initial charge: \(Cpod.chargeLevel)")

print("Load Timur: \(Cpod.load(crewRoster[0]))")
_ = Cpod.fire()
print("After Timur: \(Cpod.chargeLevel)")

print("Load Dana: \(Cpod.load(crewRoster[1]))")
_ = Cpod.fire()
print("After Dana: \(Cpod.chargeLevel)")

print("Load Nurlan: \(Cpod.load(crewRoster[3]))")
_ = Cpod.fire()
print("After Nurlan: \(Cpod.chargeLevel)")

_ = Cpod.fire()
print("After empty fire: \(Cpod.chargeLevel)")

let C = Cpod.chargeLevel


// 4.3 — Reference semantics

let podCopy = Cpod

podCopy.chargeLevel = 10

print(
    "Class reference 1: Cpod charge = \(Cpod.chargeLevel)"
)

print(
    "Class reference 2: podCopy charge = \(podCopy.chargeLevel)"
)


var structCopy1 = crewRoster[0]
var structCopy2 = structCopy1

structCopy2.oxygen = 1

print(
    "Struct copy 1: oxygen = \(structCopy1.oxygen)"
)

print(
    "Struct copy 2: oxygen = \(structCopy2.oxygen)"
)

// Rule:
// Classes use reference semantics, while structs use value semantics.


// MARK: Level 5 · Station Systems

// 5.1
final class Station {
    
    // Stored constant property
    let callSign: String
    
    // Stored variable property with observers
    var hullIntegrity: Int {
        willSet {
            print(
                "Hull transition: " +
                "\(hullIntegrity) -> \(newValue)"
            )
        }
        
        didSet {
            hullIntegrity = min(
                max(hullIntegrity, 0),
                100
            )
        }
    }
    
    // Stored property containing oxygen readings
    var oxygenByDeck: [Deck: Int]
    
    // Lazy stored property
    lazy var fullDiagnostics: String = {
        print("Running full scan...")
        
        return """
        Diagnostics for \(callSign):
        total oxygen = \(totalOxygen)
        hull integrity = \(hullIntegrity)
        """
    }()
    
    // Computed read-only property
    var totalOxygen: Int {
        var total = 0
        
        for oxygen in oxygenByDeck.values {
            total += oxygen
        }
        
        return total
    }
    
    // Computed property with get and set
    var averageOxygen: Int {
        get {
            guard !oxygenByDeck.isEmpty else {
                return 0
            }
            
            return totalOxygen / oxygenByDeck.count
        }
        
        set {
            for deck in oxygenByDeck.keys {
                oxygenByDeck[deck] = newValue
            }
        }
    }
    
    init(
        callSign: String,
        hullIntegrity: Int,
        readings: [(deck: String, oxygen: Int)]
    ) {
        self.callSign = callSign
        self.hullIntegrity = hullIntegrity
        
        var validReadings: [Deck: Int] = [:]
        
        for reading in readings {
            if let deck = Deck(rawValue: reading.deck) {
                validReadings[deck] = reading.oxygen
            } else {
                print(
                    "Warning: ignored oxygen reading for " +
                    "unknown deck \(reading.deck)"
                )
            }
        }
        
        self.oxygenByDeck = validReadings
    }
}


print("----- LEVEL 5 -----")

let station = Station(
    callSign: "ALMA-7",
    hullIntegrity: 100,
    readings: deckReadings
)

// B must be calculated before changing anything.
let B = station.averageOxygen

print("Station call sign: \(station.callSign)")
print("Starting average oxygen B: \(B)")

print("Total oxygen: \(station.totalOxygen)")
print("Average oxygen: \(station.averageOxygen)")


// Lazy property demonstration
print("First diagnostics access:")
print(station.fullDiagnostics)

print("Second diagnostics access:")
print(station.fullDiagnostics)


// This station is created but fullDiagnostics is never accessed.
let untouchedStation = Station(
    callSign: "ALMA-8",
    hullIntegrity: 100,
    readings: deckReadings
)

print(
    "Another station was created without accessing diagnostics."
)


// 5.2 — Clamp trap

station.hullIntegrity = 130
print("Hull after 130: \(station.hullIntegrity)")

station.hullIntegrity = -40
print("Hull after -40: \(station.hullIntegrity)")

station.hullIntegrity = 55
print("Hull after 55: \(station.hullIntegrity)")


// Test averageOxygen setter
station.averageOxygen = 60

print(
    "Average oxygen after setter: " +
    "\(station.averageOxygen)"
)

print(
    "Total oxygen after setter: " +
    "\(station.totalOxygen)"
)

// didSet does not recursively call itself when it assigns
// directly to the same property inside its own observer.


// MARK: Level 6 · Incident Reports

print("----- LEVEL 6 -----")


// Report 1
print("Incident Report 1")

var rosterReport1 = crewRoster

print(
    "Before: rosterReport1[0].oxygen = " +
    "\(rosterReport1[0].oxygen)"
)

for index in rosterReport1.indices {
    rosterReport1[index].oxygen -= 10
}

print(
    "After: rosterReport1[0].oxygen = " +
    "\(rosterReport1[0].oxygen)"
)

print(
    "Original crewRoster[0].oxygen = " +
    "\(crewRoster[0].oxygen)"
)

/*
Explanation:

Original code:

for var member in roster {
    member.oxygen -= 10
}

does not change the array because member is a local copy
of the struct element.

Rule: CrewSnapshot is a value type.

Fix:
Change the array element directly using its index.
*/


// Report 2
print("Incident Report 2")

let podA = TeleportPod(
    id: "A",
    chargeLevel: 100
)

let podB = podA

print(
    "Before: podA = \(podA.chargeLevel), " +
    "podB = \(podB.chargeLevel)"
)

podB.chargeLevel = 0

print(
    "After: podA = \(podA.chargeLevel), " +
    "podB = \(podB.chargeLevel)"
)

/*
Explanation:

podA and podB point to the same class instance.

Therefore changing podB also changes what podA sees.

Rule: classes use reference semantics.

Fix:
Create two separate TeleportPod objects if independent
objects are required.
*/


// Report 3
print("Incident Report 3")

struct Logbook {
    var entries: [String] = []
    
    mutating func add(_ entry: String) {
        entries.append(entry)
    }
}

var logbook = Logbook()

print("Logbook before: \(logbook.entries.count) entries")

logbook.add("Teleporter checked")

print(
    "Logbook after: \(logbook.entries.count) entries"
)

print(
    "First entry: \(logbook.entries[0])"
)

/*
Original code does not compile because a struct method that
changes stored properties must be marked mutating.

Fix:
mutating func add(...)
*/


// Report 4
print("Incident Report 4")

var snapshotReport4 = CrewSnapshot.rookie(
    named: "Dana"
)

print(
    "Struct before: oxygen = " +
    "\(snapshotReport4.oxygen)"
)

snapshotReport4.oxygen = 40

print(
    "Struct after: oxygen = " +
    "\(snapshotReport4.oxygen)"
)


let podReport4 = TeleportPod(
    id: "B",
    chargeLevel: 50
)

print(
    "Class before: charge = " +
    "\(podReport4.chargeLevel)"
)

podReport4.chargeLevel = 10

print(
    "Class after: charge = " +
    "\(podReport4.chargeLevel)"
)

/*
Explanation:

For a struct:

let snapshot = CrewSnapshot(...)

freezes the whole value. Therefore its var properties
cannot be changed.

For a class:

let pod = TeleportPod(...)

freezes the reference itself, but not the object.

Therefore pod.chargeLevel can still change because
chargeLevel is var.
*/


// MARK: Level 7 · Sealing the Black Box

final class FlightRecorder {
    
    // private: outside code cannot replace or clear the entries.
    private var entries: [String] = []
    
    // private(set): outside code can read isSealed,
    // but cannot change it.
    private(set) var isSealed: Bool = false
    
    
    var entryCount: Int {
        return entries.count
    }
    
    
    var transcript: String {
        return entries.joined(separator: "\n")
    }
    
    
    func addEntry(_ entry: String) {
        guard !isSealed else {
            return
        }
        
        entries.append(entry)
    }
    
    
    func seal() {
        isSealed = true
    }
    
    
    // fileprivate: this helper can be used by another function
    // in the same source file.
    fileprivate func auditLines() -> [String] {
        return entries
    }
}


// Free function elsewhere in the file
func auditTranscript(
    of recorder: FlightRecorder
) -> String {
    
    return recorder
        .auditLines()
        .joined(separator: " | ")
}


print("----- LEVEL 7 -----")

let recorder = FlightRecorder()

recorder.addEntry("Teleport test passed")
recorder.addEntry("Oxygen logs verified")

print(
    "Recorder entry count: \(recorder.entryCount)"
)

print(
    "Recorder transcript:"
)

print(recorder.transcript)


recorder.seal()

recorder.addEntry(
    "This entry must NOT be added"
)

print(
    "Recorder sealed: \(recorder.isSealed)"
)

print(
    "Audit transcript: " +
    "\(auditTranscript(of: recorder))"
)


// Failed attempts from outside the class:
//
// recorder.entries.removeAll()
// Error: 'entries' is inaccessible due to 'private' protection level
//
// recorder.isSealed = false
// Error: cannot assign to property: 'isSealed' setter is inaccessible


// MARK: Finale · Integrity Code

let D = AlarmLevel
    .level(forTotalMass: A)
    .rawValue

let integrityCode = "\(A)-\(B)-\(C)-\(D)"

print("----- FINALE -----")
print("INTEGRITY CODE: \(integrityCode)")


// MARK: Defense Questions

/*
1. Why did CrewSnapshot get an initializer for free while
   TeleportPod did not?

CrewSnapshot is a struct with stored properties, so Swift
automatically provides a memberwise initializer.

TeleportPod is a class, and this assignment requires us to
create its initializer manually.


2. What does mutating actually do to self, and why do classes
   never need it?

mutating allows a struct method to change self or its stored
properties.

Classes do not need mutating because they are reference types.
A class method can directly change var properties of the object.


3. In Report 4, both values are declared with let.
   What exactly does let freeze?

For a struct, let makes the whole value immutable.

For a class, let makes the reference constant, but the object
itself can still change its var properties.


4. Why must a lazy property be var?

A lazy property gets its value later, when it is first accessed.
Because Swift has to store that value after initialization,
it must be var.

Example:

lazy var fullDiagnostics: String = {
    print("Running full scan...")
    return "Diagnostics"
}()

The scan happens only when fullDiagnostics is accessed.


5. private vs fileprivate

private is used when only the type itself should access the
property.

fileprivate is useful when another function in the SAME source
file needs access.

In FlightRecorder, entries stays private, while auditLines()
is fileprivate so auditTranscript(of:) can use it.
*/


// MARK: Bonus

/*
BONUS

The following demonstrates deinit, reference counting and ===.
*/


final class BonusTeleportPod {
    let id: String
    
    init(id: String) {
        self.id = id
        print("Bonus pod \(id) initialized")
    }
    
    deinit {
        print("Bonus pod \(id) deinitialized")
    }
}


// Identity comparison function
func samePod(
    _ first: BonusTeleportPod,
    _ second: BonusTeleportPod
) -> Bool {
    return first === second
}


print("----- BONUS -----")

var firstPod: BonusTeleportPod? =
    BonusTeleportPod(id: "BONUS-1")

var secondPod = firstPod

if let first = firstPod,
   let second = secondPod {
    
    print(
        "Same pod identity: " +
        "\(samePod(first, second))"
    )
}

print("Before clearing references")

firstPod = nil

print(
    "After clearing first reference, " +
    "second reference still exists"
)

secondPod = nil

print(
    "After clearing second reference"
)


do {
    let temporaryPod = BonusTeleportPod(
        id: "BONUS-2"
    )
    
    let secondReference = temporaryPod
    
    print("Inside do-block")
    print(
        "Same identity inside block: " +
        "\(samePod(temporaryPod, secondReference))"
    )
    
    // deinit cannot run here because secondReference
    // still keeps the object alive.
}

print("After do-block")

/*
The BONUS-2 object is released after the do-block because
both references go out of scope.

The deinit message appears when the last strong reference
disappears.

=== can be used only with class instances because it checks
whether two references point to the exact same object.

CrewSnapshot is a struct, so it is a value type and does not
have object identity. Therefore === cannot be used with it.
*/