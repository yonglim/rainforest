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

---

# before proceeding further, let’s look at the directory structure first
#
# /_build - where the code is compiled to .beam files (every much like .class file for Java)
#             one subdirectory for each environment (/dev, /test)
#
# /config - where we setup the environment
#               look at dev.exs .. it has ports and postgres connection info
#
# mix.exs and /deps - configuration and dependencies for phoenix
#                                 /cowboy (web server)
#                                 /poolboy (connection pool manager)
#
# /lib - our code goes here ..
#          /lib/<appname> … /lib/rainforest :: our data models .. NOT related to the web request handling
#          /lib/<appname>_web … /lib/rainforest_web :: related to the web request handling
#                   /channels - web-sockets
#                   /views and  /templates - subfolder to generate the display
#                   /controllers - controls the action of the page ..
#                   router.ex ..

# lets looks more closely at router.ex … entry point to the web-application
#        defmodule .. defining a elixir module .. function are within context of modules
#            RainforestWeb … module name .. always start with capital letter
#               .Router … dot-notation to create a namespace structure
#
# https://hexdocs.pm/phoenix/routing.html

---

# USer Authentication
# lets create User model
mix phx.gen.html Accounts User users username:string:unique usertype:string encrypted_password:string

# add to the following router.ex
resources "/registrations", UserController, only: [:create, :new]

# then execute ..
mix ecto.migrate

---

# change user_controller.ex .. just keep new and create functions..
#       also change "create" function redirect to product_path(conn, :index)     ... instead of user_path


# also delete unnecessary template … /templates … edit / index / show

# edit the new.html.eex .. <h2>Sign Up</h2>  ...  delete the "Back" link line
# edit the form.html.eex … change label to just password .. also change it to password_input

# conn  .. https://hexdocs.pm/plug/Plug.Conn.html
# https://elixirforum.com/t/what-is-conn-and-changeset/2392
# https://devhints.io/phoenix-conn

# add to lines to /lib/rainforest_be/templates/layout/app.html.eex .. to the "main" tag
<%= link "Home", to: product_path(@conn, :index) %> |
<%= link "Sign up", to: user_path(@conn, :new) %>

# the above product_path and user_path are path helpers
# https://hexdocs.pm/phoenix/routing.html#path-helpers
# https://devhints.io/phoenix-routing
product_path(@conn, :index) .. equivalent to  .. /products
user_path(@conn, :new) .. equivalent to  .. /users/new

# goto the product page you can see the 2 links are added
http://0.0.0.0:4000/products

---

# add dependencies in the mix.exs (top level of the directory structure)
# commonin
# https://hex.pm/packages/comeonin
{:comeonin, "~> 4.1.1"},
{:bcrypt_elixir, "~> 1.0"},

# execute the following in the command line .. to get the new dependencies
mix deps.get

# update the user model to encrypt password … lib/rainforest/accounts/user.ex
# update the changeset

# set user_id to the session
# file :  /lib/rainforest_web/controller/user_controller.ex

---

# create a folder /lib/rainforest_web/helpers
# create a new file in this folder auth.ex

# since we are going to use this very often, we will include this module in all our views
# /lib/rainforest_web.ex .. def view section
import RainforestWeb.Helpers.Auth, only: [signed_in?: 1]
