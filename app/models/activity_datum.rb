class ActivityDatum < ApplicationRecord

  validates :activity, inclusion: { in: %w[driving cultivating repairing slacking_off awol] }

end
