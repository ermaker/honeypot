FactoryGirl.define do
  factory :user do
    email 'a@a.com'
    password '12345678'
    token_type 'Bearer'
    access_token 'o.JpVq5V1AWSYRynNkAx6QluAxHpV5cuah'
    # rubocop:disable Metrics/LineLength
    sw_cert_setting [
      ['2015년 8월', '22', 'Advanced 검정   09:00 ~ 12:00 ( C/C++/JAVA )', '인재개발원(서천)'],
      ['2015년 8월', '22', 'Advanced 검정   09:00 ~ 12:00 ( C/C++/JAVA )', '첨단기술연수소(영통) (외국인 전용)'],
      ['2015년 8월', '29', 'Advanced 검정   14:30 ~ 17:30 ( C/C++/JAVA )', '첨단기술연수소(영통)'],
      ['2015년 8월', '29', 'Professional 검정   09:00 ~ 13:00 ( C/C++/JAVA )', '첨단기술연수소(영통)'],
      ['2015년 8월', '29', 'Professional 검정   09:00 ~ 13:00 ( C/C++/JAVA )', '첨단기술연수소(영통) (외국인 전용)'],
      ['2015년 9월', '12', 'Advanced 검정   09:00 ~ 12:00 ( C/C++/JAVA )', '인재개발원(서천)'],
      ['2015년 9월', '12', 'Professional 검정   13:30 ~ 17:30 ( C/C++/JAVA )', '인재개발원(서천)'],
      ['2015년 9월', '19', 'Advanced 검정   13:30 ~ 16:30 ( C/C++/JAVA )', '스마트시티(구미)']
    ]
    # rubocop:enable Metrics/LineLength
  end
end
