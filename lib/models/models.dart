class Disease {
  final String id;
  final String name;
  final String solution;

  Disease({required this.id, required this.name, required this.solution});
}

class Symptom {
  final String id;
  final String name;

  Symptom({required this.id, required this.name});
}

class Rule {
  final String diseaseId;
  final String symptomId;
  final double expertWeight; // CF Pakar

  Rule({required this.diseaseId, required this.symptomId, required this.expertWeight});
}

class UserChoice {
  final String label;
  final double value; // CF User

  UserChoice(this.label, this.value);
}