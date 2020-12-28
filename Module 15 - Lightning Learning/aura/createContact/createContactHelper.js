({
	createContact : function(component, newContact, contacts) {
		var createAction = component.get("c.saveContact");
        createAction.setParams({"contact" : newContact});
        createAction.setCallback(this, function(data){
            var state = data.getState();
            if(state === "SUCCESS"){
                var msg = data.getReturnValue();
                if(msg[0] === "success"){
                    component.set("v.message", "Contact Created Successfully With Id : " + msg[1]);
                    contacts.unshift(newContact);
                    component.set("v.isRecordAvailable", true);
                    component.set("v.contacts", contacts);
                    component.set("v.contact",{'sObjectType':'Contact',
                              					'FirstName' : '',
                              					'LastName'  : '',
                              					'Email'     : '',
                              					'Phone'     : '',
                              					'Fax'       : ''   });
                }else{
                   component.set("v.message", "Error Occure While Insert "+ msg[1]);  
                }
            }
        });
        $A.enqueueAction(createAction);
	}
})