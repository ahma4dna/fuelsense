import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/models/failure.dart';
import '../entities/create_report_params.dart';
import '../repositories/reports_repository.dart';

@lazySingleton
class SubmitReportUseCase {
  final ReportsRepository _repository;

  SubmitReportUseCase(this._repository);

  Future<Either<Failure, void>> call(CreateReportParams params) {
    return _repository.submitStationReport(params);
  }
}
