module TijuanaClient
  class Base < Vertebrae::Model
    def normalized_base_path
      "api/#{base_path}/"
    end
  end
end