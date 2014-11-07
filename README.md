## Convos

##### Messaging web service for Etsy.

---

1. [Database](https://github.com/oso-mate/convos/blob/master/README.md#database)
  1. [Entities](https://github.com/oso-mate/convos/blob/master/README.md#entities)
  2. [Relationships](https://github.com/oso-mate/convos/blob/master/README.md#relationships)
2. [API](https://github.com/oso-mate/convos/blob/master/README.md#api)
  1. [Users](https://github.com/oso-mate/convos/blob/master/README.md#users)
    1. [POST /api/users](https://github.com/oso-mate/convos/blob/master/README.md#post-apiusers)
    2. [GET /api/users/:user_name](https://github.com/oso-mate/convos/blob/master/README.md#get-apiusersuser_name)
  - [Convos](https://github.com/oso-mate/convos/blob/master/README.md#convos-1)
    - [POST /api/convos](https://github.com/oso-mate/convos/blob/master/README.md#post-apiconvos)
    - [PATCH /api/convos/:convo_id](https://github.com/oso-mate/convos/blob/master/README.md#patch-apiconvos)
    - [GET /api/convos](https://github.com/oso-mate/convos/blob/master/README.md#get-apiconvos)
    - [GET /api/convos/:convo_id](https://github.com/oso-mate/convos/blob/master/README.md#get-apiconvosconvo_id)

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
      "user_id": 11,
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
      "user_id": 12,
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
      "user_id": 11,
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

#### Convos

##### *POST /api/convos*

- **201.** The Convo was created.

  > POST /api/convos (initial)

  ````json
  REQUEST
  {
    "convo": {
      "sender_user_id": 11,
      "recipient_user_id": 12,
      "subject_line": "I have an idea!",
      "body": "Meet me downstairs, let's get some wood!"
    }
  }
  
  RESPONSE
  {
    "convo": {
      "convo_id": 1001,
      "state": "new",
      "created_at": "1888-12-01 13:00:00"
    }
  }
  ````

  > POST /api/convos (thread convo)

  ````json
  REQUEST
  {
    "convo": {
      "thread_convo_id": 1001,
      "sender_user_id": 12,
      "recipient_user_id": 11,
      "subject_line": "I have an idea!",
      "body": "Meow."
    }
  }
  
  RESPONSE
  {
    "convo": {
      "convo_id": 1002,
      "thread_convo_id": 1001,
      "state": "new",
      "created_at": "1888-12-01 13:01:00"
    }
  }
  ````

- **400.** The Convo was not created.

  > POST /api/convos
  
  ````json
  RESPONSE
  {
    "error": "Convo not created"
  }
  ````
  
##### *PATCH /api/convos/:convo_id*

- **200.** The Convo was updated.

  > PATCH /api/convos/1001
  
  ````json
  REQUEST
  { 
    "convo": {
      "receiver_user_id": 12,
      "status": "read"
    }
  }
  ````
  
##### *GET /api/convos*

Responds with an index list of convos based in the params specified (one required in bold).

| Parameters             | Description                                |
| ---------------------- | ------------------------------------------ |
| **user_id**            | For the User given as recipient and sender |
| **sender_user_id**     | For the User given as sender               |
| **recipient_user_id**  | For the User given as recipient            |
| state                  | State of the convo: "new" or "read"        |

- **200.** The Convos were found.

  > GET /api/convos/?user_id=11 (For the User given as recipient and sender)
  
  ````json
  RESPONSE
  {
    "convos": [
      {
        "convo_id": 1001,
        "sender_user_id": 11,
        "recipient_user_id": 12,
        "subject_line": "I have an idea!",
        "body": "Meet me downstairs, let's get some wood!",
        "state": "read",
        "created_at": "1888-12-01 13:00:00",
        "thread_convos": [
          {
            "convo_id": 1002,
            "sender_user_id": 12,
            "recipient_user_id": 11,
            "subject_line": "I have an idea!",
            "body": "Meow."
            "state": "read"
            "created_at": "1888-12-01 13:01:00",
            "updated_at": "1888-12-01 13:02:00"
          }
        ]
      },
      {
        "convo_id": 999,
        "sender_user_id": 9,
        "recipient_user_id": 11,
        "subject_line": "I will visit you soon!",
        "body": "Keep windows clear, I am a Fairy with Blue Hair.",
        "state": "new",
        "created_at": "1888-11-01 13:00:00",
        "thread_convos": []
      }
    ]
  }
  ````
  
  > GET /api/convos/?sender_user_id=11 (For the User given as sender)
  
  ````json
  RESPONSE
  {
    "convos": [
      {
        "convo_id": 1001,
        "sender_user_id": 11,
        "recipient_user_id": 12,
        "subject_line": "I have an idea!",
        "body": "Meet me downstairs, let's get some wood!",
        "state": "read",
        "thread_convos": [
          {
            "convo_id": 1002,
            "sender_user_id": 2,
            "recipient_user_id": 1,
            "subject_line": "I have an idea!",
            "body": "Meow."
            "state": "read"
            "created_at": "",
            "updated_at": ""
          }
        ]
      }
    ]
  }
  ````
  
  > GET /api/convos/?recipient_user_id=11 (For the User given as recipient)
  
  ````json
  RESPONSE
  {
    "convos": [
      {
        "convo_id": 999,
        "sender_user_id": 9,
        "recipient_user_id": 11,
        "subject_line": "I will visit you soon!",
        "body": "Keep windows clear, I am a Fairy with Blue Hair.",
        "state": "new",
        "created_at": "1888-11-01 13:00:00",
        "thread_convos": []
      }
    ]
  }
  ````
  
  > GET /api/convos/?user_id=11&state=new (New Convos For the User given as recipient and sender)
  
  ````json
  RESPONSE
  {
    "convos": [
      {
        "convo_id": 999,
        "sender_user_id": 9,
        "recipient_user_id": 11,
        "subject_line": "I will visit you soon!",
        "body": "Keep windows clear, I am a Fairy with Blue Hair.",
        "state": "new",
        "created_at": "1888-11-01 13:00:00",
        "thread_convos": []
      }
    ]
  }
  ````
  
  > GET /api/convos/?user_id=11&state=read (Read Convos For the User given as recipient and sender)
  
  ````json
  RESPONSE
  {
    "convos": [
      {
        "convo_id": 1001,
        "sender_user_id": 11,
        "recipient_user_id": 12,
        "subject_line": "I have an idea!",
        "body": "Meet me downstairs, let's get some wood!",
        "state": "read",
        "created_at": "1888-12-01 13:00:00",
        "thread_convos": [
          {
            "convo_id": 1002,
            "sender_user_id": 12,
            "recipient_user_id": 11,
            "subject_line": "I have an idea!",
            "body": "Meow."
            "state": "read"
            "created_at": "1888-12-01 13:01:00",
            "updated_at": "1888-12-01 13:02:00"
          }
        ]
      }
    ]
  }
  ````

- **404.** The Convos were not found.

  > GET /api/convos/?user_id=8 (For the User given as recipient and sender)
  
  ````json
  RESPONSE
  {
    "error": "Convos not found"
  }
  ````
  
- **400.** The Convos cannot be retrieved without a required user identifier

  > GET /api/convos/?state=new (New Convos without passing a user identifier: user_id, sender_user_id, recipient_user_id)
  
  ````json
  RESPONSE
  {
    "error": "Parameter missing"
  }
  ````

##### *GET /api/convos/:convo_id*

- **200.** The Convo was found.

  > GET /api/convos/1001
  
  ````json
  RESPONSE
  {
    "convo": {
      "convo_id": 1001,
      "sender_user_id": 11,
      "recipient_user_id": 12,
      "subject_line": "I have an idea!",
      "body": "Meet me downstairs, let's get some wood!",
      "state": "read",
      "created_at": "1888-12-01 13:00:00",
      "thread_convos": [
        {
          "convo_id": 1002,
          "sender_user_id": 12,
          "recipient_user_id": 11,
          "subject_line": "I have an idea!",
          "body": "Meow."
          "state": "read"
          "created_at": "1888-12-01 13:01:00",
          "updated_at": "1888-12-01 13:02:00"
        }
      ]
    }
  }
  ````
  
- **404.** The Convo was not found.

  > GET /api/convos/1999
  
  ````json
  RESPONSE
  {
    "error": "Convo not found"
  }
  ````
  
