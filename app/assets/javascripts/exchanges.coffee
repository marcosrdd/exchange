$(document).ready ->

  convert = -> 
    if !$("#amount").val() 
      $('#result').val("")
      return false;

    if $('form').attr('action') == '/convert'
      $.ajax '/convert',
          type: 'GET'
          dataType: 'json'
          data: {
                  source_currency: $("#source_currency").val(),
                  target_currency: $("#target_currency").val(),
                  amount: $("#amount").val()
                }
          error: (jqXHR, textStatus, errorThrown) ->
            alert textStatus
          success: (data, text, jqXHR) ->
            $('#result').val(data.value.toFixed 2)
        return false;
  
  $('#amount').keyup (e) -> convert();
  $('#amount').click (e) -> convert();
  
  $('#reverse').click (e) ->
    source_currency = $("#source_currency").val()
    target_currency = $("#target_currency").val()
    $("#source_currency").val(target_currency)
    $("#target_currency").val(source_currency)
    convert()
    return false;

  $('#toggle').change (e) -> 
    if $(@).prop('checked')
      $('body').addClass('night');
    else
      $('body').removeClass('night');
    return  
  return
