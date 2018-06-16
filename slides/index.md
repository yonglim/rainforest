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

# go back to the phoenix terminal
# exit the server by issuiong the command Ctrl-C twice

# We want to generate a Product model with corresponding files

mix phx.gen.html Warehouse Product products productName:string stock:integer sellingPrice:float


# open up the Atom editor
# add a project directory ~/projects/rainforest
# then add the resource to your browser scope in lib/rainforest_web/router.ex:
# add the following line within the scope block of RainforestWeb
    resources "/products", ProductController

# you can now start the server and goto the product page in the browser
mix phx.server
http://0.0.0.0:4000/products

# add a few products in the page and now you can also check back at the postgres terminal
# you should be connected to the rainforest_dev database

# display the table, you should see the product table
\dt

# see a listing in the table
select * from products;

---

# testing
# all the appropriate CRUD tests are generated
# execute these tests

mix test

# check the postgres databases
# you will see that a test database "rainforest_test" is created
\list

---

# Lessons learned (workshop1 part1)
# easy to create a working webapp with Phoenix / Elixir / Postgres
# supports Html and Json (abit of that later)
# can create backing database easily
# has test framework ready

---

### workshop1 part2
# tests with some coding

# add tests to check for prevent negative stock and sellingPrice
#    file : /test/rainforest/warehouse_test.exs
# and execute these tests to see the failures
mix test

# naming convention
# ! ?
https://hexdocs.pm/elixir/naming-conventions.html

# pass the failing test
# edit the file lib/rainforest/warehouse/product.ex
# lets talk about piping
# Eco.Changeset
https://hexdocs.pm/ecto/Ecto.Changeset.html#validate_number/3

# execute the test again
mix test
