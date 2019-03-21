#!/bin/sh

# Copyright 2016 SolarWinds Worldwide, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Jock! Start the engine!
/app/"${PREFIX}"/startup.sh

# Touch to update inode, just in case tomcat hasn't written to it yet.
touch /app/"${PREFIX}"/iwc/tomcat/logs/catalina.out

# Print the contents of the Tomcat catalina.out log on stdout.
exec /usr/bin/tail -n 1000 --follow=name /app/"${PREFIX}"/iwc/tomcat/logs/catalina.out
