/*
 * Copyright 2020. Huawei Technologies Co., Ltd. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

class RemoteConfigException implements Exception {
  /// Remote Config SDK的错误码

  /// 受到本地流控,请稍后重试
  static const int RemoteConfigErrorCodeFetchThrottled = 1;

  /// 系统错误，请联系华为技术人员
  static const int RemoteConfigErrorCodeUnknown = 0x0c2a0001;

  /// 应用未配置参数条件
  static const int RemoteConfigErrorCodeRcsConfigEmpty = 0x0c2a0004;

  /// 响应数据未改变
  static const int RemoteConfigErrorCodeDataNotModified = 0x0c2a3001;

  RemoteConfigException({this.code, this.message, this.throttleEndTimeMillis});

  /// 错误码
  final int? code;

  /// 错误描述
  final String? message;

  /// 限流时间，单位为毫秒
  final int? throttleEndTimeMillis;

  @override
  String toString() {
    if (throttleEndTimeMillis != null) {
      return "Exception: code : $code , message: $message. throttle time $throttleEndTimeMillis milliseconds";
    }
    return "Exception: code : $code , message: $message.";
  }
}
