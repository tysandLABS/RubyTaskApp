pipeline {
  agent {label 'awsDeploy'}
     environment{
      DOCKERHUB_CREDENTIALS = credentials('tsanderson77-dockerhub')
      }
   stages {
     
    stage ('Build') {
      steps {
          sh 'cp /home/ubuntu/prod/Dockerfile . && cp myserver.crt . && cp myserver.key . && docker build -t tsanderson77/tasks_app:v1 . '
    }
}
     stage ('Login') {
        steps {
          sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
}

     stage ('Push') {
        steps {
            sh 'docker push tsanderson77/tasks_app:v1 && docker image rm tsanderson77/tasks_app:v1 && docker system prune -f'
  }
     }
     stage('Init') {
       steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('intTerraform') {
                              sh 'terraform init' 
                            }
         }
    }
   }
      stage('Plan') {
       steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('intTerraform') {
                              sh 'terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"' 
                            }
         }
    }
   }
      stage('Apply') {
       steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('intTerraform') {
                              sh 'terraform apply plan.tfplan' 
                            }
         }
    }
   }

  }
  
}
