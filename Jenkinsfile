pipeline
{
    agent any
    environment
    {
        awscredential = credentials("sayalim-creds")
    }
    parameters {
        string description: 'Subnet ID 1', name: 'subnet_id', trim: true
        string description: 'Security Group', name: 'vpc_security_group_ids', trim: true
        string description: 'Host IP', name: 'hostip', trim: true
        booleanParam(name: 'ec2Plan', description: 'Planning EC2 Instance Deployment')
        booleanParam(name: 'ec2Create', description: 'Creating EC2 Instance')
        booleanParam(name: 'host_IP', description: 'Insert Host IP')
        booleanParam(name: 'playbook', description: 'Run PlayBook')
        booleanParam(name: 'ec2Destroy', description: 'Destroy EC2 Instance')
    }
    stages
    {	
        stage ('git pull')
        {
            steps
            {
                git 'https://github.com/tejasacharekar1/terraform_ansible.git'
            }
        }
         stage('Initiating Terraform configuration')
        {
            steps {
                sh ('terraform init -no-color')
                }
            }
        stage('Planning ec2') {
            when
		    {
		        expression{"${params.ec2Plan}"=="true"}
		    }
            steps {
                sh ('terraform plan --var-file ap-south-ec2.tfvars -var subnet_id=$subnet_id -var vpc_security_group_ids=$vpc_security_group_ids  -no-color')
            }
        }
        stage('Creating ec2') {
            when
		    {
		        expression{"${params.ec2Create}"=="true"}
		    }
            steps {
                sh ('terraform apply --var-file ap-south-ec2.tfvars var subnet_id=$subnet_id -var vpc_security_group_ids=$vpc_security_group_ids --auto-approve -no-color')
            }
        }
		stage('Insert Host IP')
		{
            when
		    {
		        expression{"${params.host_IP}"=="true"}
		    }
			steps
			{
				sh 'echo "[webservers]" >> hosts.inv'
				sh 'echo "$hostip" >> hosts.inv'
			}
		}
        stage('Checking Ansible')
        {
            steps
            {
                sh 'ansible --version'
            }
        }
		stage('Running Playbook for Public Instance')
		{
            when
		    {
		        expression{"${params.playbook}"=="true"}
		    }
			steps
			{
			ansiblePlaybook become: true, becomeUser: 'root', credentialsId: 'sayalim', disableHostKeyChecking: true, installation: 'Ansible', inventory: 'host.inv', playbook: 'httpd_install.yaml'
			}
		}
        stage('Destroy ec2') {
            when
            {
                expression{"${params.ec2Destroy}"=="true"}
            }
            steps {
                sh  'terraform destroy --var-file ap-south-ec2.tfvars --auto-approve -no-color'
            }
        }

    }
}