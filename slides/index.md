### start at the command prompt
cd projects

mix phx.new rainforest
cd rainforest

---

### open up another terminal check the existing postgres database
# password : postgres
su - postgres
psql
\list


# go back to the first terminal
# execute the database initialization script and start the server
mix ecto.create
mix phx.server

# after starting the browser, open the url below
# you can see the default welcome page for Phoenix project
http://0.0.0.0:4000/

# go back to the postgres terminal .. check for new database
\list
# connect to the newly created database
\c rainforest_dev
# following command will display table for this database
\dt

---
