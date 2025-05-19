#!/usr/bin/env python3

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import sys

version = os.getenv('VERSION', '0.0.4')

CQLSH_DEBUG = os.getenv('CQLSH_DEBUG')

def get_cython_extension_path():
    # first, build directory
    if os.path.exists('build'):
        for lib_dir in os.listdir('build'):
            if lib_dir.startswith('lib.'):
                return os.path.join('build', lib_dir)

    # possible homes
    cqlshHome = [
            os.getenv('CQLSH_HOME'),
            '/opt/AxonOps',
            '/usr/local/AxonOps',
            f"~/homebrew/Cellar/axonops-cqlsh/{version}",
            f"/opt/homebrew/Cellar/axonops-cqlsh/{version}"
    ]

    # Add Windows-specific paths
    if 'win' in sys.platform:
        cqlshHome.append("C:\\Program Files (x86)\\AxonOps\\Lib")
        cqlshHome.append(f"C:\\Program Files (x86)\\AxonOps")
        cqlshHome.append(f"C:\\AxonOps\\cqlsh")

    for h in cqlshHome:
        if h is None:
            continue
        if len(h) < 1:
            continue
        if CQLSH_DEBUG:
            print(f"DEBUG: Checking {h}")
        if os.path.exists(os.path.expanduser(h)):
            return os.path.join(h, 'lib')

    if os.path.exists(os.path.expanduser('~/homebrew/bin/cqlsh')):
        return os.path.expanduser('~/homebrew/lib')

    if os.path.exists(os.path.expanduser('/opt/homebrew/bin/cqlsh')):
        return os.path.expanduser('/opt/homebrew/lib')

    return None

CASSANDRA_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..')

# Get the absolute path to the build directory
ext_path = get_cython_extension_path()
if ext_path is None:
    ext_path = os.path.join(CASSANDRA_PATH, '../lib'),

if ext_path not in sys.path:
    sys.path.insert(0, ext_path)

if CQLSH_DEBUG:
    print(f"DEBUG: CQLSH_HOME: {os.getenv('CQLSH_HOME')}")
    print(f"DEBUG: CASSANDRA_PATH: {CASSANDRA_PATH}")

    print(f"DEBUG: ext_path: {ext_path}")
    print(f"DEBUG: sys.path: {sys.path}")

from cqlshlib.cqlshmain import main

if __name__ == '__main__':
    main(sys.argv[1:], CASSANDRA_PATH)

