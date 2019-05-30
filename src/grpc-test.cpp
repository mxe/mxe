#include <grpc++/grpc++.h>

int main() {
    grpc::ServerBuilder builder;
    auto server = builder.BuildAndStart();
    grpc::Status status;
    return 0;
}
