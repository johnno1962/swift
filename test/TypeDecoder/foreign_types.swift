// RUN: %empty-directory(%t)

// RUN: %target-build-swift -I %S/../ClangImporter/Inputs/custom-modules -I %S/../Inputs/custom-modules -emit-executable -emit-module %s -g -o %t/foreign_types
// RUN: sed -ne '/\/\/ *DEMANGLE: /s/\/\/ *DEMANGLE: *//p' < %s > %t/input
// RUN: %lldb-moduleimport-test-with-sdk %t/foreign_types -type-from-mangled=%t/input | %FileCheck %s

// REQUIRES: objc_interop

import Foundation
import CoreCooling
import ErrorEnums

extension CCRefrigerator {
    struct InternalNestedType {}
    fileprivate struct PrivateNestedType {}
}

/*
do {
    let x1 = CCRefrigeratorCreate(kCCPowerStandard)
    let x2 = MyError.good
    let x3 = MyError.Code.good
    let x4 = RenamedError.good
    let x5 = RenamedError.Code.good
    let x6 = Wrapper.MemberEnum.A
    let x7 = WrapperByAttribute(0)
    let x8 = IceCube(width: 0, height: 0, depth: 0)
    let x9 = BlockOfIce(width: 0, height: 0, depth: 0)
}

do {
    let x1 = CCRefrigerator.self
    let x2 = MyError.self
    let x3 = MyError.Code.self
    let x4 = RenamedError.self
    let x5 = RenamedError.Code.self
    let x6 = Wrapper.MemberEnum.self
    let x7 = WrapperByAttribute.self
    let x8 = IceCube.self
    let x9 = BlockOfIce.self
}
*/

// DEMANGLE: $sSo17CCRefrigeratorRefaD
// DEMANGLE: $sSo7MyErrorVD
// DEMANGLE: $sSo7MyErrorLeVD
// DEMANGLE: $sSo14MyRenamedErrorVD
// DEMANGLE: $sSo14MyRenamedErrorLeVD
// DEMANGLE: $sSo12MyMemberEnumVD
// DEMANGLE: $sSo18WrapperByAttributeaD
// DEMANGLE: $sSo7IceCubeVD
// DEMANGLE: $sSo10BlockOfIceaD
// DEMANGLE: $sSo17CCRefrigeratorRefa13foreign_typesE18InternalNestedTypeVD
// DEMANGLE: $sSo17CCRefrigeratorRefa13foreign_typesE17PrivateNestedType33_5415CB6AE6FCD935BF2278A4C9A5F9C3LLVD

// CHECK: CCRefrigerator
// CHECK: MyError.Code
// CHECK: MyError
// CHECK: RenamedError.Code
// CHECK: RenamedError
// CHECK: Wrapper.MemberEnum
// CHECK: WrapperByAttribute
// CHECK: IceCube
// CHECK: BlockOfIce
// CHECK: CCRefrigerator.InternalNestedType
// CHECK: CCRefrigerator.PrivateNestedType

// DEMANGLE: $sSo17CCRefrigeratorRefamD
// DEMANGLE: $sSo7MyErrorVmD
// DEMANGLE: $sSC7MyErrorLeVmD
// DEMANGLE: $sSo14MyRenamedErrorVmD
// DEMANGLE: $sSC14MyRenamedErrorLeVmD
// DEMANGLE: $sSo12MyMemberEnumVmD
// DEMANGLE: $sSo18WrapperByAttributeamD
// DEMANGLE: $sSo7IceCubeVmD
// DEMANGLE: $sSo10BlockOfIceamD
// DEMANGLE: $sSo17CCRefrigeratorRefa13foreign_typesE18InternalNestedTypeVmD
// DEMANGLE: $sSo17CCRefrigeratorRefa13foreign_typesE17PrivateNestedType33_5415CB6AE6FCD935BF2278A4C9A5F9C3LLVmD

// CHECK: CCRefrigerator.Type
// CHECK: MyError.Code.Type
// CHECK: MyError.Type
// CHECK: RenamedError.Code.Type
// CHECK: RenamedError.Type
// CHECK: Wrapper.MemberEnum.Type
// CHECK: WrapperByAttribute.Type
// CHECK: IceCube.Type
// CHECK: BlockOfIce.Type
// CHECK: CCRefrigerator.InternalNestedType.Type
// CHECK: CCRefrigerator.PrivateNestedType.Type

