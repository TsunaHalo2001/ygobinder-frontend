import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:ygobinder/core/database/app_database.dart';
import 'package:ygobinder/features/cards/data/mappers/card_mapper.dart';
import 'package:ygobinder/features/cards/data/models/ygo_card.dart';

/// Every row produced from the card cache JSON, ready to be batch-inserted.
class ParsedCardCache {
  final List<CardsCompanion> cards;
  final List<CardImagesCompanion> images;
  final List<CardPricesCompanion> prices;
  final List<CardSetsCompanion> cardSets;
  final List<BanlistInfosCompanion> banlists;
  final List<SetInfosCompanion> setInfos;

  const ParsedCardCache({
    required this.cards,
    required this.images,
    required this.prices,
    required this.cardSets,
    required this.banlists,
    required this.setInfos,
  });
}

/// Decodes and parses the card cache entirely in a background isolate.
///
/// [onDecoded] is called (on the calling isolate) with the raw card and set
/// counts as soon as the JSON is decoded, before the slower mapping step.
Future<ParsedCardCache> parseCardCacheInBackground(
  Uint8List bytes, {
  void Function(int cardCount, int setCount)? onDecoded,
}) async {
  final messages = ReceivePort();
  final errors = ReceivePort();
  final exits = ReceivePort();
  final result = Completer<ParsedCardCache>();

  messages.listen((message) {
    if (message is (int, int)) {
      onDecoded?.call(message.$1, message.$2);
    } else if (message is ParsedCardCache && !result.isCompleted) {
      result.complete(message);
    }
  });
  errors.listen((error) {
    if (result.isCompleted) return;
    final details = error as List<Object?>;
    result.completeError(
      FormatException('Could not parse card data: ${details.first}'),
      StackTrace.fromString(details.length > 1 ? '${details[1]}' : ''),
    );
  });
  exits.listen((_) {
    // The result/error message is sent before the exit notification; defer
    // so it is handled first.
    Future(() {
      if (!result.isCompleted) {
        result.completeError(StateError('Card data parser stopped unexpectedly.'));
      }
    });
  });

  try {
    await Isolate.spawn<_ParseRequest>(
      _parseEntryPoint,
      _ParseRequest(messages.sendPort, TransferableTypedData.fromList([bytes])),
      onError: errors.sendPort,
      onExit: exits.sendPort,
      errorsAreFatal: true,
    );
    return await result.future;
  } finally {
    messages.close();
    errors.close();
    exits.close();
  }
}

class _ParseRequest {
  final SendPort port;
  final TransferableTypedData bytes;
  const _ParseRequest(this.port, this.bytes);
}

void _parseEntryPoint(_ParseRequest request) {
  final bytes = request.bytes.materialize().asUint8List();
  final parsed = parseCardCacheBytes(
    bytes,
    onDecoded: (cards, sets) => request.port.send((cards, sets)),
  );
  Isolate.exit(request.port, parsed);
}

/// Synchronous parser (runs inside the background isolate; exposed for tests).
ParsedCardCache parseCardCacheBytes(
  Uint8List bytes, {
  void Function(int cardCount, int setCount)? onDecoded,
}) {
  final decoded = const Utf8Decoder().fuse(const JsonDecoder()).convert(bytes);

  final List<dynamic> rawCards;
  final List<dynamic> rawSets;
  if (decoded is Map<String, dynamic>) {
    rawCards = (decoded['data'] ?? decoded['cards'] ?? decoded['results']) as List<dynamic>? ?? const [];
    rawSets = decoded['sets'] as List<dynamic>? ?? const [];
  } else if (decoded is List) {
    rawCards = decoded;
    rawSets = const [];
  } else {
    throw const FormatException('Unexpected JSON structure: Expected a list or a map.');
  }
  onDecoded?.call(rawCards.length, rawSets.length);

  final cards = <CardsCompanion>[];
  final images = <CardImagesCompanion>[];
  final prices = <CardPricesCompanion>[];
  final cardSets = <CardSetsCompanion>[];
  final banlists = <BanlistInfosCompanion>[];

  for (final item in rawCards) {
    final json = item as Map<String, dynamic>;
    if (json['type'] == 'Skill Card') continue;
    final card = YgoCard.fromJson(json);

    cards.add(CardMapper.toDriftCardCompanion(card));
    if (card.cardImages?.isNotEmpty ?? false) {
      images.addAll(CardMapper.toDriftCardImagesCompanions(card.id, card.cardImages!));
    }
    if (card.cardPrices?.isNotEmpty ?? false) {
      prices.addAll(CardMapper.toDriftCardPricesCompanions(card.id, card.cardPrices!));
    }
    if (card.cardSets?.isNotEmpty ?? false) {
      cardSets.addAll(CardMapper.toDriftCardSetsCompanions(card.id, card.cardSets!));
    }
    final banlist = CardMapper.toDriftBanlistInfoCompanion(card.id, card.banlistInfo);
    if (banlist != null) banlists.add(banlist);
  }

  final setInfos = rawSets.map((item) {
    final json = item as Map<String, dynamic>;
    return SetInfosCompanion.insert(
      id: Value(json['id'] as int),
      name: json['name'] as String,
      abbreviation: Value(json['abbreviation'] as String?),
      setType: Value(json['type'] as String?),
      isSupplemental: Value(json['is_supplemental'] as bool? ?? false),
      publishedOn: Value(json['published_on'] as String?),
      modifiedOn: Value(json['modified_on'] as String?),
      productCount: Value(json['product_count'] as int?),
      skuCount: Value(json['sku_count'] as int?),
      setSymbolUrl: Value(json['set_symbol_url'] as String?),
      setSymbolCached: Value(json['set_symbol_cached'] as bool? ?? false),
      apiUrl: Value(json['api_url'] as String?),
      cardsUrl: Value(json['cards_url'] as String?),
      sealedUrl: Value(json['sealed_url'] as String?),
      pricingUrl: Value(json['pricing_url'] as String?),
      skusUrl: Value(json['skus_url'] as String?),
    );
  }).toList();

  return ParsedCardCache(
    cards: cards,
    images: images,
    prices: prices,
    cardSets: cardSets,
    banlists: banlists,
    setInfos: setInfos,
  );
}
