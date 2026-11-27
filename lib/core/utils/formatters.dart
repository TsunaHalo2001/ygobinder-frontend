final _thousands = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

/// Formats [value] with `,` thousands separators, e.g. `1234.5` → `1,234.50`.
String formatWithThousandSeparators(double value, {int decimals = 2}) {
  final parts = value.toStringAsFixed(decimals).split('.');
  final integerPart = parts[0].replaceAllMapped(_thousands, (m) => '${m[1]},');
  final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';
  return '$integerPart$decimalPart';
}

String _two(int v) => v.toString().padLeft(2, '0');

/// Formats a date as `dd/MM/yyyy HH:mm`.
String formatDateTime(DateTime dt) => '${_two(dt.day)}/${_two(dt.month)}/${dt.year} ${_two(dt.hour)}:${_two(dt.minute)}';

/// Formats an ISO-8601 timestamp in local time as `dd/MM/yyyy HH:mm`
/// (empty string when missing or invalid).
String formatLastUpdatedTimestamp(String? isoString) {
  if (isoString == null || isoString.trim().isEmpty) return '';
  final dt = DateTime.tryParse(isoString);
  if (dt == null) return '';
  return formatDateTime(dt.toLocal());
}
