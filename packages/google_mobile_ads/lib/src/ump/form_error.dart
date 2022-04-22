// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Error information about why a form operation failed.
class FormError {
  /// Init a [FormError] with the errorCode and message.
  FormError({required this.errorCode, required this.message});

  /// TODO - update error codes. Maybe add enum
  final int errorCode;

  /// The message describing the error.
  final String? message;
}
