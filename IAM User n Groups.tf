#======== Defining backend as S3 to store the state file ========

terraform {
  backend "s3" {
    bucket  = "origamienergy-test-terraform"
    key     = "iam/users/terraform.tfstate"
    region  = "eu-west-2"
    profile = "oe-dev"
    workspace_key_prefix = "workspace"
  }
}

#======== Defining terraform workspace ========

locals {
  map_workspace_profile = {
    dev    = "oe-dev"
    escrow = "oe-escrow"
    prod   = "oe-prod"
  }

  map_workspace_region = {
    dev    = "eu-west-2"
    escrow = "eu-west-2"
    prod   = "eu-west-2"
  }
}

locals {
  profile = "${local.map_workspace_profile [terraform.workspace]}"
  region  = "${local.map_workspace_region  [terraform.workspace]}"
}

#========Defining IAM users========

resource "aws_iam_user" "CI" {
  name        = "${element(var.user_CI,count.index)}"
  count       = "${length(var.user_CI)}"
  lifecycle {
    create_before_destroy = true
 }	
}

resource "aws_iam_user" "Administrator" {
  name = "${element(var.user_admins,count.index)}"
  count = "${length(var.user_admins)}"
  lifecycle {
    create_before_destroy = true
 }      
}

resource "aws_iam_user" "Billing" {
  name = "${element(var.user_billing,count.index)}"
  count = "${length(var.user_billing)}"
  lifecycle {
    create_before_destroy = true
 }      
}

resource "aws_iam_user" "ESAdmin" {
  name = "${element(var.user_ESadmins,count.index)}"
  count = "${length(var.user_ESadmins)}"
  lifecycle {
    create_before_destroy = true
 }      
}

resource "aws_iam_user" "Emailer" {
  name = "${element(var.user_emailer,count.index)}"
  count = "${length(var.user_emailer)}"
  lifecycle {
    create_before_destroy = true
 }      
}

resource "aws_iam_user" "PowerUser" {
  name = "${element(var.user_poweruser,count.index)}"
  count = "${length(var.user_poweruser)}"
  lifecycle {
    create_before_destroy = true
 }      
}

resource "aws_iam_user" "Special" {
  name = "${element(var.user_special,count.index)}"
  count = "${length(var.user_special)}"
  lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_user" "Viewer" {
  name = "${element(var.user_viewer,count.index)}"
  count = "${length(var.user_viewer)}"
  lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_user" "user1" {
 name = "constantin.tarcanu"
 lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_user" "user2" {
 name = "grzegorz.murias"
 lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_user" "user3" {
 name = "alex.bodea"
 lifecycle {
    create_before_destroy = true
 }
}

#======== Defining IAM Groups ========

resource "aws_iam_group" "CI" {
 name = "CI"
} 

resource "aws_iam_group" "Administrator" {
 name = "Administrator"
}

resource "aws_iam_group" "Billing" {
 name = "Billing"
}

resource "aws_iam_group" "Emailer" {
 name = "Emailer"
}

resource "aws_iam_group" "PowerUser" {
 name = "PowerUser"
}

resource "aws_iam_group" "Special" {
 name = "Special"
}

resource "aws_iam_group" "Viewer" {
 name = "Viewer"
}

resource "aws_iam_group" "ElasticSearchAdmin" {
 name = "ElasticSearchAdmin"
}

#======== Defining IAM User and Group membership ========

resource "aws_iam_group_membership" "IAM_CI" {
 name = "IAM-user-group-membership-CI"
 users = [
   "${aws_iam_user.CI.*.name}" 
]
 group = "${aws_iam_group.CI.name}"
}

resource "aws_iam_group_membership" "IAM_Administrator" {
 name = "IAM-user-group-membership-Administrator"
 users = [
   "${aws_iam_user.Administrator.*.name}" 
]
 group = "${aws_iam_group.Administrator.name}"
}

resource "aws_iam_group_membership" "IAM_Billing" {
 name = "IAM-user-group-membership-Billing"
 users = [
   "${aws_iam_user.Billing.*.name}" 
]
 group = "${aws_iam_group.Billing.name}"
}

resource "aws_iam_group_membership" "IAM_ESAdmin" {
 name = "IAM-user-group-membership-ESAdmin"
 users = [
   "${aws_iam_user.ESAdmin.*.name}" 
]
 group = "${aws_iam_group.ElasticSearchAdmin.name}"
}

resource "aws_iam_group_membership" "IAM_Emailer" {
 name = "IAM-user-group-membership-Emailer"
 users = [
   "${aws_iam_user.Emailer.*.name}" 
]
 group = "${aws_iam_group.Emailer.name}"
}

resource "aws_iam_group_membership" "IAM_PowerUser" {
 name = "IAM-user-group-membership-PowerUser"
 users = [
   "${aws_iam_user.PowerUser.*.name}" 
]
 group = "${aws_iam_group.PowerUser.name}"
}

