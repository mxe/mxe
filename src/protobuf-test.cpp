#include <google/protobuf/stubs/common.h>

int
main()
{
    GOOGLE_PROTOBUF_VERIFY_VERSION;
    google::protobuf::ShutdownProtobufLibrary();
    return 0;
}
