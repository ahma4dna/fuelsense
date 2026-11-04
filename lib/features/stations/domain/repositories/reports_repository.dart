import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/models/failure.dart';
import '../entities/create_report_params.dart';

abstract class ReportsRepository {
  Future<Either<Failure, void>> submitStationReport(CreateReportParams params);
}
