#!/usr/bin/env bash

# Must be run from vendor/cloud9-patches folder

diff -Naur configs/default.js configs/default.js.fixed > smithio_port.patch