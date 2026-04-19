import 'package:json_annotation/json_annotation.dart';

part 'standing.g.dart';

@JsonSerializable()
class Standing {
  final int position;
  final StandingTeam team;
  final int playedGames;
  final int won;
  final int draw;
  final int lost;
  final int points;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;

  Standing({
    required this.position,
    required this.team,
    required this.playedGames,
    required this.won,
    required this.draw,
    required this.lost,
    required this.points,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
  });

  factory Standing.fromJson(Map<String, dynamic> json) =>
      _$StandingFromJson(json);
  Map<String, dynamic> toJson() => _$StandingToJson(this);
}

@JsonSerializable()
class StandingTeam {
  final int id;
  final String name;
  final String shortName;
  final String? crest;

  StandingTeam({
    required this.id,
    required this.name,
    required this.shortName,
    this.crest,
  });

  factory StandingTeam.fromJson(Map<String, dynamic> json) =>
      _$StandingTeamFromJson(json);
  Map<String, dynamic> toJson() => _$StandingTeamToJson(this);
}
