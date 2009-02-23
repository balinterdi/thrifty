require "ruby-debug"

module Sinatra::MyHelpers

  def self.included(base)
    base.class_eval do
      include Flash
      include Partial
    end
  end

  module Flash

    def flash
      if !session.key?("flash")
        session["flash"] = Hash.new
      end
      session["flash"]
    end

    def reset_flash
      session.delete("flash")
    end
  end

  # taken -and slightly modified- from http://sinatra.github.com/book.html#partials
  module Partial

    def partial(template, *args)
      options = args.last.is_a?(::Hash) ? args.pop : {}
      options.merge!(:layout => false)
      template_name = "_#{template}".to_sym
      if collection = options.delete(:collection) then
        collection.inject([]) do |buffer, member|
          buffer << haml(template_name, options.merge(
                                    :layout => false,
                                    :locals => {template.to_sym => member} # :todo = <Todo:3e345>
                                  )
                       )
        end.join("\n")
      else
        haml(template_name, options)
      end
    end
  end


end