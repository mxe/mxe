#include <nlohmann/json.hpp>

using nlohmann::json;

int main() {
    json j = json::parse(R"({"status": "success"})");
    return (j["status"] != "success");
}
