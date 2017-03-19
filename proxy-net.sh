#!/bin/bash

virsh attach-interface proxy-0 network bosh --mac de:ad:be:ef:00:01 --model virtio
