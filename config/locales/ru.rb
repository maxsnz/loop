# encoding: utf-8

{
  :ru => {
    :i18n => {
      :plural => {
        :rule => lambda { |n|
          if n % 10 == 1 && n % 100 != 11
            :one
          elsif [2, 3, 4].include?(n % 10) &&
              ![12, 13, 14].include?(n % 100)
            :few
          elsif n % 10 == 0 || [5, 6, 7, 8, 9].include?(n % 10) ||
              [11, 12, 13, 14].include?(n % 100)
            :many
          else
            :other
          end
        }
      },
#
# map cyrillic characters to latin:
# 
      :transliterate => {
        :rule => {
          "а"=>"a","б"=>"b","в"=>"v","г"=>"g","д"=>"d",
          "е"=>"e","ё"=>"yo","ж"=>"zh",
          "з"=>"z","и"=>"i","й"=>"y","к"=>"k","л"=>"l",
          "м"=>"m","н"=>"n","о"=>"o","п"=>"p","р"=>"r",
          "с"=>"s","т"=>"t","у"=>"ou","ф"=>"f","х"=>"h",
          "ц"=>"ts","ч"=>"ch","ш"=>"sh","щ"=>"sch","ъ"=>"'",
          "ы"=>"y","ь"=>"'","э"=>"e","ю"=>"yu","я"=>"ya",
          "А"=>"A","Б"=>"B","В"=>"V","Г"=>"G","Д"=>"D",
          "Е"=>"E","Ё"=>"YO","Ж"=>"ZH",
          "З"=>"Z","И"=>"I","Й"=>"Y","К"=>"K","Л"=>"L",
          "М"=>"M","Н"=>"N","О"=>"O","П"=>"P","Р"=>"R",
          "С"=>"S","Т"=>"T","У"=>"OU","Ф"=>"F","Х"=>"H",
          "Ц"=>"TS","Ч"=>"CH","Ш"=>"SH","Щ"=>"SCH","Ъ"=>"'",
          "Ы"=>"Y","Ь"=>"'","Э"=>"E","Ю"=>"YU","Я"=>"YA",
          "№"=>"#"
        }
      }
    }
  }
}
