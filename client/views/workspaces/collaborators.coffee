Template.collaborators.events
  'submit #add-collaborator-form': (event, template) ->
    event.preventDefault()

    email = template.find('#email').value

    collaborator =
      email: email
      workspaceId: template.data.workspace._id

    Meteor.call 'addCollaborator', collaborator, (error) ->
      if error
        alert error.reason
      else
        template.find('#email').value = ''

  'click a.remove-collaborator': (event, template) ->
    event.preventDefault()

    collaborator =
      _id: @._id
      workspaceId: template.data.workspace._id

    if (confirm(i18n 'removeCollaboratorConfirmation'))
      Meteor.call 'removeCollaborator', collaborator, (error) ->
        if error
          alert error.reason

Template.collaborators.helpers
  getEmail: (user) ->
    user.emails[0].address
