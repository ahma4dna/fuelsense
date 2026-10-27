enum OfficialStationStatus {
  open,
  refilling,
  onTheWay,
  closed,
  outOfFuel,
  unknown,
}

enum TrafficLevel {
  normal,
  busy,
  heavy,
}

enum QueueLevel {
  light,
  medium,
  heavy,
  stopped,
}

enum StationQuickFilter {
  all,
  openNow,
  refilledToday,
  onTheWay,
  normalTraffic,
}

enum StationsDataStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

enum TodayReportsStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

enum StationHistoryStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

enum HistorySessionReportsStatus {
  initial,
  loading,
  loaded,
  error,
}

enum SubmitReportStatus {
  idle,
  submitting,
  success,
  outOfRangeError,
  error,
}

enum ConfirmReportStatus {
  idle,
  confirming,
  success,
  outOfRangeError,
  error,
}

enum FavoriteActionStatus {
  idle,
  loading,
  success,
  error,
}
