FactoryGirl.define do
  factory :log do
    initialize_with { new(attributes) }
    factory :log_sw_cert do
      type 'sw_cert'
      # rubocop:disable Metrics/LineLength
      status [
        ['2015년 8월', '22', 'Advanced 검정   09:00 ~ 12:00 ( C/C++/JAVA )', '인재개발원(서천)', '잔여석 : 0'],
        ['2015년 8월', '22', 'Advanced 검정   09:00 ~ 12:00 ( C/C++/JAVA )', '첨단기술연수소(영통) (외국인 전용)', '잔여석 : 0'],
        ['2015년 8월', '29', 'Advanced 검정   14:30 ~ 17:30 ( C/C++/JAVA )', '첨단기술연수소(영통)', '잔여석 : 0'],
        ['2015년 8월', '29', 'Professional 검정   09:00 ~ 13:00 ( C/C++/JAVA )', '첨단기술연수소(영통)', '잔여석 : 0'],
        ['2015년 8월', '29', 'Professional 검정   09:00 ~ 13:00 ( C/C++/JAVA )', '첨단기술연수소(영통) (외국인 전용)', '잔여석 : 0'],
        ['2015년 9월', '12', 'Advanced 검정   09:00 ~ 12:00 ( C/C++/JAVA )', '인재개발원(서천)', '잔여석 : 0'],
        ['2015년 9월', '12', 'Professional 검정   13:30 ~ 17:30 ( C/C++/JAVA )', '인재개발원(서천)', '잔여석 : 0'],
        ['2015년 9월', '19', 'Advanced 검정   13:30 ~ 16:30 ( C/C++/JAVA )', '스마트시티(구미)', '잔여석 : 0']
      ]
      # rubocop:enable Metrics/LineLength
    end
  end
end
