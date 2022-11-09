pipeline {
  agent none

  stages {

    stage('Build Docker Image - CodeBuild') {
      agent {
        label 'master'
      }
      steps {
        echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}"  

        awsCodeBuild(
          credentialsType: 'keys',
          projectName: 'tutorial',
          region: 'ap-northeast-2',
          sourceControlType: 'jenkins',
          sseAlgorithm: 'AES256',
          buildSpecFile: "ci/${env.BRANCH_NAME}/buildspec.yml"
        )
      }
    }
    
    stage('Build Docker Image - EC2') {
      agent {
        label 'ecs-agent'
      }
      steps {
        echo "${env.JOB_NAME} / ${env.BUILD_NUMBER}"  
        echo '''
          aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr
          docker build -t jenkins_tutorial .
          docker tag jenkins_tutorial:latest 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr/jenkins_tutorial:latest
          docker push 056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins_codebuild_ecr/jenkins_tutorial:latest

        '''
    }







  }
}
