require 'rails_helper'

RSpec.describe 'setting/edit_sw_cert' do
  it 'works' do
    sign_in create(:user)

    # rubocop:disable Metrics/LineLength
    assign(
      :sw_cert_setting_checkbox,
      [
        [['2015년 8월', '22', 'Advanced 검정   09:00 ~ 12:00 ( C/C++/JAVA )', '인재개발원(서천)'], true],
        [['2015년 8월', '22', 'Advanced 검정   09:00 ~ 12:00 ( C/C++/JAVA )', '첨단기술연수소(영통) (외국인 전용)'], false],
        [['2015년 8월', '29', 'Advanced 검정   14:30 ~ 17:30 ( C/C++/JAVA )', '첨단기술연수소(영통)'], true],
        [['2015년 8월', '29', 'Professional 검정   09:00 ~ 13:00 ( C/C++/JAVA )', '첨단기술연수소(영통)'], true],
        [['2015년 8월', '29', 'Professional 검정   09:00 ~ 13:00 ( C/C++/JAVA )', '첨단기술연수소(영통) (외국인 전용)'], false],
        [['2015년 9월', '12', 'Advanced 검정   09:00 ~ 12:00 ( C/C++/JAVA )', '인재개발원(서천)'], true],
        [['2015년 9월', '12', 'Professional 검정   13:30 ~ 17:30 ( C/C++/JAVA )', '인재개발원(서천)'], true],
        [['2015년 9월', '19', 'Advanced 검정   13:30 ~ 16:30 ( C/C++/JAVA )', '스마트시티(구미)'], false]
      ]
    )
    # rubocop:enable Metrics/LineLength

    render
  end
end
