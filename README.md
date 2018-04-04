## Setup

### Create database accounts

```
createuser -U postgres my_todo
createuser -U postgres my_todo_password
```

### Load extensions

```
psql -U postgres -c "CREATE EXTENSION citext" my_todo_development
```
