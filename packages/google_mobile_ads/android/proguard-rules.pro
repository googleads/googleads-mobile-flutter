# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Keep WorkManager Database classes from being stripped or renamed by R8.
# When code shrinking/obfuscation is enabled under AGP 8.0+ / 9.0+, Room's reflective
# instantiation of WorkDatabase_Impl fails on startup during InitializationProvider initialization.
-keep class androidx.work.impl.WorkDatabase { *; }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
-keep class * extends androidx.work.impl.WorkDatabase { *; }
-dontwarn androidx.work.impl.**

# Keep Room Database implementation classes used by WorkManager
-keep class androidx.room.RoomDatabase { *; }
-keep @androidx.room.Database class * extends androidx.room.RoomDatabase { *; }
