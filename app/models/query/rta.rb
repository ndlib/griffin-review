class Rta

  def initialize(rta_id, key = false)
    @items = search(rta_id, key)
  end


  def items
    @items
  end


  private

    def search(rta_id, key = false)
      res = API::PrintReserves.rta(rta_id, key).collect { | d | RtaHolding.new(d) }

      res.sort { | a,b | a.sort <=> b.sort }
    end


    class RtaHolding

      def initialize(data)
        @data = data
      end


      def status
        if available?
          "available"
        else
          "checked out"
        end
      end


      def available?
        due_at.empty?
      end

      def sort
        reserve_holding? ? 1 : 2
      end


      def reserve_holding?
        @data['loan_type'] == '2 Hour Loan' || location.downcase.include?('reserve')
      end


      def location
        "#{@data['secondary_location']} - #{@data['primary_location']}"
      end


      def due_at
        if @data['due_date'].present?
          "#{@data['due_date']} - #{@data['due_time']}"
        else
          ""
        end
      end

    end

end
