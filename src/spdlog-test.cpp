
#include "spdlog/spdlog.h"

int main() 
{
    spdlog::info("spdlog test");
    spdlog::error("spdlog error {}", "with format");
}

