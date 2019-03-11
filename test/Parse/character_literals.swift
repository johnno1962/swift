// RUN: %target-typecheck-verify-swift -swift-version 5

import Foundation

let c = CChar(ascii: "d")
let d = [UInt16](ascii: "def")

if d[0] == "d" {
  print("expected d")
}

let cString = strdup("ghi")
if cString?.advanced(by: 2).pointee == "i" {
  print("expected i")
}

func nibble(_ char: UInt16) throws -> UInt16 {
  switch char {
  case "0" ... "9":
    return char - "0"
  case "a" ... "f":
    return char - "a" + 10
  case "A", "B", "C", "D", "E", "F":
    return char - "A" + 10
  default:
    throw NSError(domain: "bad character", code: -1, userInfo: nil)
  }
}

print(try! nibble(UInt16(ascii: "F")))
