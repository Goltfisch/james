Template.workspaces.events
  'click a.delete': (event, template) ->
    event.preventDefault()

    workspace =
      _id: @._id

    if (confirm(i18n 'deleteWorkspaceConfirmation'))
      Meteor.call 'deleteWorkspace', workspace, (error) ->
        if error
          alert error.reason
