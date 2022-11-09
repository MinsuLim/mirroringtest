pipeline {
  agent none

  stages {
    // stage('Notify starting job') {
    //   agent {
    //     label 'master'
    //   }
    //   // steps {
    //   //   slackSend(
    //   //     channel: "#it_notifications", 
    //   //     color: "#EEEEEE", 
    //   //     message: "[Starting] ${env.JOB_NAME} #${env.BUILD_NUMBER} (<${env.RUN_DISPLAY_URL}|Open>)"
    //   //   )
    //   // }
    // }
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

  post {
    success {
      slackSend(
        channel: "#it_notifications", 
        color: "good", 
        message: "[Successful] ${env.JOB_NAME} #${env.BUILD_NUMBER} (<${env.RUN_DISPLAY_URL}|Open>)"
      )
    }
    failure {
      slackSend(
        channel: "#it_notifications", 
        color: "danger", 
        message: "[Failed] ${env.JOB_NAME} #${env.BUILD_NUMBER} @channel (<${env.RUN_DISPLAY_URL}|Open>)"
      )
    }
  }
}
