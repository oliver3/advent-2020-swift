//let batch = """
//ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
//byr:1937 iyr:2017 cid:147 hgt:183cm
//
//iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
//hcl:#cfa07d byr:1929
//
//hcl:#ae17e1 iyr:2013
//eyr:2024
//ecl:brn pid:760753108 byr:1931
//hgt:179cm
//
//hcl:#cfa07d eyr:2025 pid:166559648
//iyr:2011 ecl:brn hgt:59in
//"""

let batch = readFile("input.txt") ?? ""

let requiredFields = Set([
    "byr", // (Birth Year)
    "iyr", // (Issue Year)
    "eyr", // (Expiration Year)
    "hgt", // (Height)
    "hcl", // (Hair Color)
    "ecl", // (Eye Color)
    "pid", // (Passport ID)
    // "cid", // (Country ID)
])

let passports = batch
    .components(separatedBy: "\n\n")
    .map { $0.components(separatedBy: .whitespacesAndNewlines)}



func validYear(_ yr: String?, within: ClosedRange<Int>) -> Bool {
    if let year = Int(yr ?? ""), within.contains(year) {
        return true
    } else {
        return false
    }
}

assert(validYear("2002", within: 1920...2002))
assert(!validYear("2003", within: 1920...2002))


let heightRegex = RegExp(#"^(\d+)(in|cm)$"#)

func validHeight(_ hgt: String?, cm cmRange: ClosedRange<Int>, in inRange: ClosedRange<Int>) -> Bool {
    if let matches = heightRegex.exec(hgt), matches.count == 3, let val = Int(matches[1]) {
        switch matches[2] {
        case "cm":
            return cmRange.contains(val)
        case "in":
            return inRange.contains(val)
        default:
            print("Unknown unit", matches[2])
            return false
        }
    } else {
        return false
    }
}

assert(validHeight("60in", cm: 150...193, in: 59...76))
assert(validHeight("190cm", cm: 150...193, in: 59...76))
assert(!validHeight("190in", cm: 150...193, in: 59...76))
assert(!validHeight("190", cm: 150...193, in: 59...76))

let hairColorRegex = RegExp(#"^#[0-9a-f]{6}$"#)

func validHairColor(_ hcl: String?) -> Bool {
    return hairColorRegex.test(hcl)
}

assert(validHairColor("#123abc"))
assert(!validHairColor("#123abz"))
assert(!validHairColor("123abc"))

let eyeColors = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])

func validEyeColor(_ ecl: String?) -> Bool {
    return eyeColors.contains(ecl ?? "")
}

assert(validEyeColor("brn"))
assert(!validEyeColor("wat"))

let passportIdRegex = RegExp(#"^\d{9}$"#)

func validPassportID(_ pid: String?) -> Bool {
    return passportIdRegex.test(pid)
}

assert(validPassportID("000000001"))
assert(!validPassportID("0123456789"))


func isValidPassport(_ passport: [String]) -> Bool {
    let fields: [String: String] = Dictionary(uniqueKeysWithValues: passport.compactMap {
        let a = $0.components(separatedBy: ":")
        if a.count == 2 {
            return (a[0], a[1])
        } else {
            return nil
        }
    })
    
//    return requiredFields.isSubset(of: Set(fields.keys))

    let validationResults = [
        //byr (Birth Year) - four digits; at least 1920 and at most 2002.
        validYear(fields["byr"], within: 1920...2002),
        
        //iyr (Issue Year) - four digits; at least 2010 and at most 2020.
        validYear(fields["iyr"], within: 2010...2020),
        
        //eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
        validYear(fields["eyr"], within: 2020...2030),
        
        //hgt (Height) - a number followed by either cm or in:
        //    If cm, the number must be at least 150 and at most 193.
        //    If in, the number must be at least 59 and at most 76.
        validHeight(fields["hgt"], cm: 150...193, in: 59...76),

        //hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
        validHairColor(fields["hcl"]),

        //ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
        validEyeColor(fields["ecl"]),

        //pid (Passport ID) - a nine-digit number, including leading zeroes.
        validPassportID(fields["pid"]),

        //cid (Country ID) - ignored, missing or not.
    ]
    
    return validationResults.allSatisfy { $0 }

}

let assertTrue = """
pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
""".components(separatedBy: "\n\n").map { $0.components(separatedBy: .whitespacesAndNewlines)}

assertTrue.forEach {
    let valid = isValidPassport($0)
    assert(valid, $0.joined(separator: ";"))
}

//assert(assertTrue.map(isValidPassport).allSatisfy({ $0 }))

let assertFalse = """
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007
""".components(separatedBy: "\n\n").map { $0.components(separatedBy: .whitespacesAndNewlines)}


assertFalse.forEach {
    let valid = isValidPassport($0)
    assert(!valid, $0.joined(separator: ";"))
}

//assert(assertFalse.map(isValidPassport).allSatisfy({ !$0 }))


//let valid = passports.map(isValidPassport)
//let answer1 = valid.filter { $0 }.count
let answer1 = passports.filter(isValidPassport).count
print(answer1)

