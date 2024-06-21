import UIKit

let x = 6.005
let y = 6.005000001
let z = 6.004999999999999

print("Input")
print("x = \(x)")
print("y = \(y)")
print("z = \(z)")

print("\nOutput")
print("-------------------")

// Round to 2 decimal places
print("Rounded to 2 Decimal Places")
print(String(format: "%.2f", x))
print(String(format: "%.2f", y))
print(String(format: "%.2f", z))

print("-------------------")

// Round to 3 decimal places
print("Rounded to 3 Decimal Places")
print(String(format: "%.3f", x))
print(String(format: "%.3f", y))
print(String(format: "%.3f", z))

print("-------------------")
