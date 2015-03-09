$(document).ready(function ()
{
  prettyPrint();

  function getURLP(name)
  {
    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20')) || null;
  }
  if (getURLP("q")) {
    // Tipue Search activation
    $('#tipue_search_input').tipuesearch({
      'mode': 'json',
      'contentLocation': '/search_content.json.gz'
    });
  }

});


