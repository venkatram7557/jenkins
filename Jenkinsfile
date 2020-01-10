pipeline {
  environment {
    registry = 'cldops/cnginxtest'
    registryCredential = 'jenkins-dockerhub'
    app = ''
  }
  agent any
  stages {
    stage('clone SCM') {
      steps {
        checkout scm
      }
    }
    stage('Build dockerimage') {
      steps{
        script{
/* [working]	app = docker.build registry + ":$BUILD_NUMBER" */
          app = docker.build(registry + ":$BUILD_NUMBER")
      }
     }
    }
    stage('Deploy Image') {
      steps{
        script{
/* [working]       withDockerRegistry([ credentialsId: "jenkins-dockerhub", url: "" ]) { */
          docker.withRegistry( '', registryCredential ) {
/* [working]	  app.push() */
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
       }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:$BUILD_NUMBER"
      }
    }
  }
}
