#include <hwloc.h>

int main()
{
    hwloc_topology_t topo;
    hwloc_topology_init(&topo);

    hwloc_topology_destroy(topo);

    return 0;
}
