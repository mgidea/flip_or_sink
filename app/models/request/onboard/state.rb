module Request
  module Onboard
    class State < Base
      def url
        @url ||= ONBOARD_CONFIG["states_url"]
      end

      def import_states
        response = get
        if response&.ok?
          if states = response.parsed_response.dig("response", "result", "package", "item")
            ::State.import_states(states)
          end
        end
      end
    end
  end
end
