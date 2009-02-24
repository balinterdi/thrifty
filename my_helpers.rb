require "ruby-debug"

module Sinatra::MyHelpers

  def self.included(base)
    base.class_eval do
      include Flash
      include Partial
    end
  end

  module Flash
    # NOTE: Yes, at one point I peaked at how Rails
    # implements the flash and now I pretty much
    # try to implement a rudimentary version of it.
    class FlashHash < Hash
      def initialize
        @keys_to_keep = []
      end

      def []=(key, value)
        keep(key)
        super
      end

      def keep(key)
        # that key should be kept for the next action to be shown
        @keys_to_keep << key
      end

      def reset
        self.keys.each { |k| delete(k) unless @keys_to_keep.include?(k) }
        # flash messages are only preserved for the next action
        @keys_to_keep = []
      end

    end

    def flash
      if !defined?(@_flash)
        @_flash = (session["flash"] ||= FlashHash.new)
      end
      @_flash
    end

    def reset_flash
      @_flash.reset if defined?(@_flash)
      session.delete("flash")
    end
  end

  # taken -and slightly modified- from http://sinatra.github.com/book.html#partials
  module Partial

    def partial(template, *args)
      options = args.last.is_a?(::Hash) ? args.pop : {}
      options.merge!(:layout => false)
      if collection = options.delete(:collection) then
        collection.inject([]) do |buffer, member|
          buffer << haml("_#{template}".to_sym, options.merge(
                                    :layout => false,
                                    :locals => {template.to_sym => member} # :todo = <Todo:3e345>
                                  )
                       )
        end.join("\n")
      else
        haml(template, options)
      end
    end
  end


end