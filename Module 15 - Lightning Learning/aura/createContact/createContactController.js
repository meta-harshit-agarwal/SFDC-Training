({
    doInit : function(component, event, helper) {
       
        component.set("v.columns", [
            {label : "FirstName", fieldName : "FirstName", type : 'text' },
            {label : "LastName", fieldName : "LastName", type : 'text' },
            {label : "Phone", fieldName : "Phone", type : 'phone' },
            {label : "Email", fieldName : "Email", type : 'email' },
            {label : "Fax", fieldName : "Fax", type : 'phone' },
        ]);
        
        /*var action = component.get("c.getContact");
         action.setCallback(this, function(response){
            var state = response.getState();
             
            if(state === "SUCCESS"){
            	component.set("v.contacts", response.getReturnValue());
            }
            });
            $A.enqueueAction(action);*/
        
    },
	create : function(component, event, helper) {
        
        var ValidForm = component.find('contactForm').reduce( function(validSoFar , inputItem){
            inputItem.showHelpMessageIfInvalid();
            return validSoFar && inputItem.get('v.validity').valid;
        }, true);
        
        if(ValidForm){
            var newContact = component.get("v.contact");
            var contacts = component.get("v.contacts");
            helper.createContact(component, newContact, contacts);
        }
		
	}
})