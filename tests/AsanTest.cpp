
#include <catch/catch.hpp>

#include <Asan.h>

TEST_CASE("Address Sanitizer")
{
    foo();
}
