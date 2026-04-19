import 'package:json_annotation/json_annotation.dart';

part 'match.g.dart';

@JsonSerializable()
class Match {
  final int id;
  final String utcDate;
  final String status;
  final String? stage;
  final Team homeTeam;
  final Team awayTeam;
  final Score score;
  final Competition competition;

  Match({
    required this.id,
    required this.utcDate,
    required this.status,
    this.stage,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    required this.competition,
  });

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
  Map<String, dynamic> toJson() => _$MatchToJson(this);

  bool get isLive => status == 'LIVE' || status == 'IN_PLAY';
  bool get isFinished => status == 'FINISHED';
  bool get isScheduled => status == 'TIMED' || status == 'SCHEDULED';
}

@JsonSerializable()
class Team {
  final int id;
  final String name;
  final String shortName;
  final String? crest;

  Team({
    required this.id,
    required this.name,
    required this.shortName,
    this.crest,
  });

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}

@JsonSerializable()
class Score {
  final String? winner;
  @JsonKey(name: 'fullTime')
  final ScoreDetails? fullTimeScore;
  @JsonKey(name: 'halfTime')
  final ScoreDetails? halfTimeScore;

  Score({
    this.winner,
    this.fullTimeScore,
    this.halfTimeScore,
  });

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);
  Map<String, dynamic> toJson() => _$ScoreToJson(this);

  int get homeGoals => fullTimeScore?.home ?? 0;
  int get awayGoals => fullTimeScore?.away ?? 0;
}

@JsonSerializable()
class ScoreDetails {
  final int home;
  final int away;

  ScoreDetails({
    required this.home,
    required this.away,
  });

  factory ScoreDetails.fromJson(Map<String, dynamic> json) =>
      _$ScoreDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ScoreDetailsToJson(this);
}

@JsonSerializable()
class Competition {
  final int id;
  final String name;
  final String code;
  final String? emblem;

  Competition({
    required this.id,
    required this.name,
    required this.code,
    this.emblem,
  });

  factory Competition.fromJson(Map<String, dynamic> json) =>
      _$CompetitionFromJson(json);
  Map<String, dynamic> toJson() => _$CompetitionToJson(this);
}
