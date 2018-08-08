class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper

  CONTROLLER = ApplicationController.new
  CONTROLLER.instance_eval { @_request = Hashie::Mash.new }
  attr_accessor :output_buffer

  FILES = %w[].freeze
  FILES.each do |file|
    define_method "#{file}_parts" do |name, opts = {}|
      CONTROLLER.render_to_string(partial: "form_builder/#{file}", locals: { col: name, f: self, opts: opts })
    end
  end
end
