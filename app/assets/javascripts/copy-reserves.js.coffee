jQuery ($) ->

  $(document).on 'change', ".copy-reserve",  ->
    txt = $(this).parents("tr").find(".title").text()
    input = "<input type=\"hidden\" name=\"reserve_ids[]\" value=\"#{$(this).val()}\">"
    if $("#copy-overlay ul li:contains(" + txt + ")").size() > 0
      $("#copy-overlay ul li:contains(" + txt + ")").remove()
    else
      row = $("<li>" + txt + "</li>")
      $("#copy-overlay ul").append row
      $("#copy-overlay form").append input
      row.effect "highlight", {}, 3000
    if $("#copy-overlay ul li").size() is 0
      $("#copy-overlay").hide()
    else
      $("#copy-overlay").show()

  $("#copy-overlay .cancel").click ->
    $("#copy-overlay ul li").remove()
    $("#copy-overlay").hide()
    $(".copy-reserve").each ->
      @checked = false

    false
