import 'dart:async';
import 'dart:convert';

import 'package:bonemeal_runner/src/asset/writer.dart';
import 'package:glob/glob.dart';
import 'package:bonemeal_core/bonemeal_core.dart';

import 'package:bonemeal_runner/src/meta_object/context_impl.dart';

class BuildStepImpl extends BuildStep {
  final AssetReader _reader;
  final RunnerAssetWriter _writer;

  BuildStepImpl({
    required super.iprPackage,
    required super.outputPackage,
    required this.inputs,
    required AssetReader reader,
    required RunnerAssetWriter writer,
  })  : _reader = reader,
        _writer = writer;

  @override
  final Set<AssetId> inputs;

  @override
  Future<void> buildMetaObjectFromData<T>(
    MetaObject<T> object,
    AssetId source,
    T data,
  ) async {
    final context = BuildContextImpl(
      iprPackage: iprPackage,
      outputPackage: outputPackage,
      source: source,
      reader: _reader,
      writer: _writer,
    );
    try {
      await object.build(context, data);
    } catch (e) {
      print('Failed to build meta-object $object from data $data.');
      print(e);
      rethrow;
    }
  }

  @override
  @Deprecated('Use buildMetaObjectFromData instead')
  FutureOr<void> buildMetaObjectFromAsset<T>(
    MetaObject<T> object,
    AssetId source,
  ) async {
    final content = await _reader.readAsString(source);
    final data = object.dataFromFile(source.path, content);
    return buildMetaObjectFromData(object, source, data);
  }

  @override
  Future<bool> canRead(AssetId id) => _reader.canRead(id);

  @override
  Stream<AssetId> findAssets(Glob glob) => _reader.findAssets(glob);

  @override
  Future<List<int>> readAsBytes(AssetId id) => _reader.readAsBytes(id);

  @override
  Future<String> readAsString(AssetId id, {Encoding encoding = utf8}) =>
      _reader.readAsString(id, encoding: encoding);

  @override
  Future<void> writeAsBytes(AssetId id, List<int> bytes) =>
      _writer.writeAsBytes(id, bytes);

  @override
  Future<void> writeAsString(AssetId id, String content,
          {Encoding encoding = utf8}) =>
      _writer.writeAsString(id, content, encoding: encoding);
}