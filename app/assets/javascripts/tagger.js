$(document).ready(function() {
  var COOKIE_NAME = 'tags';

  var $tags = $('.tagger .tags');

  if($tags.length) {
    var getTags = function() {
      return Cookies.getJSON(COOKIE_NAME) || [];
    };

    var setTag = function(tag) {
      var tags = getTags();
      tags.push(tag);
      return Cookies.set(COOKIE_NAME, tags);
    };

    var unsetTag = function(tag) {
      var tags = getTags();
      tags.splice(tags.indexOf(tag), 1);
      return Cookies.set(COOKIE_NAME, tags);
    };

    var tagExists = function(tag) {
      return getTags().indexOf(tag) > -1;
    };

    var appendTag = function(tag) {
      var $div = $('<div>', { class: 'tag' });
      $div.text(tag);
      return $tags.append($div);
    };

    var removeTag = function(tag) {
      $('.tag', $tags).each(function() {
        if($(this).text() == tag) $(this).remove();
      });
    }

    getTags().forEach(appendTag);

    $('.tag').on('click', function(e) {
      e.stopPropagation();
      e.preventDefault();
      var tag = $(this).text();
      $(this).toggleClass('active', !tagExists(tag))
      if(tagExists(tag)) {
        unsetTag(tag);
        removeTag(tag);
      } else {
        setTag(tag);
        appendTag(tag);
      }
    });

    $('[name=tagger]').on('keyup', function(e) {
      var code = e.keyCode || e.which;
      var triggers = [32, 13, 188];
      if(triggers.indexOf(code) > -1) {
        var val = $(this).val().replace(/[^\d\w]/gi,'');
        if( ! tagExists(val)) {
          setTag(val);
          appendTag(val);
        }
        $(this).val('');
      }
    });
  }
});
