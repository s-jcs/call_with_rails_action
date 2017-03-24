# Originally based on http://www.ohmyenter.com/execute-javascript-on-a-page-on-rails/
# Call the given callback function when the indicated page is loaded
#
# Args are expected to contain controller and actions
# Controllers are expected to be String while actions can either be String or Array
#
# Req:
#     The body of application.html must contain `data-controller` and `data-action`
#
# body data-controller="#{controller_path}" data-action="#{action_name}"
#
# Usage:
#
# onPageLoad {controller: 'posts', actions: 'index'}, ->
#   # Do something when controller is 'posts' and action is 'index'.
#
# onPageLoad {controller: 'posts'}, ->
#   # Do something when controller is 'posts' (in any action).
#
# onPageLoad {controller: 'posts', actions: ['index', 'show']}, ->
#   # Do something when controller is 'posts' and action is index or show (set multiple actions with array).

@callWithRailsAction = (args, callback) ->

  document.addEventListener 'turbolinks:load', ->

    controller = args.controller
    actions    = args.actions

    unless actions
      callback() if isOnPage(controller)
    else
      regularize(actions).forEach (action) ->
        callback() if isOnPage(controller, action)

regularize = (actions) ->
  if typeof(actions) == 'string'
    [actions]
  else if actions instanceof Array
    actions
  else
    []

isOnPage = (controller, action = false) ->
  selector = "body[data-controller='#{controller}']"
  selector += "[data-action='#{action}']" if action
  document.querySelector(selector) != null

