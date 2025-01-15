#!/bin/bash

echo grub settings:
sudo cat /etc/default/grub | grep GRUB_CMDLINE_LINUX_DEFAULT

# proactive memory compaction:
echo compaction proactiveness: "$(cat /proc/sys/vm/compaction_proactiveness)"

# kernel samepage merging
echo ksm run: "$(cat /sys/kernel/mm/ksm/run)"

# trashing mitigation (prevent working set from getting evicted for 1000 millisec, this can help to mitigate stuttering behavior under memory pressure conditions):
echo lru_gen min_ttl_ms: "$(cat /sys/kernel/mm/lru_gen/min_ttl_ms)"

# prevent stuttering behavior during intense I/O writes that may involve massive page cache flushing:
echo dirty_ratio: "$(cat /proc/sys/vm/dirty_ratio)"
echo dirty_background_ratio: "$(cat /proc/sys/vm/dirty_background_ratio)"

