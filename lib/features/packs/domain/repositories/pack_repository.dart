import 'package:fpdart/fpdart.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

/// Repository for managing pack data.
abstract class PackRepository {
  /// Fetches a pack by its ID.
  Future<Either<ApiException, PackDTO>> getPackById(int id);
}
