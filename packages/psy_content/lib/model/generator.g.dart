// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NbackParams _$NbackParamsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NbackParams', json, ($checkedConvert) {
      final val = NbackParams(
        n: $checkedConvert('n', (v) => (v as num?)?.toInt() ?? 2),
        stimulusKind: $checkedConvert(
          'stimulusKind',
          (v) =>
              $enumDecodeNullable(_$NbackStimulusKindEnumMap, v) ??
              NbackStimulusKind.colour,
        ),
        paletteSize: $checkedConvert(
          'paletteSize',
          (v) => (v as num?)?.toInt() ?? 3,
        ),
        count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 42),
        primers: $checkedConvert('primers', (v) => (v as num?)?.toInt() ?? 2),
        stimulusMs: $checkedConvert(
          'stimulusMs',
          (v) => (v as num?)?.toInt() ?? 1000,
        ),
        answerWindowMs: $checkedConvert(
          'answerWindowMs',
          (v) => (v as num?)?.toInt() ?? 1500,
        ),
        targetRatio: $checkedConvert(
          'targetRatio',
          (v) => (v as num?)?.toDouble() ?? 0.3,
        ),
        lureRatio: $checkedConvert(
          'lureRatio',
          (v) => (v as num?)?.toDouble() ?? 0.1,
        ),
        $type: $checkedConvert('generatorId', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$NbackParamsToJson(NbackParams instance) =>
    <String, dynamic>{
      'n': instance.n,
      'stimulusKind': _$NbackStimulusKindEnumMap[instance.stimulusKind]!,
      'paletteSize': instance.paletteSize,
      'count': instance.count,
      'primers': instance.primers,
      'stimulusMs': instance.stimulusMs,
      'answerWindowMs': instance.answerWindowMs,
      'targetRatio': instance.targetRatio,
      'lureRatio': instance.lureRatio,
      'generatorId': instance.$type,
    };

const _$NbackStimulusKindEnumMap = {
  NbackStimulusKind.colour: 'colour',
  NbackStimulusKind.digit: 'digit',
  NbackStimulusKind.letter: 'letter',
};

TubesParams _$TubesParamsFromJson(Map<String, dynamic> json) => $checkedCreate(
  'TubesParams',
  json,
  ($checkedConvert) {
    final val = TubesParams(
      capacities: $checkedConvert(
        'capacities',
        (v) =>
            (v as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ??
            const <int>[3, 2, 3],
      ),
      colourCount: $checkedConvert(
        'colourCount',
        (v) => (v as num?)?.toInt() ?? 3,
      ),
      ballCount: $checkedConvert('ballCount', (v) => (v as num?)?.toInt() ?? 5),
      minMoves: $checkedConvert('minMoves', (v) => (v as num?)?.toInt() ?? 2),
      maxMoves: $checkedConvert('maxMoves', (v) => (v as num?)?.toInt() ?? 8),
      $type: $checkedConvert('generatorId', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {r'$type': 'generatorId'},
);

Map<String, dynamic> _$TubesParamsToJson(TubesParams instance) =>
    <String, dynamic>{
      'capacities': instance.capacities,
      'colourCount': instance.colourCount,
      'ballCount': instance.ballCount,
      'minMoves': instance.minMoves,
      'maxMoves': instance.maxMoves,
      'generatorId': instance.$type,
    };

StimulusResponseParams _$StimulusResponseParamsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('StimulusResponseParams', json, ($checkedConvert) {
  final val = StimulusResponseParams(
    count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 36),
    stimulusMs: $checkedConvert(
      'stimulusMs',
      (v) => (v as num?)?.toInt() ?? 500,
    ),
    answerWindowMs: $checkedConvert(
      'answerWindowMs',
      (v) => (v as num?)?.toInt() ?? 3000,
    ),
    keys: $checkedConvert(
      'keys',
      (v) =>
          (v as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>['n', 'x'],
    ),
    shapes: $checkedConvert(
      'shapes',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => $enumDecode(_$StimulusShapeEnumMap, e))
              .toList() ??
          const <StimulusShape>[StimulusShape.square, StimulusShape.triangle],
    ),
    colours: $checkedConvert(
      'colours',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => $enumDecode(_$StimulusColourEnumMap, e))
              .toList() ??
          const <StimulusColour>[StimulusColour.blue, StimulusColour.orange],
    ),
    ruleDepth: $checkedConvert('ruleDepth', (v) => (v as num?)?.toInt() ?? 2),
    $type: $checkedConvert('generatorId', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$StimulusResponseParamsToJson(
  StimulusResponseParams instance,
) => <String, dynamic>{
  'count': instance.count,
  'stimulusMs': instance.stimulusMs,
  'answerWindowMs': instance.answerWindowMs,
  'keys': instance.keys,
  'shapes': instance.shapes.map((e) => _$StimulusShapeEnumMap[e]!).toList(),
  'colours': instance.colours.map((e) => _$StimulusColourEnumMap[e]!).toList(),
  'ruleDepth': instance.ruleDepth,
  'generatorId': instance.$type,
};

const _$StimulusShapeEnumMap = {
  StimulusShape.square: 'square',
  StimulusShape.triangle: 'triangle',
  StimulusShape.circle: 'circle',
  StimulusShape.diamond: 'diamond',
  StimulusShape.star: 'star',
};

const _$StimulusColourEnumMap = {
  StimulusColour.blue: 'blue',
  StimulusColour.orange: 'orange',
  StimulusColour.green: 'green',
  StimulusColour.pink: 'pink',
  StimulusColour.red: 'red',
  StimulusColour.yellow: 'yellow',
};

ParitySequenceParams _$ParitySequenceParamsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ParitySequenceParams', json, ($checkedConvert) {
  final val = ParitySequenceParams(
    numberCount: $checkedConvert(
      'numberCount',
      (v) => (v as num?)?.toInt() ?? 16,
    ),
    numberMin: $checkedConvert('numberMin', (v) => (v as num?)?.toInt() ?? 1),
    numberMax: $checkedConvert('numberMax', (v) => (v as num?)?.toInt() ?? 99),
    restartOnError: $checkedConvert(
      'restartOnError',
      (v) => v as bool? ?? true,
    ),
    labelEnds: $checkedConvert('labelEnds', (v) => v as bool? ?? true),
    $type: $checkedConvert('generatorId', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$ParitySequenceParamsToJson(
  ParitySequenceParams instance,
) => <String, dynamic>{
  'numberCount': instance.numberCount,
  'numberMin': instance.numberMin,
  'numberMax': instance.numberMax,
  'restartOnError': instance.restartOnError,
  'labelEnds': instance.labelEnds,
  'generatorId': instance.$type,
};

OverlayGridParams _$OverlayGridParamsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OverlayGridParams', json, ($checkedConvert) {
      final val = OverlayGridParams(
        grid: $checkedConvert(
          'grid',
          (v) => v == null
              ? const GridSize(rows: 5, cols: 5)
              : GridSize.fromJson(v as Map<String, dynamic>),
        ),
        tileCount: $checkedConvert(
          'tileCount',
          (v) => (v as num?)?.toInt() ?? 3,
        ),
        overlapping: $checkedConvert('overlapping', (v) => v as bool? ?? true),
        blackCells: $checkedConvert('blackCells', (v) => v as bool? ?? true),
        $type: $checkedConvert('generatorId', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$OverlayGridParamsToJson(OverlayGridParams instance) =>
    <String, dynamic>{
      'grid': instance.grid.toJson(),
      'tileCount': instance.tileCount,
      'overlapping': instance.overlapping,
      'blackCells': instance.blackCells,
      'generatorId': instance.$type,
    };

DominosParams _$DominosParamsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DominosParams', json, ($checkedConvert) {
      final val = DominosParams(
        length: $checkedConvert('length', (v) => (v as num?)?.toInt() ?? 6),
        layout: $checkedConvert(
          'layout',
          (v) =>
              $enumDecodeNullable(_$DominoLayoutEnumMap, v) ?? DominoLayout.row,
        ),
        ruleCount: $checkedConvert(
          'ruleCount',
          (v) => (v as num?)?.toInt() ?? 1,
        ),
        answerMode: $checkedConvert(
          'answerMode',
          (v) =>
              $enumDecodeNullable(_$DominoAnswerModeEnumMap, v) ??
              DominoAnswerMode.pick,
        ),
        $type: $checkedConvert('generatorId', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$DominosParamsToJson(DominosParams instance) =>
    <String, dynamic>{
      'length': instance.length,
      'layout': _$DominoLayoutEnumMap[instance.layout]!,
      'ruleCount': instance.ruleCount,
      'answerMode': _$DominoAnswerModeEnumMap[instance.answerMode]!,
      'generatorId': instance.$type,
    };

const _$DominoLayoutEnumMap = {
  DominoLayout.row: 'row',
  DominoLayout.grid: 'grid',
  DominoLayout.spiral: 'spiral',
};

const _$DominoAnswerModeEnumMap = {
  DominoAnswerMode.pick: 'pick',
  DominoAnswerMode.mcq: 'mcq',
};

AirwaysParams _$AirwaysParamsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AirwaysParams', json, ($checkedConvert) {
  final val = AirwaysParams(
    capacity: $checkedConvert('capacity', (v) => (v as num?)?.toInt() ?? 4),
    blueCapacity: $checkedConvert(
      'blueCapacity',
      (v) => (v as num?)?.toInt() ?? 2,
    ),
    zoneCount: $checkedConvert('zoneCount', (v) => (v as num?)?.toInt() ?? 2),
    routeCount: $checkedConvert('routeCount', (v) => (v as num?)?.toInt() ?? 3),
    spawnIntervalMs: $checkedConvert(
      'spawnIntervalMs',
      (v) => (v as num?)?.toInt() ?? 2500,
    ),
    durationSec: $checkedConvert(
      'durationSec',
      (v) => (v as num?)?.toInt() ?? 30,
    ),
    $type: $checkedConvert('generatorId', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$AirwaysParamsToJson(AirwaysParams instance) =>
    <String, dynamic>{
      'capacity': instance.capacity,
      'blueCapacity': instance.blueCapacity,
      'zoneCount': instance.zoneCount,
      'routeCount': instance.routeCount,
      'spawnIntervalMs': instance.spawnIntervalMs,
      'durationSec': instance.durationSec,
      'generatorId': instance.$type,
    };

WordBoxesParams _$WordBoxesParamsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WordBoxesParams', json, ($checkedConvert) {
      final val = WordBoxesParams(
        boxCount: $checkedConvert('boxCount', (v) => (v as num?)?.toInt() ?? 5),
        wordCount: $checkedConvert(
          'wordCount',
          (v) => (v as num?)?.toInt() ?? 20,
        ),
        fieldIds: $checkedConvert(
          'fieldIds',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        trapRatio: $checkedConvert(
          'trapRatio',
          (v) => (v as num?)?.toDouble() ?? 0.1,
        ),
        wordTimeMs: $checkedConvert(
          'wordTimeMs',
          (v) => (v as num?)?.toInt() ?? 3000,
        ),
        $type: $checkedConvert('generatorId', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$WordBoxesParamsToJson(WordBoxesParams instance) =>
    <String, dynamic>{
      'boxCount': instance.boxCount,
      'wordCount': instance.wordCount,
      'fieldIds': ?instance.fieldIds,
      'trapRatio': instance.trapRatio,
      'wordTimeMs': instance.wordTimeMs,
      'generatorId': instance.$type,
    };

ArithmeticGridParams _$ArithmeticGridParamsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ArithmeticGridParams', json, ($checkedConvert) {
  final val = ArithmeticGridParams(
    grid: $checkedConvert(
      'grid',
      (v) => v == null
          ? const GridSize(rows: 3, cols: 3)
          : GridSize.fromJson(v as Map<String, dynamic>),
    ),
    wrongMin: $checkedConvert('wrongMin', (v) => (v as num?)?.toInt() ?? 0),
    wrongMax: $checkedConvert('wrongMax', (v) => (v as num?)?.toInt() ?? 4),
    operations: $checkedConvert(
      'operations',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ArithmeticOperationEnumMap, e))
              .toList() ??
          const <ArithmeticOperation>[
            ArithmeticOperation.add,
            ArithmeticOperation.sub,
            ArithmeticOperation.mul,
            ArithmeticOperation.div,
            ArithmeticOperation.square,
            ArithmeticOperation.priority,
          ],
    ),
    maxOperand: $checkedConvert(
      'maxOperand',
      (v) => (v as num?)?.toInt() ?? 100,
    ),
    $type: $checkedConvert('generatorId', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$ArithmeticGridParamsToJson(
  ArithmeticGridParams instance,
) => <String, dynamic>{
  'grid': instance.grid.toJson(),
  'wrongMin': instance.wrongMin,
  'wrongMax': instance.wrongMax,
  'operations': instance.operations
      .map((e) => _$ArithmeticOperationEnumMap[e]!)
      .toList(),
  'maxOperand': instance.maxOperand,
  'generatorId': instance.$type,
};

const _$ArithmeticOperationEnumMap = {
  ArithmeticOperation.add: 'add',
  ArithmeticOperation.sub: 'sub',
  ArithmeticOperation.mul: 'mul',
  ArithmeticOperation.div: 'div',
  ArithmeticOperation.square: 'square',
  ArithmeticOperation.percent: 'percent',
  ArithmeticOperation.priority: 'priority',
};

ViewpointParams _$ViewpointParamsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ViewpointParams', json, ($checkedConvert) {
      final val = ViewpointParams(
        viewpointCount: $checkedConvert(
          'viewpointCount',
          (v) => (v as num?)?.toInt() ?? 8,
        ),
        objectCount: $checkedConvert(
          'objectCount',
          (v) => (v as num?)?.toInt() ?? 4,
        ),
        objectKinds: $checkedConvert(
          'objectKinds',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => $enumDecode(_$SolidKindEnumMap, e))
                  .toList() ??
              const <SolidKind>[
                SolidKind.cube,
                SolidKind.cylinder,
                SolidKind.cone,
              ],
        ),
        allowSymmetric: $checkedConvert(
          'allowSymmetric',
          (v) => v as bool? ?? false,
        ),
        $type: $checkedConvert('generatorId', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$ViewpointParamsToJson(ViewpointParams instance) =>
    <String, dynamic>{
      'viewpointCount': instance.viewpointCount,
      'objectCount': instance.objectCount,
      'objectKinds': instance.objectKinds
          .map((e) => _$SolidKindEnumMap[e]!)
          .toList(),
      'allowSymmetric': instance.allowSymmetric,
      'generatorId': instance.$type,
    };

const _$SolidKindEnumMap = {
  SolidKind.cube: 'cube',
  SolidKind.cylinder: 'cylinder',
  SolidKind.cone: 'cone',
  SolidKind.sphere: 'sphere',
  SolidKind.pyramid: 'pyramid',
};

CubeNetParams _$CubeNetParamsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CubeNetParams', json, ($checkedConvert) {
      final val = CubeNetParams(
        missingFaces: $checkedConvert(
          'missingFaces',
          (v) => (v as num?)?.toInt() ?? 2,
        ),
        distractorFaces: $checkedConvert(
          'distractorFaces',
          (v) => (v as num?)?.toInt() ?? 2,
        ),
        symbolKind: $checkedConvert(
          'symbolKind',
          (v) =>
              $enumDecodeNullable(_$CubeSymbolKindEnumMap, v) ??
              CubeSymbolKind.letters,
        ),
        flippable: $checkedConvert('flippable', (v) => v as bool? ?? true),
        $type: $checkedConvert('generatorId', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$CubeNetParamsToJson(CubeNetParams instance) =>
    <String, dynamic>{
      'missingFaces': instance.missingFaces,
      'distractorFaces': instance.distractorFaces,
      'symbolKind': _$CubeSymbolKindEnumMap[instance.symbolKind]!,
      'flippable': instance.flippable,
      'generatorId': instance.$type,
    };

const _$CubeSymbolKindEnumMap = {
  CubeSymbolKind.letters: 'letters',
  CubeSymbolKind.shapes: 'shapes',
  CubeSymbolKind.mixed: 'mixed',
};

MultitaskParams _$MultitaskParamsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MultitaskParams', json, ($checkedConvert) {
      final val = MultitaskParams(
        durationSec: $checkedConvert(
          'durationSec',
          (v) => (v as num?)?.toInt() ?? 300,
        ),
        trackingSpeed: $checkedConvert(
          'trackingSpeed',
          (v) => (v as num?)?.toDouble() ?? 1.0,
        ),
        trackingNoise: $checkedConvert(
          'trackingNoise',
          (v) => (v as num?)?.toDouble() ?? 1.0,
        ),
        shapeIntervalMs: $checkedConvert(
          'shapeIntervalMs',
          (v) => (v as num?)?.toInt() ?? 2000,
        ),
        calcIntervalMs: $checkedConvert(
          'calcIntervalMs',
          (v) => (v as num?)?.toInt() ?? 4000,
        ),
        shapeTargetRatio: $checkedConvert(
          'shapeTargetRatio',
          (v) => (v as num?)?.toDouble() ?? 0.3,
        ),
        calcWrongRatio: $checkedConvert(
          'calcWrongRatio',
          (v) => (v as num?)?.toDouble() ?? 0.4,
        ),
        shapeKey: $checkedConvert('shapeKey', (v) => v as String? ?? 'space'),
        calcKey: $checkedConvert('calcKey', (v) => v as String? ?? 'f'),
        $type: $checkedConvert('generatorId', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$MultitaskParamsToJson(MultitaskParams instance) =>
    <String, dynamic>{
      'durationSec': instance.durationSec,
      'trackingSpeed': instance.trackingSpeed,
      'trackingNoise': instance.trackingNoise,
      'shapeIntervalMs': instance.shapeIntervalMs,
      'calcIntervalMs': instance.calcIntervalMs,
      'shapeTargetRatio': instance.shapeTargetRatio,
      'calcWrongRatio': instance.calcWrongRatio,
      'shapeKey': instance.shapeKey,
      'calcKey': instance.calcKey,
      'generatorId': instance.$type,
    };

P1MathWordProblemsParams _$P1MathWordProblemsParamsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('P1MathWordProblemsParams', json, ($checkedConvert) {
  final val = P1MathWordProblemsParams(
    count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 30),
    answerMode: $checkedConvert(
      'answerMode',
      (v) => $enumDecodeNullable(_$P1AnswerModeEnumMap, v) ?? P1AnswerMode.mcq,
    ),
    maxSteps: $checkedConvert('maxSteps', (v) => (v as num?)?.toInt() ?? 3),
    maxOperand: $checkedConvert(
      'maxOperand',
      (v) => (v as num?)?.toInt() ?? 100,
    ),
    $type: $checkedConvert('generatorId', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$P1MathWordProblemsParamsToJson(
  P1MathWordProblemsParams instance,
) => <String, dynamic>{
  'count': instance.count,
  'answerMode': _$P1AnswerModeEnumMap[instance.answerMode]!,
  'maxSteps': instance.maxSteps,
  'maxOperand': instance.maxOperand,
  'generatorId': instance.$type,
};

const _$P1AnswerModeEnumMap = {
  P1AnswerMode.mcq: 'mcq',
  P1AnswerMode.numeric: 'numeric',
};

P1TangramParams _$P1TangramParamsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('P1TangramParams', json, ($checkedConvert) {
  final val = P1TangramParams(
    count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 24),
    pieceCount: $checkedConvert('pieceCount', (v) => (v as num?)?.toInt() ?? 7),
    mode: $checkedConvert(
      'mode',
      (v) =>
          $enumDecodeNullable(_$TangramModeEnumMap, v) ?? TangramMode.compose,
    ),
    $type: $checkedConvert('generatorId', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$P1TangramParamsToJson(P1TangramParams instance) =>
    <String, dynamic>{
      'count': instance.count,
      'pieceCount': instance.pieceCount,
      'mode': _$TangramModeEnumMap[instance.mode]!,
      'generatorId': instance.$type,
    };

const _$TangramModeEnumMap = {
  TangramMode.compose: 'compose',
  TangramMode.countOccurrences: 'count_occurrences',
};

P1AttentionSustainedParams _$P1AttentionSustainedParamsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('P1AttentionSustainedParams', json, ($checkedConvert) {
  final val = P1AttentionSustainedParams(
    seriesCount: $checkedConvert(
      'seriesCount',
      (v) => (v as num?)?.toInt() ?? 3,
    ),
    itemsPerSeries: $checkedConvert(
      'itemsPerSeries',
      (v) => (v as num?)?.toInt() ?? 5,
    ),
    stimulusMs: $checkedConvert(
      'stimulusMs',
      (v) => (v as num?)?.toInt() ?? 500,
    ),
    answerWindowMs: $checkedConvert(
      'answerWindowMs',
      (v) => (v as num?)?.toInt() ?? 3000,
    ),
    targetRatio: $checkedConvert(
      'targetRatio',
      (v) => (v as num?)?.toDouble() ?? 0.2,
    ),
    lureRatio: $checkedConvert(
      'lureRatio',
      (v) => (v as num?)?.toDouble() ?? 0.2,
    ),
    shapes: $checkedConvert(
      'shapes',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => $enumDecode(_$StimulusShapeEnumMap, e))
              .toList() ??
          const <StimulusShape>[
            StimulusShape.square,
            StimulusShape.triangle,
            StimulusShape.circle,
            StimulusShape.diamond,
          ],
    ),
    colours: $checkedConvert(
      'colours',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => $enumDecode(_$StimulusColourEnumMap, e))
              .toList() ??
          const <StimulusColour>[
            StimulusColour.blue,
            StimulusColour.red,
            StimulusColour.green,
            StimulusColour.yellow,
          ],
    ),
    $type: $checkedConvert('generatorId', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$P1AttentionSustainedParamsToJson(
  P1AttentionSustainedParams instance,
) => <String, dynamic>{
  'seriesCount': instance.seriesCount,
  'itemsPerSeries': instance.itemsPerSeries,
  'stimulusMs': instance.stimulusMs,
  'answerWindowMs': instance.answerWindowMs,
  'targetRatio': instance.targetRatio,
  'lureRatio': instance.lureRatio,
  'shapes': instance.shapes.map((e) => _$StimulusShapeEnumMap[e]!).toList(),
  'colours': instance.colours.map((e) => _$StimulusColourEnumMap[e]!).toList(),
  'generatorId': instance.$type,
};

P1ReadingFrParams _$P1ReadingFrParamsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('P1ReadingFrParams', json, ($checkedConvert) {
      final val = P1ReadingFrParams(
        passageCount: $checkedConvert(
          'passageCount',
          (v) => (v as num?)?.toInt() ?? 10,
        ),
        questionsPerPassage: $checkedConvert(
          'questionsPerPassage',
          (v) => (v as num?)?.toInt() ?? 1,
        ),
        $type: $checkedConvert('generatorId', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$P1ReadingFrParamsToJson(P1ReadingFrParams instance) =>
    <String, dynamic>{
      'passageCount': instance.passageCount,
      'questionsPerPassage': instance.questionsPerPassage,
      'generatorId': instance.$type,
    };

P1AnglesParams _$P1AnglesParamsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('P1AnglesParams', json, ($checkedConvert) {
      final val = P1AnglesParams(
        setCount: $checkedConvert('setCount', (v) => (v as num?)?.toInt() ?? 3),
        optionCount: $checkedConvert(
          'optionCount',
          (v) => (v as num?)?.toInt() ?? 9,
        ),
        maxCorrect: $checkedConvert(
          'maxCorrect',
          (v) => (v as num?)?.toInt() ?? 4,
        ),
        $type: $checkedConvert('generatorId', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$P1AnglesParamsToJson(P1AnglesParams instance) =>
    <String, dynamic>{
      'setCount': instance.setCount,
      'optionCount': instance.optionCount,
      'maxCorrect': instance.maxCorrect,
      'generatorId': instance.$type,
    };

P1GeneralEfficiencyParams _$P1GeneralEfficiencyParamsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('P1GeneralEfficiencyParams', json, ($checkedConvert) {
  final val = P1GeneralEfficiencyParams(
    count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 35),
    $type: $checkedConvert('generatorId', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$P1GeneralEfficiencyParamsToJson(
  P1GeneralEfficiencyParams instance,
) => <String, dynamic>{'count': instance.count, 'generatorId': instance.$type};

P1CountersParams _$P1CountersParamsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('P1CountersParams', json, ($checkedConvert) {
      final val = P1CountersParams(
        count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 10),
        dialsPerItem: $checkedConvert(
          'dialsPerItem',
          (v) => (v as num?)?.toInt() ?? 3,
        ),
        $type: $checkedConvert('generatorId', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$P1CountersParamsToJson(P1CountersParams instance) =>
    <String, dynamic>{
      'count': instance.count,
      'dialsPerItem': instance.dialsPerItem,
      'generatorId': instance.$type,
    };

P1CubeNetsParams _$P1CubeNetsParamsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('P1CubeNetsParams', json, ($checkedConvert) {
      final val = P1CubeNetsParams(
        phaseCount: $checkedConvert(
          'phaseCount',
          (v) => (v as num?)?.toInt() ?? 2,
        ),
        netsPerPhase: $checkedConvert(
          'netsPerPhase',
          (v) => (v as num?)?.toInt() ?? 10,
        ),
        alphabet: $checkedConvert(
          'alphabet',
          (v) =>
              $enumDecodeNullable(_$CubeNetAlphabetEnumMap, v) ??
              CubeNetAlphabet.latin,
        ),
        missingFaces: $checkedConvert(
          'missingFaces',
          (v) => (v as num?)?.toInt() ?? 2,
        ),
        includeRotationMatching: $checkedConvert(
          'includeRotationMatching',
          (v) => v as bool? ?? false,
        ),
        $type: $checkedConvert('generatorId', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$P1CubeNetsParamsToJson(P1CubeNetsParams instance) =>
    <String, dynamic>{
      'phaseCount': instance.phaseCount,
      'netsPerPhase': instance.netsPerPhase,
      'alphabet': _$CubeNetAlphabetEnumMap[instance.alphabet]!,
      'missingFaces': instance.missingFaces,
      'includeRotationMatching': instance.includeRotationMatching,
      'generatorId': instance.$type,
    };

const _$CubeNetAlphabetEnumMap = {
  CubeNetAlphabet.latin: 'latin',
  CubeNetAlphabet.runic: 'runic',
};

P1WmReverseSpanParams _$P1WmReverseSpanParamsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('P1WmReverseSpanParams', json, ($checkedConvert) {
  final val = P1WmReverseSpanParams(
    count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 10),
    minDigits: $checkedConvert('minDigits', (v) => (v as num?)?.toInt() ?? 4),
    maxDigits: $checkedConvert('maxDigits', (v) => (v as num?)?.toInt() ?? 9),
    answerWindowMs: $checkedConvert(
      'answerWindowMs',
      (v) => (v as num?)?.toInt() ?? 3500,
    ),
    $type: $checkedConvert('generatorId', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$P1WmReverseSpanParamsToJson(
  P1WmReverseSpanParams instance,
) => <String, dynamic>{
  'count': instance.count,
  'minDigits': instance.minDigits,
  'maxDigits': instance.maxDigits,
  'answerWindowMs': instance.answerWindowMs,
  'generatorId': instance.$type,
};

P1WmCalcBackParams _$P1WmCalcBackParamsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('P1WmCalcBackParams', json, ($checkedConvert) {
      final val = P1WmCalcBackParams(
        stageCount: $checkedConvert(
          'stageCount',
          (v) => (v as num?)?.toInt() ?? 4,
        ),
        calcsPerStage: $checkedConvert(
          'calcsPerStage',
          (v) => (v as num?)?.toInt() ?? 20,
        ),
        $type: $checkedConvert('generatorId', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$P1WmCalcBackParamsToJson(P1WmCalcBackParams instance) =>
    <String, dynamic>{
      'stageCount': instance.stageCount,
      'calcsPerStage': instance.calcsPerStage,
      'generatorId': instance.$type,
    };

P1RavenMatricesParams _$P1RavenMatricesParamsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('P1RavenMatricesParams', json, ($checkedConvert) {
  final val = P1RavenMatricesParams(
    count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 30),
    grid: $checkedConvert(
      'grid',
      (v) => v == null
          ? const GridSize(rows: 3, cols: 3)
          : GridSize.fromJson(v as Map<String, dynamic>),
    ),
    optionCount: $checkedConvert(
      'optionCount',
      (v) => (v as num?)?.toInt() ?? 8,
    ),
    $type: $checkedConvert('generatorId', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$P1RavenMatricesParamsToJson(
  P1RavenMatricesParams instance,
) => <String, dynamic>{
  'count': instance.count,
  'grid': instance.grid.toJson(),
  'optionCount': instance.optionCount,
  'generatorId': instance.$type,
};

P1MentalArithmeticParams _$P1MentalArithmeticParamsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('P1MentalArithmeticParams', json, ($checkedConvert) {
  final val = P1MentalArithmeticParams(
    count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 10),
    answerMode: $checkedConvert(
      'answerMode',
      (v) =>
          $enumDecodeNullable(_$MentalArithmeticAnswerModeEnumMap, v) ??
          MentalArithmeticAnswerMode.freeNumeric,
    ),
    maxOperand: $checkedConvert(
      'maxOperand',
      (v) => (v as num?)?.toInt() ?? 100,
    ),
    $type: $checkedConvert('generatorId', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$P1MentalArithmeticParamsToJson(
  P1MentalArithmeticParams instance,
) => <String, dynamic>{
  'count': instance.count,
  'answerMode': _$MentalArithmeticAnswerModeEnumMap[instance.answerMode]!,
  'maxOperand': instance.maxOperand,
  'generatorId': instance.$type,
};

const _$MentalArithmeticAnswerModeEnumMap = {
  MentalArithmeticAnswerMode.freeNumeric: 'free_numeric',
  MentalArithmeticAnswerMode.equation: 'equation',
  MentalArithmeticAnswerMode.smallestInterval: 'smallest_interval',
  MentalArithmeticAnswerMode.allIntervals: 'all_intervals',
};

P1PsychomotorParams _$P1PsychomotorParamsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('P1PsychomotorParams', json, ($checkedConvert) {
      final val = P1PsychomotorParams(
        phaseCount: $checkedConvert(
          'phaseCount',
          (v) => (v as num?)?.toInt() ?? 6,
        ),
        phaseDurationSec: $checkedConvert(
          'phaseDurationSec',
          (v) => (v as num?)?.toInt() ?? 180,
        ),
        calcIntervalSec: $checkedConvert(
          'calcIntervalSec',
          (v) => (v as num?)?.toInt() ?? 12,
        ),
        $type: $checkedConvert('generatorId', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'generatorId'});

Map<String, dynamic> _$P1PsychomotorParamsToJson(
  P1PsychomotorParams instance,
) => <String, dynamic>{
  'phaseCount': instance.phaseCount,
  'phaseDurationSec': instance.phaseDurationSec,
  'calcIntervalSec': instance.calcIntervalSec,
  'generatorId': instance.$type,
};
