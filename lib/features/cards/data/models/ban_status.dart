import 'package:ygobinder/features/cards/data/models/ygo_card.dart';

/// Restriction of a card in a banlist.
enum BanStatus { forbidden, limited, semiLimited, unlimited }

/// Parses a banlist value as stored in the card data: `Forbidden`, `Banned`,
/// `Limited`, `Semi-Limited`, or the numeric `0`–`3` used by the Edison and
/// HAT lists. Missing or unknown values are [BanStatus.unlimited].
BanStatus parseBanStatus(String? raw) {
  final s = raw?.trim().toLowerCase() ?? '';
  switch (s) {
    case 'banned' || 'prohibited' || 'forbidden' || '0':
      return BanStatus.forbidden;
    case 'limited' || '1':
      return BanStatus.limited;
    case 'semi-limited' || 'semilimited' || '2':
      return BanStatus.semiLimited;
    default:
      return BanStatus.unlimited;
  }
}

DateTime? _tcgDate(YgoCard card) {
  final raw = card.miscInfo?.firstOrNull?.tcgDate?.trim();
  if (raw == null || raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}

/// Released in the TCG after the GOAT format cutoff (Aug 17, 2005).
bool isAfterGoatCutoff(YgoCard card) => _tcgDate(card)?.isAfter(DateTime(2005, 8, 17)) ?? false;

/// Released in the TCG after the HAT format cutoff (May 16, 2014).
bool isAfterHatCutoff(YgoCard card) => _tcgDate(card)?.isAfter(DateTime(2014, 5, 16)) ?? false;
