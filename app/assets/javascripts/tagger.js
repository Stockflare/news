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
      return Cookies.set(COOKIE_NAME, tags, { expires: 7 });
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

    $('.apply').on('click', function() { location.reload() });

    $('.tag').on('click', function(e) {
      e.stopPropagation();
      e.preventDefault();
      var tag = $(this).text();
      $(this).toggleClass('active', !tagExists(tag));
      $tags.addClass('modified');
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
      var triggers = [32, 13, 188, 8];
      if(triggers.indexOf(code) > -1) {
        var val = $(this).val().replace(/[^\d\w]/gi,'');
        if(code != 8) {
          if( ! tagExists(val) && val.length > 0) {
            setTag(val);
            appendTag(val);
          }
        } else {
          if(val.length == 0) {
            var tags = getTags();
            if(tags.length > 0) {
              var last = tags[tags.length - 1];
              unsetTag(last);
              removeTag(last);
            }
          }
        }
        $tags.addClass('modified');
        $(this).val('');
      }
    });
  }
});
