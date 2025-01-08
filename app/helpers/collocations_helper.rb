# frozen_string_literal: true

module CollocationsHelper
  def mi(count_1, count_2, count_both, all_count)
    freq_1 = count_1.to_d / all_count.to_d
    freq_2 = count_2.to_d / all_count.to_d
    freq_both = count_both.to_d / all_count.to_d
    Math.log2(freq_both / (freq_1 * freq_2)).round(2)
  end

  def log_di(count_1, count_2, count_both)
    (14 + Math.log2((2.0 * count_both.to_d) / (count_1.to_d + count_2.to_d))).round(2)
  end
end
