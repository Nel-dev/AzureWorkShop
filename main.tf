// https://developer.hashicorp.com/terraform/language/settings/backends/azurerm
terraform {
  backend "azurerm" {
    resource_group_name  = "Terraform-ResourceGroup"
    storage_account_name = "pandatfstates6666"
    container_name       = "tfstate"
    key                  = "panda.tfstate"
  }
}

// https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "Panda-ResourceGroup"
  location = var.location
}

resource "azurerm_service_plan" "backend" {
  name                     = "Backend-ServicePlan"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  os_type                  =  "Linux"
  sku_name                 =  "P1v2"
}

resource "azurerm_Linux_web_app" "backend" {
  name                = "Backend-webapp-6666"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.backend.location
  service_plan_id     = azurerm_service_plan.backend.id

  site_config {
    application_stack{
      docker_image_name = "appsvc/staticsite:latest"
    }
  }
}

/* resource "azurerm_storage_account" "panda" {
  name                     = replace("${var.owner}storage", "-", "")
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
} */

/* resource "azurerm_storage_container" "default" {
  name                  = "${var.owner}-container"
  storage_account_name  = azurerm_storage_account.panda.name
  container_access_type = "private"
} */