## Convos

##### Messaging web service for Etsy.

---

### Database

#### Entities

**Users**
- **user_id.** Is the auto-incremental integer primary key.
- **user_name.** Is the string that uniquely identifies the user's name.

**Convos**
- **convo_id.** Is the auto-incremental integer primary key.
- **thread_convo_id.** Is the foreign key (to the same table) for those convos part of the same intial thread (via convo_id).
- **sender_user_id.** Is the foreign key identying the sender User.
- **recipient_user_id.** Is the foreign key identying the recipient User.
- **subject_line.** Is the 140 character max string column storing the subject line.
- **body.** Is the text column storing the body (type default max is 64K).
- **state.** Is the string column that describe the state of the record: "new" or "read".

Both tables include timestamps **created_at** and **updated_at**.

#### Relationships

- **Convos** belong to a **Sender User**
- **Convos** belong to a **Recipient User**
- **Convos** have zero to many subsequent **Thread Convos**
- **Thread Convos** belong to an initial **Convo**
- **Sender Users** have zero to many **Sent Convos**
- **Recipient Users** have zero to many **Received Convos**

---

### API

#### Users

##### *POST /api/users*

- **200.** The User was found.

  > POST /api/users

  ````json
  REQUEST
  {
    "user": {
      "user_name": "geppetto"
    }
  }
  
  RESPONSE
  {
    "user": {
      "user_id": 1,
      "user_name": "geppetto"
    }
  }

  ````

- **201.** The User was created.

  > POST /api/users

  ````json
  REQUEST
  {
    "user": {
      "user_name": "figaro"
    }
  }
  
  RESPONSE
  {
    "user": {
      "user_id": 2,
      "user_name": "figaro"
    }
  }
  ````

- **400.** The User was not created.

  > POST /api/users

  ````json
  RESPONSE
  {
    "error": "User not created"
  }
  ````

This endpoint posts the user given the user_name param passed. It returns the user in DB if the User exists or creates one if there is no User with the same user_name. In case the User is not found and cannot be created, it will error.

##### *GET /api/users/:user_name*

- **200.** The User was found.

  > GET /api/users/geppetto

  ````json
  RESPONSE
  {
    "user": {
      "user_id": 1,
      "user_name": "geppetto"
    }
  }
  ````
- **404.** The User was not found.

  > GET /api/users/dogfish

  ````json
  RESPONSE
  {
    "error": "User not found"
  }
  ````

This endpoint gets the user given the user_name param passed. It is recommended to authenticate users in order to access to this resource, for now, entering a valid user_name makes the resource available for the client to use as the session current user.
