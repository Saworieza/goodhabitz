# Flow:

### Create a user/course db relationship 
* See schema.db
* In the db there are simple users and courses

### Esatablish a basic OAuth connection 
* users_controller establishes a basic oauth connection, returning an oauth hash 
* I'd like to refactor this into a helper method or more readable series of methods- it doesn't need to all be in one huge method 

### Send custom lti parameters to good habitz 
* parameters are defined in the controller in custom_params hash 
* user_id is defined in the browser (enter it at root)
* put these paramters in through a hidden field in create.html.erb

### Re-direct to the good habitz course page 
* form action sends action to an example course page URL 
* redirect_to path at the end of the method 