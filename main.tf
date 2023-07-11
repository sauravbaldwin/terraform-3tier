terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.64.0"
    }
  }
}

provider "azurerm" {
  features {
    
  }
}

module "ResourceGroup" {
    source = "./ResourceGroup"   #location of the ResourceGroup Module
    rgname = "az-rg-terraformtest-001"
    location = "East US"

}

module "VirtualNetwork" {
    source = "./VirtualNetwork"
    vnetname = "az-vnet-terraformtest-001"
    rgname = module.ResourceGroup.rg_name_out
    location = "East US"
    nsgname = module.NetworkSecurityGroup.nsgname_out
     
}

module "NetworkSecurityGroup" {
    source = "./NetworkSecurityGroup"
    #nsgname = "${var.vnetname}-subnet1-nsg"
    location = "East US"
    rgname = module.ResourceGroup.rg_name_out
    vnetname = module.VirtualNetwork.vnet_name_out

}

module "ApplicationGateway" {
    source = "./ApplicationGateway"
    apgwname = "azapgwtest001"
    rgname = module.ResourceGroup.rg_name_out
    vnetname = module.VirtualNetwork.vnet_name_out
    location = "East US"
    skuname = "Standard_Small"
    skutier = "Standard"
    skucapacity = 2

  
}

module "KeyVault" {
    source = "./KeyVault"
    akvname = "azakvtest001"
    location = "East US"
    rgname = module.ResourceGroup.rg_name_out
    akvskuname = "Standard"
    tenantid = "2def5af2-7dd0-41bc-8ae2-3424c1e3f64f"
    objectid = "2de4566f5af2-7dd0-41bc-8ae2-3424c1e3f64f"
 
}

module "WebApp" {
    source = "./WebApp"
    aspname = "azasptest001"
    location = "East US"
    rgname = module.ResourceGroup.rg_name_out
    skutier = "Standard"
    skusize = "S1"
    oskind = "Windows"
    aspid = module.azurerm_app_service_plan.asp_id_out

}

module "SQLServer" {
    source = "./SQLServer"
    sqlsername = "azsqltest001"
    rgname = module.ResourceGroup.rg_name_out
    location = "East US"
    adminlogin = "saurav.shekhar"
    adminpassword = "Password@12345"
    adminloginusername = "saurav.shekhar"
    adadminuserobject = "saurav.shekhar"

}