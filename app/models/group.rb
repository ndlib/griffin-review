class Group < OpenReserves
  self.table_name = 'groups'
  self.primary_key = 'group_name'

  attr_accessible 'group_name'
end
