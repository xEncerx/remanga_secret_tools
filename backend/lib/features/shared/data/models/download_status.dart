/// Represents the status of a download operation.
enum DownloadStatus {
  /// The download is pending and has not started yet.
  pending,

  /// The download is in progress.
  downloading,

  /// The download is complete.
  downloaded,

  /// The download has been paused.
  failure,
}
