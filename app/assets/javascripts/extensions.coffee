$ = jQuery

# methods

$.fn.prependIcon = (name) ->
  @.each -> $(@).prepend "<i class=\"icon-#{name}\"> "

$.fn.appendIcon = (name) ->
  @.each -> $(@).append " <i class=\"icon-#{name}\">"

# properties

$.removeButton = $ '<button>',
  type: 'button'
  tabindex: -1
.addClass('remove')
.prependIcon('cancel')

$.addButton = $ '<a>',
  href: '#'
.addClass('add')
.text(' Dodaj')
.prependIcon('plus')

$.timer = $('<div>')
.addClass('timer')
.prependIcon('stopwatch')
.append $('<span>', {class: 'time'})

$.loader = $('<div>')
.addClass('loader')
.prependIcon('loading')

# functions

$.flashMsg = (msg, name) ->
  $flash = $('<div>').addClass("flash #{name}")

  $button = $.removeButton
    .clone()
    .appendTo($flash)

  $msg = $('<p>').append(msg)

  $flash
    .append($msg)
    .prependTo('#main')

  $button.on 'click', -> $flash.fadeOut('fast')

# globals

window.App =
  Controllers: {}
  Questions: {}
