// REQUIRES: swift_swift_parser
// REQUIRES: asserts

// RUN: %target-typecheck-verify-swift -enable-experimental-feature ParserDiagnostics

_ = [(Int) -> async throws Int]()
// expected-error@-1{{'async throws' must precede '->'}}
// expected-note@-2{{move 'async throws' in front of '->'}}{{21-28=}} {{12-12=throws }}
// expected-error@-3{{'async' may only occur before '->'}}
// expected-error@-4{{'throws' may only occur before '->'}}
