pipeline {
  agent none

  stages {

    stage('Build Docker Image') {
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
  }
}
