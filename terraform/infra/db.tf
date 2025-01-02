# Базы для сервисов создаются по циклу из var.databases
# Список баз находится в root.hcl
# Пароли задаются в `<proj_dir>/sensitive/passwords.yaml`, в объекте `postgres.db.<service_name>`

resource "postgresql_role" "db_role" {
  for_each = var.databases
  name     = each.key
  login    = true
  password = var.db_passwords[each.key]
}

resource "postgresql_database" "db" {
  for_each = var.databases
  name     = each.key
  owner    = each.key

  depends_on = [ 
    postgresql_role.db_role,
  ]
}
