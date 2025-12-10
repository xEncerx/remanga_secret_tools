import 'package:fpdart/fpdart.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

/// Implementation of [PackRepository] using remote API.
class PackRepositoryImpl implements PackRepository {
  /// Creates a new instance of [PackRepositoryImpl].
  PackRepositoryImpl(this._api);

  final PackRemoteApi _api;

  @override
  Future<Either<ApiException, PackDTO>> getPackById(int id) {
    return _api.getPackById(id);
  }
}
