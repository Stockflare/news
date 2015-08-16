$(document).ready(function() {
  $('.vote').click(function(e) {
    e.preventDefault();
    e.stopPropagation();

    var $el = $(this);
    var $voter = $el.closest('.voter');
    var $count = $('p', $voter);
    count = parseInt($count.html());
    var data = $el.data();

    $.ajax({
      url: '/vote',
      type: 'POST',
      data: data,
      complete: function() {
        $voter.removeClass('upvoted downvoted');
        $voter.addClass((data.attitude > 0 ? 'up' : 'down') + 'voted');
        $count.html(data.attitude > 0 ? ++count : --count);
      }
    })
  });
});
