// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Standing _$StandingFromJson(Map<String, dynamic> json) => Standing(
      position: (json['position'] as num).toInt(),
      team: StandingTeam.fromJson(json['team'] as Map<String, dynamic>),
      playedGames: (json['playedGames'] as num).toInt(),
      won: (json['won'] as num).toInt(),
      draw: (json['draw'] as num).toInt(),
      lost: (json['lost'] as num).toInt(),
      points: (json['points'] as num).toInt(),
      goalsFor: (json['goalsFor'] as num).toInt(),
      goalsAgainst: (json['goalsAgainst'] as num).toInt(),
      goalDifference: (json['goalDifference'] as num).toInt(),
    );

Map<String, dynamic> _$StandingToJson(Standing instance) => <String, dynamic>{
      'position': instance.position,
      'team': instance.team,
      'playedGames': instance.playedGames,
      'won': instance.won,
      'draw': instance.draw,
      'lost': instance.lost,
      'points': instance.points,
      'goalsFor': instance.goalsFor,
      'goalsAgainst': instance.goalsAgainst,
      'goalDifference': instance.goalDifference,
    };

StandingTeam _$StandingTeamFromJson(Map<String, dynamic> json) => StandingTeam(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      crest: json['crest'] as String?,
    );

Map<String, dynamic> _$StandingTeamToJson(StandingTeam instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shortName': instance.shortName,
      'crest': instance.crest,
    };
