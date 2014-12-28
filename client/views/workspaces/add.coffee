Template.addWorkspace.events
  'submit #add-workspace-form': (event, template) ->
    event.preventDefault()

    name = template.find('#name').value
    description = template.find('#description').value

    workspace =
      name: name
      description: description

    Meteor.call 'addWorkspace', workspace, (error) ->
      if error
        alert error.reason
      else
        Router.go 'workspaces'
