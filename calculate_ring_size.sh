#!/bin/bash
# Python one-liner to help decide how to size your OpenStack Swift Ring.
python -c 'min_drives = 10; max_drives = 60000; replicas = 3; import math; part_power = math.ceil(math.log(math.ceil(max_drives * 100.0 / replicas), 2)); print "part_power: %d\npartition_count: %d\napproximate per drive with %d drives: %.02f\napproximate per drive with %d drives: %.02f" % (part_power, 2**part_power, min_drives, 2**part_power * replicas / min_drives, max_drives, 2**part_power * replicas / max_drives)'
