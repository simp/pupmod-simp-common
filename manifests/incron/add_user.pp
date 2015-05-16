# _Description_
#
# Add the user $name to /etc/incron.allow
#
# _Variables_
# * $name
#   The user to add to /etc/incron.allow
#
define common::incron::add_user
{
  include 'common::incron'

  concat_fragment { "incron+$name.user":
    content =>  "$name\n"
  }
}
