/// Formats seconds into a MM:SS time format string.
///
/// [totalSeconds] The total number of seconds to format.
/// Returns a string in the format "MM:SS" where minutes and seconds are zero-padded.
String formatTimeFromSeconds(int totalSeconds) {
  if (totalSeconds < 0) {
    throw ArgumentError('Total seconds cannot be negative');
  }

  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;

  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
