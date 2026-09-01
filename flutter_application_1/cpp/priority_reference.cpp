// Oruro Digital - referencia pequena en C++.
// Este archivo NO forma parte del build de Flutter.
// Sirve para explicar el algoritmo de prioridad usando C++ sin romper la app.

#include <algorithm>
#include <iostream>
#include <string>
#include <unordered_set>
#include <vector>

struct Report {
  std::string reporter_id;
  int urgency;
  int age_days;
  double trust;
  bool has_photo;
  bool flagged;
  bool near_school;
  bool near_transport;
  bool high_circulation;
};

int calculatePriority(const std::vector<Report>& reports) {
  if (reports.empty()) {
    return 0;
  }

  std::unordered_set<std::string> unique_reporters;
  int urgency_sum = 0;
  int oldest_age = 0;
  int photo_count = 0;
  int flagged_count = 0;
  double trust_sum = 0.0;
  bool near_school = false;
  bool near_transport = false;
  bool high_circulation = false;

  for (const Report& report : reports) {
    unique_reporters.insert(report.reporter_id);
    urgency_sum += report.urgency;
    oldest_age = std::max(oldest_age, report.age_days);
    trust_sum += report.trust;

    if (report.has_photo) {
      photo_count++;
    }
    if (report.flagged) {
      flagged_count++;
    }

    near_school = near_school || report.near_school;
    near_transport = near_transport || report.near_transport;
    high_circulation = high_circulation || report.high_circulation;
  }

  const double report_count = static_cast<double>(reports.size());
  const double unique_count = static_cast<double>(unique_reporters.size());
  const double average_urgency = urgency_sum / report_count;
  const double average_trust = trust_sum / report_count;

  const double report_score = std::min(35.0, (report_count * 4.5) + (unique_count * 3.0));
  const double urgency_score = (average_urgency / 5.0) * 22.0;
  const double age_score = std::min(18.0, std::min(oldest_age, 60) * 2.2);
  const double context_score =
      (near_school ? 12.0 : 0.0) +
      (near_transport ? 8.0 : 0.0) +
      (high_circulation ? 8.0 : 0.0);
  const double evidence_score = (photo_count / report_count) * 7.0;
  const double trust_penalty = average_trust < 0.55 ? 10.0 : (average_trust < 0.70 ? 5.0 : 0.0);
  const double flagged_penalty = flagged_count * 5.0;
  const double single_reporter_penalty = reports.size() >= 3 && unique_reporters.size() == 1 ? 16.0 : 0.0;

  const int priority = static_cast<int>(
      report_score +
      urgency_score +
      age_score +
      context_score +
      evidence_score -
      trust_penalty -
      flagged_penalty -
      single_reporter_penalty);

  return std::clamp(priority, 0, 100);
}

int main() {
  const std::vector<Report> problem_reports = {
      {"cit-001", 5, 12, 0.82, true, false, true, true, true},
      {"cit-002", 5, 10, 0.76, true, false, true, true, true},
      {"cit-003", 4, 8, 0.88, true, false, true, true, true},
  };

  std::cout << "Prioridad calculada: "
            << calculatePriority(problem_reports)
            << "%\n";

  return 0;
}
