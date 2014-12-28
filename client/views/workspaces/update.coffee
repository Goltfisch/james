Template.updateWorkspace.events
  'submit #update-workspace-form': (event, template) ->
    event.preventDefault()

    name = template.find('#name').value
    description = template.find('#description').value

    workspace =
      _id: template.data.workspace._id
      name: name
      description: description

    Meteor.call 'updateWorkspace', workspace, (error) ->
      if error
        alert error.reason
      else
        Router.go 'workspaces'
