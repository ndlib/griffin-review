class RequestsController  < ApplicationController

  def index
    check_admin_permission!
    @admin_request_listing = AdminReserveList.new(self)

#    respond_to do | format |
#      format.html
#      format.json {
#        render :text => json
#      }
#    end
  end


  def show
    check_admin_permission!
    @admin_reserve = AdminReserve.new(current_user, self, params)
  end


  def json
    '{
  "sEcho": 1,
  "iTotalRecords": "57",
  "iTotalDisplayRecords": "57",
  "aaData": [
    [
      "Gecko",
      "Firefox 1.0",
      "Win 98+ / OSX.2+",
      "1.7",
      "A",
      "a",
      "b"
    ],
    [
      "Gecko",
      "Firefox 1.5",
      "Win 98+ / OSX.2+",
      "1.8",
      "A",
      "a",
      "b"
    ],
    [
      "Gecko",
      "Firefox 2.0",
      "Win 98+ / OSX.2+",
      "1.8",
      "A",
      "a",
      "b"
    ],
    [
      "Gecko",
      "Firefox 3.0",
      "Win 2k+ / OSX.3+",
      "1.9",
      "A",
      "a",
      "b"
    ],
    [
      "Gecko",
      "Camino 1.0",
      "OSX.2+",
      "1.8",
      "A",
      "a",
      "b"
    ],
    [
      "Gecko",
      "Camino 1.5",
      "OSX.3+",
      "1.8",
      "A",
      "a",
      "b"
    ],
    [
      "Gecko",
      "Netscape 7.2",
      "Win 95+ / Mac OS 8.6-9.2",
      "1.7",
      "A",
      "a",
      "b"
    ],
    [
      "Gecko",
      "Netscape Browser 8",
      "Win 98SE+",
      "1.7",
      "A",
      "a",
      "b"
    ],
    [
      "Gecko",
      "Netscape Navigator 9",
      "Win 98+ / OSX.2+",
      "1.8",
      "A",
      "a",
      "b"
    ],
    [
      "Gecko",
      "Mozilla 1.0",
      "Win 95+ / OSX.1+",
      "1",
      "A",
      "a",
      "b"
    ]
  ]
}
'

  end
end