resource "aws_iam_group_membership" "IAM_Special" {
 name = "IAM-user-group-membership-Special"
 users = [
   "${aws_iam_user.Special.*.name}" 
]
 group = "${aws_iam_group.Special.name}"
}

resource "aws_iam_group_membership" "IAM_Viewer" {
 name = "IAM-user-group-membership-Viewer"
 users = [
   "${aws_iam_user.Viewer.*.name}" 
]
 group = "${aws_iam_group.Viewer.name}"
}

#======== Defining IAM Policies and attachment to IAM groups ========

resource "aws_iam_policy_attachment" "EC2ContainerRegistryAWSPolicy" {
 name = "EC2ContainerRegistry"
 count = "${length(var.user_CI)}"
 groups = ["${aws_iam_group.CI.name}"]
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
 lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_policy_attachment" "EC2ContainerServiceAWSPolicy" {
 name = "EC2ContainerService"
 count = "${length(var.user_CI)}"
 groups = ["${aws_iam_group.CI.name}"]
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerServiceFullAccess"
 lifecycle {
    create_before_destroy = true
 }
}
      
resource "aws_iam_policy_attachment" "AdministratorAccessAWSPolicy" {
 name = "AdministratorAccess"
 count = "${length(var.user_admins)}"
 groups = ["${aws_iam_group.Administrator.name}"]
 policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
 lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_policy_attachment" "Billing" {
 name = "ManageOwnCredentials"
 count = "${length(var.user_billing)}"
 groups = ["${aws_iam_group.Billing.name}"]
 policy_arn = "../policies/ManageOwnCredentials.json"
 lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_policy_attachment" "BillingFullAccess" {
 name = "BillingFullAccess"
 count = "${length(var.user_billing)}"
 groups = ["${aws_iam_group.Billing.name}"]
 policy_arn = "../policies/BillingFullAccess.json"
 lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_policy_attachment" "Elasticsearch" {
 name = "elasticsearch-viewer"
 count = "${length(var.user_ESadmins)}"
 groups = ["${aws_iam_group.ElasticSearchAdmin.name}"]
 policy_arn = "../policies/elasticsearch-viewer.json"
 lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_policy_attachment" "CloudWatchAWSPolicy" {
 name = "CloudWatchLogsFullAccess"
 count = "${length(var.user_ESadmins)}"
 groups = ["${aws_iam_group.ElasticSearchAdmin.name}"]
 policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
 lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_policy_attachment" "Emailer" {
 name = "AmazonSesSendingAccess"
 count = "${length(var.user_emailer)}"
 groups = ["${aws_iam_group.Emailer.name}"]
 policy_arn = "../policies/AmazonSesSendingAccess.json"
 lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_policy_attachment" "PowerUser" {
 name = "ManageOwnCredentials"
 count = "${length(var.user_poweruser)}"
 groups = ["${aws_iam_group.PowerUser.name}"]
 policy_arn = "../policies/ManageOwnCredentials.json"
 lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_policy_attachment" "PowerUserAWSPolicy" {
 name = "PowerUserAccess"
 count = "${length(var.user_poweruser)}"
 groups = ["${aws_iam_group.PowerUser.name}"]
 policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
 lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_policy_attachment" "SpecialGroup" {
 name = "certbot-dns-policy"
 count = "${length(var.user_special)}"
 groups = ["${aws_iam_group.Special.name}"]
 policy_arn = "../policies/certbot-dns-policy.json"
 lifecycle {
    create_before_destroy = true
 }
}


resource "aws_iam_policy_attachment" "ViewerGroup" {
 name = "ManageOwnCredentials"
 count = "${length(var.user_viewer)}"
 groups = ["${aws_iam_group.Viewer.name}"]
 policy_arn = "../policies/ManageOwnCredentials.json"
 lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_policy_attachment" "ViewerGroupAWSPolicy" {
 name = "ViewOnlyAccess"
 count = "${length(var.user_viewer)}"
 groups = ["${aws_iam_group.Viewer.name}"]
 policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
 lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_policy_attachment" "inline_policy1" {
 name = "origamiperformance-test"
 users = ["${aws_iam_user.user1.name}"]
 policy_arn = "../policies/origamyenergy-performance-any.test.json"
 lifecycle {
    create_before_destroy = true
 }
}

resource "aws_iam_policy_attachment" "inline_policy2" {
 name = "origami-sftp-test"
 users = ["${aws_iam_user.user1.name}","${aws_iam_user.user2.name}","${aws_iam_user.user3.name}"]
 policy_arn = "../policies/origamyenergy-sftp-any.test.json"
 lifecycle {
    create_before_destroy = true
 }
}