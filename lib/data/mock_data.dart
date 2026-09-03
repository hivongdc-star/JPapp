class SkillSnapshot {
  const SkillSnapshot({
    required this.name,
    required this.grade,
    required this.score,
    required this.iconCodePoint,
  });

  final String name;
  final String grade;
  final int score;
  final int iconCodePoint;
}

class RankEntry {
  const RankEntry({
    required this.rank,
    required this.name,
    required this.score,
    this.isCurrentUser = false,
  });

  final int rank;
  final String name;
  final int score;
  final bool isCurrentUser;
}

const skills = [
  SkillSnapshot(name: 'Listening', grade: 'A', score: 782, iconCodePoint: 0xe3f3),
  SkillSnapshot(name: 'Speaking', grade: 'B', score: 641, iconCodePoint: 0xe029),
  SkillSnapshot(name: 'Reading', grade: 'A+', score: 846, iconCodePoint: 0xe865),
  SkillSnapshot(name: 'Writing', grade: 'B+', score: 693, iconCodePoint: 0xe3c9),
];

const nearbyRanks = [
  RankEntry(rank: 126, name: 'An', score: 12610),
  RankEntry(rank: 127, name: 'Kaito', score: 12590),
  RankEntry(rank: 128, name: 'YOU', score: 12250, isCurrentUser: true),
  RankEntry(rank: 129, name: 'Haru', score: 12180),
];

const weeklyTop = [
  RankEntry(rank: 1, name: 'Takumi', score: 15840),
  RankEntry(rank: 2, name: 'Minato', score: 15210),
  RankEntry(rank: 3, name: 'Yuki', score: 14980),
  RankEntry(rank: 128, name: 'YOU', score: 12250, isCurrentUser: true),
];
