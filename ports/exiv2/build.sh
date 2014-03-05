#!/bin/bash
# Copyright (c) 2011 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
# 
# The original file was modified by Maximilian Koch and Benjamin Henne

# exiv2 doesn't support custom build directories so we have
# to build directly in the source dir. It dies not work due
# to integrated xmpsdk.
BUILD_DIR=${SRC_DIR}

