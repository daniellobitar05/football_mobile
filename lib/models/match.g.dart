// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) => Match(
      id: (json['id'] as num).toInt(),
      utcDate: json['utcDate'] as String,
      status: json['status'] as String,
      stage: json['stage'] as String?,
      homeTeam: Team.fromJson(json['homeTeam'] as Map<String, dynamic>),
      awayTeam: Team.fromJson(json['awayTeam'] as Map<String, dynamic>),
      score: Score.fromJson(json['score'] as Map<String, dynamic>),
      competition:
          Competition.fromJson(json['competition'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
      'id': instance.id,
      'utcDate': instance.utcDate,
      'status': instance.status,
      'stage': instance.stage,
      'homeTeam': instance.homeTeam,
      'awayTeam': instance.awayTeam,
      'score': instance.score,
      'competition': instance.competition,
    };

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      crest: json['crest'] as String?,
    );

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shortName': instance.shortName,
      'crest': instance.crest,
    };

Score _$ScoreFromJson(Map<String, dynamic> json) => Score(
      winner: json['winner'] as String?,
      fullTimeScore: json['fullTime'] == null
          ? null
          : ScoreDetails.fromJson(json['fullTime'] as Map<String, dynamic>),
      halfTimeScore: json['halfTime'] == null
          ? null
          : ScoreDetails.fromJson(json['halfTime'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScoreToJson(Score instance) => <String, dynamic>{
      'winner': instance.winner,
      'fullTime': instance.fullTimeScore,
      'halfTime': instance.halfTimeScore,
    };

ScoreDetails _$ScoreDetailsFromJson(Map<String, dynamic> json) => ScoreDetails(
      home: (json['home'] as num).toInt(),
      away: (json['away'] as num).toInt(),
    );

Map<String, dynamic> _$ScoreDetailsToJson(ScoreDetails instance) =>
    <String, dynamic>{
      'home': instance.home,
      'away': instance.away,
    };

Competition _$CompetitionFromJson(Map<String, dynamic> json) => Competition(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      code: json['code'] as String,
      emblem: json['emblem'] as String?,
    );

Map<String, dynamic> _$CompetitionToJson(Competition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'emblem': instance.emblem,
    };
