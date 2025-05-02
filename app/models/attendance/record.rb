module Attendance
  class Record < ApplicationRecord
    belongs_to :user
    belongs_to :shift

    # ✅ Analyze late coming after creation
    after_create :analyze_late_coming

    private

    def analyze_late_coming
      Attendance::LateComingAnalyzer.new(self).analyze
    end
  end
end
