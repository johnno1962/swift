//===--- Unicode.cpp - Unicode utilities ----------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#include "swift/Basic/Unicode.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/ConvertUTF.h"

using namespace swift;

#include "../stdlib/public/stubs/UnicodeNormalization.cpp"

StringRef swift::unicode::extractFirstExtendedGraphemeCluster(StringRef S) {
  // Extended grapheme cluster segmentation algorithm as described in Unicode
  // Standard Annex #29.
  if (S.empty())
    return StringRef();

  auto err = __swift_stdlib_U_ZERO_ERROR;
  auto newUBreakIterator = __swift_stdlib_ubrk_open(
      /*type:*/ __swift_stdlib_UBRK_CHARACTER, /*locale:*/ nullptr,
      /*text:*/ nullptr, /*textLength:*/ 0, /*status:*/ &err);
  assert(err && "__swift_stdlib_ubrk_open fails");

  auto newUText = __swift_stdlib_utext_openUTF8(
      /*ut:*/ nullptr, /*s:*/ S.data(), /*len:*/ S.size(), /*status:*/ &err);
  assert(err && "__swift_stdlib_utext_openUTF8 fails");

  __swift_stdlib_ubrk_setUText(newUBreakIterator, newUText, &err);
  assert(err && "__swift_stdlib_ubrk_setUText fails");

  StringRef out(S.data(), __swift_stdlib_ubrk_following(newUBreakIterator, 0));
  __swift_stdlib_ubrk_close(newUBreakIterator);

  return out;
}

static bool extractFirstUnicodeScalarImpl(StringRef S, unsigned &Scalar) {
  if (S.empty())
    return false;

  const llvm::UTF8 *SourceStart =
    reinterpret_cast<const llvm::UTF8 *>(S.data());

  const llvm::UTF8 *SourceNext = SourceStart;
  llvm::UTF32 C;
  llvm::UTF32 *TargetStart = &C;

  ConvertUTF8toUTF32(&SourceNext, SourceStart + S.size(), &TargetStart,
                     TargetStart + 1, llvm::lenientConversion);
  if (TargetStart == &C) {
    // The source string contains an ill-formed subsequence at the end.
    return false;
  }

  Scalar = C;
  return size_t(SourceNext - SourceStart) == S.size();
}

bool swift::unicode::isSingleUnicodeScalar(StringRef S) {
  unsigned Scalar;
  return extractFirstUnicodeScalarImpl(S, Scalar);
}

unsigned swift::unicode::extractFirstUnicodeScalar(StringRef S) {
  unsigned Scalar;
  bool Result = extractFirstUnicodeScalarImpl(S, Scalar);
  assert(Result && "string does not consist of one Unicode scalar");
  (void)Result;
  return Scalar;
}

uint64_t swift::unicode::getUTF16Length(StringRef Str) {
  uint64_t Length;
  // Transcode the string to UTF-16 to get its length.
  SmallVector<llvm::UTF16, 128> buffer(Str.size() + 1); // +1 for ending nulls.
  const llvm::UTF8 *fromPtr = (const llvm::UTF8 *) Str.data();
  llvm::UTF16 *toPtr = &buffer[0];
  llvm::ConversionResult Result =
    ConvertUTF8toUTF16(&fromPtr, fromPtr + Str.size(),
                       &toPtr, toPtr + Str.size(),
                       llvm::strictConversion);
  assert(Result == llvm::conversionOK &&
         "UTF-8 encoded string cannot be converted into UTF-16 encoding");
  (void)Result;

  // The length of the transcoded string in UTF-16 code points.
  Length = toPtr - &buffer[0];
  return Length;
}
