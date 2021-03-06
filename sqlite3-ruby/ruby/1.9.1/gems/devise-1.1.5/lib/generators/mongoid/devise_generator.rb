require 'generators/devise/orm_helpers'

module Mongoid
  module Generators
    class DeviseGenerator < Rails::Generators::NamedBase
      include Devise::Generators::OrmHelpers

      def generate_model
        invoke "mongoid:model", [name] unless model_exists?
      end

      def inject_devise_content
        inject_into_file model_path, model_contents, :after => "include Mongoid::Document\n"
      end
    end
  end
end