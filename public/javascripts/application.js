jQuery(function ($) {
'use strict';

  function onChange (event) {

    var element = $(event.target),
        ajaxSettings = {
          url: window.document.location.pathname
        },
        data = ajaxSettings.data = {};

    data.name = element
      .parents('tr')
      .find('td:nth(0) a').text().trim();

    data.value = element.val();
    data.id = element.attr('data-message-id');
    ajaxSettings.type = 'POST';

    if (data.id) {
      ajaxSettings.url += '/' + data.id;
      ajaxSettings.type = 'PUT';
    }

    ajaxSettings.success = function (data) {
      var tr = element.parents('tr');
      tr.attr('data-state', 'ok');
      tr.next().find('input').focus();
    };

    $.ajax(ajaxSettings);
  }

  $("table.messages").delegate("input", "change", onChange);
});
