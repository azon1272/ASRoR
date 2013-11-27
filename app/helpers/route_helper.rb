require 'net/http'
require 'uri'
module RouteHelper
  def get_information(page_title)
      #урл запроса формируем
      url = "http://maps.googleapis.com/maps/api/distancematrix/json?origins=Kyiv&destinations=Paris&mode=driving&language=fr-Fr&sensor=false"
      uri = URI.parse(url)    
      # посылаем запрос и получаем ответ, если все пройдет хорошо придет код 200 и ОК (<Net::HTTPOK 200 OK readbody=true>)
      response = Net::HTTP.get_response(uri)
      # для просмотра тела ответа
      content = response.body
      puts content
    end
end
