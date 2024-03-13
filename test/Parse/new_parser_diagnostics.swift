// REQUIRES: swift_swift_parser
// REQUIRES: asserts

// RUN: %target-typecheck-verify-swift -enable-experimental-feature ParserDiagnostics

_ = [(Int) -> async throws Int]()
// expected-error@-1{{'async' may only occur before '->'}}
// expected-error@-2{{'async throws' must precede '->'}}
// expected-error@-3{{'throws' may only occur before '->'}}{{21-28=}} {{12-12=throws }}
// expected-note@-4{{move 'async throws' in front of '->'}}
