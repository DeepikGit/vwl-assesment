README with setup instructions.

1)	First setup the terraform with aws cli for the aws account with admin privilege

2)	 Run below commands to provision infra 
a.	Terraform init
b.	Terraform validate
c.	Terraform plan
d.	Terraform apply

3)	Once infra is set, connect EC2 and install required tools
a.	Docker- docker compose
b.	Jenkins-java
c.	Trivy
d.	Semgrep etc

4)	Make sure Jenkins is accessible from URL
a.	Create a job with SCM pipeline
b.	Update git repo
c.	Build the job


