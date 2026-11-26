import 'package:ygobinder/core/database/app_database.dart';

/// Builds `.ydk` text from card id lists.
String buildYdk({Iterable<int> main = const [], Iterable<int> extra = const [], Iterable<int> side = const []}) {
  final buffer = StringBuffer();
  buffer.writeln('#main');
  for (final id in main) {
    buffer.writeln(id);
  }
  buffer.writeln('#extra');
  for (final id in extra) {
    buffer.writeln(id);
  }
  buffer.writeln('!side');
  for (final id in side) {
    buffer.writeln(id);
  }
  return buffer.toString();
}

String buildYdkFromCategorized(Map<String, List<int>> categorized) => buildYdk(
      main: categorized['main'] ?? const [],
      extra: categorized['extra'] ?? const [],
      side: categorized['side'] ?? const [],
    );

/// Parses `.ydk` text into `main` / `extra` / `side` card id lists.
Map<String, List<int>> parseYdkContent(String content) {
  final categorizedCards = <String, List<int>>{
    'main': [],
    'extra': [],
    'side': [],
  };
  if (content.isEmpty) return categorizedCards;

  String currentCategory = '';
  for (final line in content.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) continue;

    if (trimmed == '#main') {
      currentCategory = 'main';
    } else if (trimmed == '#extra') {
      currentCategory = 'extra';
    } else if (trimmed == '!side') {
      currentCategory = 'side';
    } else {
      final cardId = int.tryParse(trimmed);
      if (cardId != null && currentCategory.isNotEmpty) {
        categorizedCards[currentCategory]?.add(cardId);
      }
    }
  }
  return categorizedCards;
}

/// Groups stored deck cards into `main` / `extra` / `side` id lists.
Map<String, List<int>> groupDeckCardsByCategory(Iterable<DriftDeckCard> cards) {
  final grouped = <String, List<int>>{'main': [], 'extra': [], 'side': []};
  for (final c in cards) {
    grouped.putIfAbsent(c.category, () => []).add(c.cardId);
  }
  return grouped;
}
