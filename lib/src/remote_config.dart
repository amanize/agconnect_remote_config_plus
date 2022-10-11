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

import 'dart:io';

import 'package:agconnect_remote_config/src/remote_config_exception.dart';
import 'package:flutter/services.dart';

/// 远程配置获取的value值的来源
enum RemoteConfigSource {
  /// 获取的value值是类型初始值
  initial,

  /// 获取的value值是本地默认值
  local,

  /// 获取的value值是云端值
  remote,
}

/// AGConnect RemoteConfig SDK 入口类
class AGCRemoteConfig {
  static const MethodChannel _channel =
      const MethodChannel('com.huawei.flutter/agconnect_remote_config');

  /// 获取AGCRemoteConfig实例
  static final AGCRemoteConfig instance = AGCRemoteConfig();

  /// 设置本地默认参数
  Future<void> applyDefaults(Map<String, dynamic>? defaults) {
    Map<String, String> map = Map();
    defaults?.forEach((String key, dynamic value) {
      map[key] = value.toString();
    });
    return _channel
        .invokeMethod('applyDefaults', <String, dynamic>{'defaults': map});
  }

  /// 生效最近一次云端拉取的配置数据
  Future<void> applyLastFetched() {
    return _channel.invokeMethod('applyLastFetched');
  }

  /// 从云端拉取最新的配置数据，拉取默认间隔12小时，12小时内返回缓存数据
  Future<void> fetch({int? intervalSeconds}) {
    return _channel.invokeMethod('fetch',
        <String, int?>{'intervalSeconds': intervalSeconds}).catchError((e) {
      int? code = int.tryParse(e.code);
      int? throttleEndTime =
          e.details != null ? e.details['throttleEndTime'] : null;
      throw RemoteConfigException(
          code: code,
          message: e.message,
          throttleEndTimeMillis: throttleEndTime);
    });
  }

  /// 返回Key对应的String类型的Value值
  Future<String?> getValue(String key) {
    return _channel.invokeMethod('getValue', <String, String>{'key': key});
  }

  /// 返回Key对应的来源
  Future<RemoteConfigSource?> getSource(String key) {
    return _channel
        .invokeMethod('getSource', <String, String>{'key': key}).then((value) {
      switch (value) {
        case 0:
          return RemoteConfigSource.initial;
        case 1:
          return RemoteConfigSource.local;
        case 2:
          return RemoteConfigSource.remote;
        default:
          return null;
      }
    });
  }

  /// 返回默认值和云端值合并后的所有值
  Future<Map?> getMergedAll() {
    return _channel.invokeMethod('getMergedAll');
  }

  /// 清除所有的缓存数据，包括从云测拉取的数据和传入的默认值
  Future<void> clearAll() {
    return _channel.invokeMethod('clearAll');
  }

  /// 设置开发者模式，将不限制客户端获取数据的次数，云测仍将进行流控
  /// 仅支持Android
  Future<void> setDeveloperMode(bool isDeveloperMode) {
    if (Platform.isIOS) {
      print(
          'The setDeveloperMode method only supports Android, please refer to the development guide to set the developer mode on iOS.');
    }
    return _channel.invokeMethod(
        'setDeveloperMode', <String, bool>{'mode': isDeveloperMode});
  }
}
